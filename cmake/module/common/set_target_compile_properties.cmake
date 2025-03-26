function(set_target_compile_properties TARGET_NAME)
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(${TARGET_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
  endif()

  target_compile_features(${TARGET_NAME} PRIVATE ${COMPILER_FEATURES})
  target_compile_options(${TARGET_NAME} PRIVATE ${COMPILER_FLAGS})
endfunction()
