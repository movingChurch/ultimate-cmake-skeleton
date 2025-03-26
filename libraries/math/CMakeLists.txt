cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

get_filename_component(MODULE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(
  ${PROJECT_NAME}__${MODULE_NAME}
)

set(MODULE_SOURCES src/add.cpp)

add_library(${PROJECT_NAME} STATIC ${MODULE_SOURCES})

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
endif()

target_compile_features(${PROJECT_NAME} PRIVATE ${COMPILER_FEATURES})
target_compile_options(${PROJECT_NAME} PRIVATE ${COMPILER_FLAGS})
target_link_libraries(${PROJECT_NAME} PRIVATE) # Change to the actual library name

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/test/CMakeLists.txt)
  add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/test)
endif()
