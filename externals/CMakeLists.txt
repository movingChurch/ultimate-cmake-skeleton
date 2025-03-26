cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

include(${CMAKE_SOURCE_DIR}/cmake/core/directory/add_subdirectories.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/package/add_external_package.cmake)

add_subdirectories(${CMAKE_CURRENT_SOURCE_DIR})
