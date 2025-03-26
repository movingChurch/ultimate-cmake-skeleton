function(set_common_target_properties TARGET_NAME)
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(${TARGET_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
  endif()

  target_compile_features(${TARGET_NAME} PRIVATE ${COMPILER_FEATURES})
  target_compile_options(${TARGET_NAME} PRIVATE ${COMPILER_FLAGS})
endfunction()

function(add_target_dependencies TARGET_NAME)
  cmake_parse_arguments(ARG "" "" "DEPENDENCIES" ${ARGN})

  if(ARG_DEPENDENCIES)
    target_link_libraries(${TARGET_NAME} PRIVATE ${ARG_DEPENDENCIES})
  endif()
endfunction()

function(get_module_project_name OUTPUT_VAR)
  get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
  set(${OUTPUT_VAR} "${PROJECT_NAME}__${MODULE_NAME}" PARENT_SCOPE)
endfunction()
