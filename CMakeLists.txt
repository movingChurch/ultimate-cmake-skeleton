cmake_minimum_required(VERSION 3.11)

project(
  UltimateCMakeTemplate
  VERSION 0.0.1
  LANGUAGES CXX
  DESCRIPTION "A repo for modular project with CMake lecture"
  HOMEPAGE_URL "https://github.com/movingChurch/ultimate-cmake-skeleton"
)
set(${PROJECT_NAME}_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(${PROJECT_NAME}_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(${PROJECT_NAME}_INCLUDE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(${PROJECT_NAME}_BUILD_PATH ${CMAKE_CURRENT_BINARY_DIR}/build)
set(${PROJECT_NAME}_INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/install)

message(STATUS "-----------------------------------------------------------------------------")
message(STATUS "Started all process in ${PROJECT_NAME} CMakeLists.txt.")

message(STATUS)
message(STATUS "Project Configurations")
message(STATUS "Name: ${PROJECT_NAME}")
message(STATUS "Version: ${PROJECT_VERSION}")
message(STATUS "Description: ${PROJECT_DESCRIPTION}")
message(STATUS "Homepage URL: ${PROJECT_HOMEPAGE_URL}")
message(STATUS "Languages: ${PROJECT_LANGUAGES}")

message(STATUS)
message(STATUS "Project Paths")
message(STATUS "Root: ${${PROJECT_NAME}_ROOT_PATH}")
message(STATUS "Source: ${${PROJECT_NAME}_SOURCE_PATH}")
message(STATUS "Include: ${${PROJECT_NAME}_INCLUDE_PATH}")
message(STATUS "Build: ${${PROJECT_NAME}_BUILD_PATH}")
message(STATUS "Install: ${${PROJECT_NAME}_INSTALL_PATH}")

message(STATUS "-----------------------------------------------------------------------------")
