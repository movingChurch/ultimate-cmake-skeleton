include(${CMAKE_SOURCE_DIR}/cmake/module/common/set_target_compile_properties.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/module/common/add_target_dependencies.cmake)

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