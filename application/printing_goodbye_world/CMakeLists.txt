cmake_minimum_required(VERSION 3.15)

get_filename_component(APPLICATION_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

add_executable(${APPLICATION_NAME}
  src/main.cpp
)
