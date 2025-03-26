include(${CMAKE_SOURCE_DIR}/cmake/module/test/add_category_tests.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/module/test/add_test_module.cmake)

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
