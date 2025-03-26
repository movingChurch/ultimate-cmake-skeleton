include(${CMAKE_SOURCE_DIR}/cmake/module/test/add_test_module.cmake)

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
