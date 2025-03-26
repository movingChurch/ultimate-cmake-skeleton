cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

include(${CMAKE_SOURCE_DIR}/cmake/add_library_module.cmake)

add_library_module(
  NAME math
  SOURCES src/add.cpp
)
