set(CMAKE_VERSION_MINIMUM 3.15)
set(COMPILER_FEATURES cxx_std_17)
cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

# Project Configurations
project(
  ULTIMATE_CMAKE_TEMPLATE
  VERSION 0.1.0
  LANGUAGES CXX
  DESCRIPTION "A repo for modular CMake template"
  HOMEPAGE_URL "https://github.com/movingChurch/ultimate-cmake-skeleton"
)

set(CMAKE_VERBOSE_MAKEFILE ON)

# Project Paths
set(${PROJECT_NAME}_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(${PROJECT_NAME}_BUILD_PATH ${CMAKE_CURRENT_BINARY_DIR}/build)
set(${PROJECT_NAME}_INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/install)
set(${PROJECT_NAME}_LIBRARY_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libraries)
set(${PROJECT_NAME}_APPLICATION_PATH ${CMAKE_CURRENT_SOURCE_DIR}/applications)
set(${PROJECT_NAME}_EXTERNAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/externals)

# Compiler Flags
set(COMPILER_FLAGS_FOR_MSVC /W4 /WX /permissive-)
set(COMPILER_FLAGS_FOR_GCC -Wall -Wpedantic -Wextra -Werror)

if(NOT COMPILER_FLAGS)
  if(CMAKE_CXX_COMPILER_ID STREQUAL MSVC)
    set(COMPILER_FLAGS ${COMPILER_FLAGS_FOR_MSVC})
  else()
    set(COMPILER_FLAGS ${COMPILER_FLAGS_FOR_GCC})
  endif()
endif()

message(STATUS "-----------------------------------------------------------------------------")
message(STATUS "Started all process in ${PROJECT_NAME} CMakeLists.txt.")

message(STATUS)
message(STATUS "System Configurations")
message(STATUS "Architecture: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Version: ${CMAKE_SYSTEM_VERSION}")

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
message(STATUS "C++ Compiler Features: ${COMPILER_FEATURES}")
message(STATUS "C++ Compiler Flags: ${COMPILER_FLAGS}")

message(STATUS)
message(STATUS "Project Paths")
message(STATUS "Root: ${${PROJECT_NAME}_ROOT_PATH}")
message(STATUS "Build: ${${PROJECT_NAME}_BUILD_PATH}")
message(STATUS "Install: ${${PROJECT_NAME}_INSTALL_PATH}")
message(STATUS "Application: ${${PROJECT_NAME}_APPLICATION_PATH}")
message(STATUS "Library: ${${PROJECT_NAME}_LIBRARY_PATH}")
message(STATUS "External: ${${PROJECT_NAME}_EXTERNAL_PATH}")

message(STATUS)

message(STATUS "Started External Configuration")
add_subdirectory(${${PROJECT_NAME}_EXTERNAL_PATH})
message(STATUS "Finished External Configuration")
message(STATUS)
message(STATUS "Started Library Configuration")
add_subdirectory(${${PROJECT_NAME}_LIBRARY_PATH})
message(STATUS "Finished Library Configuration")

message(STATUS)
message(STATUS "Started Application Configuration")
add_subdirectory(${${PROJECT_NAME}_APPLICATION_PATH})
message(STATUS "Finished Application Configuration")

message(STATUS)
message(STATUS "Finished all process in ${PROJECT_NAME} CMakeLists.txt.")
message(STATUS "-----------------------------------------------------------------------------")
