include(${CMAKE_SOURCE_DIR}/cmake/common_module_utils.cmake)

function(add_library_module)
  cmake_parse_arguments(ARG "" "NAME" "SOURCES;DEPENDENCIES" ${ARGN})

  get_module_project_name(MODULE_PROJECT_NAME)
  project(${MODULE_PROJECT_NAME})

  add_library(${PROJECT_NAME} STATIC ${ARG_SOURCES})

  set_common_target_properties(${PROJECT_NAME})
  add_target_dependencies(${PROJECT_NAME} DEPENDENCIES ${ARG_DEPENDENCIES})

  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/test/CMakeLists.txt)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/test)
  endif()
endfunction()
