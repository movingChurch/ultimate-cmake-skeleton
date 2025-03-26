include(${CMAKE_SOURCE_DIR}/cmake/module/test/create_test_executable.cmake)

function(add_test_module)
  cmake_parse_arguments(ARGUMENTS "" "TARGET" "SOURCES;DEPENDENCIES" ${ARGN})

  if(ARGUMENTS_SOURCES)
    create_test_executable(
      TARGET ${ARGUMENTS_TARGET}
      SOURCES ${ARGUMENTS_SOURCES}
      DEPENDENCIES ${ARGUMENTS_DEPENDENCIES}
    )
  endif()
endfunction()
