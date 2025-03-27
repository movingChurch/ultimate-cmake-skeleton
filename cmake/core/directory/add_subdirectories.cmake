include(${CMAKE_SOURCE_DIR}/cmake/core/directory/configure_subdirectory.cmake)

function(add_subdirectories DIRECTORY_PATH)
  file(GLOB SUB_DIRECTORIES RELATIVE ${DIRECTORY_PATH} "${DIRECTORY_PATH}/*")

  foreach(SUB_DIRECTORY ${SUB_DIRECTORIES})
    if(IS_DIRECTORY ${DIRECTORY_PATH}/${SUB_DIRECTORY})
      configure_subdirectory(${DIRECTORY_PATH}/${SUB_DIRECTORY} ${SUB_DIRECTORY})
    endif()
  endforeach()
endfunction()
