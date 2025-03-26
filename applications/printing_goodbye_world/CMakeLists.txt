cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

include(${CMAKE_SOURCE_DIR}/cmake/add_application_module.cmake)

add_application_module(
  NAME printing_goodbye_world
  SOURCES main.cpp
  DEPENDENCIES ultimate_cmake_template__utils
)
