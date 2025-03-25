cmake_minimum_required(VERSION 3.15)

get_filename_component(APP_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

add_executable(${APP_NAME}
    src/main.cpp
)

# 컴파일러와 버전에 따른 C++ 표준 설정
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 10.0)
        target_compile_features(${APP_NAME} PRIVATE cxx_std_20)
    else()
        target_compile_features(${APP_NAME} PRIVATE cxx_std_17)
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_features(${APP_NAME} PRIVATE cxx_std_17)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.29)
        target_compile_features(${APP_NAME} PRIVATE cxx_std_20)
    else()
        target_compile_features(${APP_NAME} PRIVATE cxx_std_17)
    endif()
endif()

# 추가 컴파일 옵션
target_compile_options(${APP_NAME} PRIVATE
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wall -Wextra>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>
) 