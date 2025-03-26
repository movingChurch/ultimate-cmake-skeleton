function(get_module_project_name OUTPUT_VARIABLE)
  get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
  set(${OUTPUT_VARIABLE} "${PROJECT_NAME}__${MODULE_NAME}" PARENT_SCOPE)
endfunction()
