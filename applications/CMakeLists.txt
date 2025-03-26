cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

include(${CMAKE_SOURCE_DIR}/cmake/core/directory/add_subdirectories.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/module/application/add_application_module.cmake)

add_subdirectories(${CMAKE_CURRENT_SOURCE_DIR})
