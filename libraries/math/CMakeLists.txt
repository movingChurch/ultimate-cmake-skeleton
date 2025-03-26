cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(
  ${MODULE_NAME}
)

set(MODULE_SOURCES src/add.cpp)

add_library(${MODULE_NAME} STATIC ${MODULE_SOURCES})

target_compile_features(${MODULE_NAME} PRIVATE ${COMPILER_FEATURES})
target_compile_options(${MODULE_NAME} PRIVATE ${COMPILER_FLAGS})

target_include_directories(${MODULE_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/test)
