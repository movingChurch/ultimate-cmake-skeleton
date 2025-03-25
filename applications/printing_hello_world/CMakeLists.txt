cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

get_filename_component(APPLICATION_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

add_executable(${APPLICATION_NAME}
  src/main.cpp
)
target_compile_features(${APPLICATION_NAME} PRIVATE ${COMPILER_FEATURES})
target_compile_options(${APPLICATION_NAME} PRIVATE ${COMPILER_FLAGS})
