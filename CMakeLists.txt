cmake_minimum_required(VERSION 3.15)

# Project Configurations
project(
  UltimateCMakeTemplate
  VERSION 0.0.1
  LANGUAGES CXX
  DESCRIPTION "A repo for modular CMake template"
  HOMEPAGE_URL "https://github.com/movingChurch/ultimate-cmake-skeleton"
)

# Compiler Configurations
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_FLAGS "")

# Project Paths
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
message(STATUS "C++ Compiler Configurations")
message(STATUS "C++ Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C++ Compiler Path: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard Version: ${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Standard Required: ${CMAKE_CXX_STANDARD_REQUIRED}")
message(STATUS "C++ Extensions: ${CMAKE_CXX_EXTENSIONS}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")

message(STATUS)
message(STATUS "Project Paths")
message(STATUS "Root: ${${PROJECT_NAME}_ROOT_PATH}")
message(STATUS "Source: ${${PROJECT_NAME}_SOURCE_PATH}")
message(STATUS "Include: ${${PROJECT_NAME}_INCLUDE_PATH}")
message(STATUS "Build: ${${PROJECT_NAME}_BUILD_PATH}")
message(STATUS "Install: ${${PROJECT_NAME}_INSTALL_PATH}")

message(STATUS)
message(STATUS "Finished all process in ${PROJECT_NAME} CMakeLists.txt.")
message(STATUS "-----------------------------------------------------------------------------")
