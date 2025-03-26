cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

if(CMAKE_CXX_COMPILER_ID STREQUAL MSVC)
  set(PRINT_SOURCE src/msvc/print.cpp)
else()
  set(PRINT_SOURCE src/print.cpp)
endif()

add_library_module(
  NAME utils
  SOURCES ${PRINT_SOURCE}
)
