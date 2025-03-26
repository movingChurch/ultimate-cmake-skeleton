cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

get_filename_component(CURRENT_DIRECTORY_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

project(${PROJECT_NAME}__${CURRENT_DIRECTORY_NAME})

add_executable(${PROJECT_NAME}
  main.cpp
)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include)
  target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/test)
  add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/test)
endif()

target_compile_features(${PROJECT_NAME} PRIVATE ${COMPILER_FEATURES})
target_compile_options(${PROJECT_NAME} PRIVATE ${COMPILER_FLAGS})
target_link_libraries(${PROJECT_NAME} PRIVATE ultimate_cmake_template__utils) # Change to the actual library name
