include(${CMAKE_SOURCE_DIR}/cmake/common_module_utils.cmake)

function(add_test_module)
  cmake_parse_arguments(ARG "" "TARGET" "SOURCES;DEPENDENCIES" ${ARGN})

  add_executable(${ARG_TARGET} ${ARG_SOURCES})

  set_common_target_properties(${ARG_TARGET})

  # 테스트 특화 의존성 추가
  target_link_libraries(${ARG_TARGET}
    PRIVATE
    gtest
    gtest_main
    ${PROJECT_NAME}
  )
  add_target_dependencies(${ARG_TARGET} DEPENDENCIES ${ARG_DEPENDENCIES})
endfunction()

function(add_test_suite)
  set(ALL_TEST_FILES "")
  file(GLOB TEST_TYPES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*")

  foreach(TEST_TYPE ${TEST_TYPES})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${TEST_TYPE})
      file(GLOB TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_TYPE}/*.cpp")
      set(${TEST_TYPE}_TEST_FILES "")

      foreach(TEST_FILE ${TEST_FILES})
        get_filename_component(TEST_NAME ${TEST_FILE} NAME_WE)
        add_test_module(
          TARGET ${PROJECT_NAME}__${TEST_TYPE}__${TEST_NAME}
          SOURCES ${TEST_FILE}
        )

        list(APPEND ${TEST_TYPE}_TEST_FILES ${TEST_FILE})
        list(APPEND ALL_TEST_FILES ${TEST_FILE})
      endforeach()

      add_test_module(
        TARGET ${PROJECT_NAME}__${TEST_TYPE}__all_tests
        SOURCES "${${TEST_TYPE}_TEST_FILES}"
      )
    endif()
  endforeach()

  add_test_module(
    TARGET ${PROJECT_NAME}__all_tests
    SOURCES "${ALL_TEST_FILES}"
  )
endfunction()