function(add_target_dependencies TARGET_NAME)
  cmake_parse_arguments(ARGUMENTS "" "" "DEPENDENCIES" ${ARGN})

  if(ARGUMENTS_DEPENDENCIES)
    target_link_libraries(${TARGET_NAME} PRIVATE ${ARGUMENTS_DEPENDENCIES})
  endif()
endfunction()
