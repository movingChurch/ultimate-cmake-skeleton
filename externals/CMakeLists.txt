cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

file(GLOB SUB_DIRECTORIES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/*")

include(${CMAKE_SOURCE_DIR}/cmake/add_external_package.cmake)

foreach(SUB_DIRECTORY ${SUB_DIRECTORIES})
  if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${SUB_DIRECTORY})
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${SUB_DIRECTORY}/CMakeLists.txt)
      message(STATUS "Started configuration for ${SUB_DIRECTORY}.")
      add_subdirectory(${SUB_DIRECTORY})
      message(STATUS "Finished configuration for ${SUB_DIRECTORY}.")
    endif()
  endif()
endforeach()
