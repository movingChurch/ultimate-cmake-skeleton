include(${CMAKE_SOURCE_DIR}/cmake/common_module_utils.cmake)

function(create_test_executable)
  cmake_parse_arguments(ARGUMENTS "" "TARGET" "SOURCES;DEPENDENCIES" ${ARGN})

  if(ARGUMENTS_SOURCES)
    add_executable(${ARGUMENTS_TARGET} ${ARGUMENTS_SOURCES})
    set_target_compile_properties(${ARGUMENTS_TARGET})

    target_link_libraries(${ARGUMENTS_TARGET}
      PRIVATE
      gtest
      gtest_main
      ${PROJECT_NAME}
    )
    add_target_dependencies(${ARGUMENTS_TARGET} DEPENDENCIES ${ARGUMENTS_DEPENDENCIES})
  endif()
endfunction()

function(add_test_module)
  cmake_parse_arguments(ARGUMENTS "" "TARGET" "SOURCES;DEPENDENCIES" ${ARGN})

  if(ARGUMENTS_SOURCES)
    create_test_executable(
      TARGET ${ARGUMENTS_TARGET}
      SOURCES ${ARGUMENTS_SOURCES}
      DEPENDENCIES ${ARGUMENTS_DEPENDENCIES}
    )
  endif()
endfunction()

function(add_test_suite)
  set(ALL_TEST_FILES "")
  file(GLOB TEST_CATEGORIES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*")

  foreach(TEST_CATEGORY ${TEST_CATEGORIES})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${TEST_CATEGORY})
      add_category_tests(${TEST_CATEGORY} ALL_TEST_FILES)
    endif()
  endforeach()

  if(ALL_TEST_FILES)
    add_test_module(
      TARGET ${PROJECT_NAME}__all_tests
      SOURCES "${ALL_TEST_FILES}"
    )
  endif()
endfunction()

function(add_category_tests TEST_CATEGORY ALL_TEST_FILES_VAR)
  file(GLOB TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_CATEGORY}/*.cpp")
  set(CATEGORY_TEST_FILES "")

  if(TEST_FILES)
    foreach(TEST_FILE ${TEST_FILES})
      get_filename_component(TEST_NAME ${TEST_FILE} NAME_WE)
      add_test_module(
        TARGET ${PROJECT_NAME}__${TEST_CATEGORY}__${TEST_NAME}
        SOURCES ${TEST_FILE}
      )

      list(APPEND CATEGORY_TEST_FILES ${TEST_FILE})
    endforeach()

    add_test_module(
      TARGET ${PROJECT_NAME}__${TEST_CATEGORY}__all_tests
      SOURCES "${CATEGORY_TEST_FILES}"
    )

    set(${ALL_TEST_FILES_VAR} ${${ALL_TEST_FILES_VAR}} ${CATEGORY_TEST_FILES} PARENT_SCOPE)
  endif()
endfunction()
