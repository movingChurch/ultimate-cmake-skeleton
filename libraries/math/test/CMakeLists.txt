cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

function(create_test_target NAME SOURCES)
  add_executable(${NAME} ${SOURCES})

  target_compile_features(${NAME} PRIVATE ${COMPILER_FEATURES})
  target_compile_options(${NAME} PRIVATE ${COMPILER_FLAGS})

  target_link_libraries(${NAME}
    PRIVATE gtest gtest_main ${PROJECT_NAME}
  )
endfunction()

set(ALL_TEST_FILES "")
file(GLOB TEST_TYPES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*")

foreach(TEST_TYPE ${TEST_TYPES})
  if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${TEST_TYPE})
    file(GLOB TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_TYPE}/*.cpp")
    set(${TEST_TYPE}_TEST_FILES "")

    foreach(TEST_FILE ${TEST_FILES})
      get_filename_component(TEST_NAME ${TEST_FILE} NAME_WE)
      create_test_target(${PROJECT_NAME}__${TEST_TYPE}__${TEST_NAME} ${TEST_FILE})

      list(APPEND ${TEST_TYPE}_TEST_FILES ${TEST_FILE})
      list(APPEND ALL_TEST_FILES ${TEST_FILE})
    endforeach()

    create_test_target(${PROJECT_NAME}__${TEST_TYPE}__all_tests "${${TEST_TYPE}_TEST_FILES}")
  endif()
endforeach()

create_test_target(${PROJECT_NAME}__all_tests "${ALL_TEST_FILES}")
