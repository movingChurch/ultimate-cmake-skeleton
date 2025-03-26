include(${CMAKE_SOURCE_DIR}/cmake/module/common/set_target_compile_properties.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/module/common/add_target_dependencies.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/module/common/get_module_project_name.cmake)

function(add_library_module)
  cmake_parse_arguments(ARG "" "NAME" "SOURCES;DEPENDENCIES" ${ARGN})

  get_module_project_name(MODULE_PROJECT_NAME)
  project(${MODULE_PROJECT_NAME})

  add_library(${PROJECT_NAME} STATIC ${ARG_SOURCES})

  set_target_compile_properties(${PROJECT_NAME})
  add_target_dependencies(${PROJECT_NAME} DEPENDENCIES ${ARG_DEPENDENCIES})

  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/test/CMakeLists.txt)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/test)
  endif()
endfunction()
