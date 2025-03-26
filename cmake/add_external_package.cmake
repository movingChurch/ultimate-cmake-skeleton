function(generate_module_name PACKAGE_NAME OUTPUT_VAR)
  string(REPLACE "-" "_" MODULE_NAME "${PACKAGE_NAME}")
  string(REPLACE " " "_" MODULE_NAME "${MODULE_NAME}")
  string(TOUPPER "${MODULE_NAME}" MODULE_NAME)
  set(${OUTPUT_VAR} ${MODULE_NAME} PARENT_SCOPE)
endfunction()

function(set_package_directories PACKAGE_NAME MODULE_NAME)
  set(${MODULE_NAME}_SOURCE_DIRECTORY ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/source PARENT_SCOPE)
  set(${MODULE_NAME}_BUILD_DIRECTORY ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/build PARENT_SCOPE)
  set(${MODULE_NAME}_INSTALL_DIRECTORY ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/${CMAKE_BUILD_TYPE} PARENT_SCOPE)
endfunction()

function(configure_library LIBRARY MODULE_NAME)
  if(NOT TARGET ${LIBRARY})
    add_library(${LIBRARY} STATIC IMPORTED GLOBAL)

    if(WIN32)
      set(LIBRARY_FILENAME "${LIBRARY}.lib")
    else()
      set(LIBRARY_FILENAME "lib${LIBRARY}.a")
    endif()

    set_target_properties(${LIBRARY} PROPERTIES
      IMPORTED_LOCATION "${${MODULE_NAME}_INSTALL_DIRECTORY}/lib/${LIBRARY_FILENAME}"
      INTERFACE_INCLUDE_DIRECTORIES "${${MODULE_NAME}_INSTALL_DIRECTORY}/include"
    )
  endif()
endfunction()

function(add_external_package)
  get_filename_component(PACKAGE_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)

  set(one_value_arguments
    VERSION
    DESCRIPTION
    REPOSITORY_URL
    REPOSITORY_TAG
  )
  set(multi_value_arguments
    COMPILE_ARGUMENTS
    LIBRARIES
  )

  cmake_parse_arguments(PACKAGE "" "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

  generate_module_name(${PACKAGE_NAME} MODULE_NAME)
  set_package_directories(${PACKAGE_NAME} ${MODULE_NAME})

  # 모든 필요한 라이브러리 파일이 존재하는지 확인
  set(ALL_LIBS_EXIST TRUE)

  foreach(LIBRARY ${PACKAGE_LIBRARIES})
    if(WIN32)
      set(LIB_FILE "${${MODULE_NAME}_INSTALL_DIRECTORY}/lib/${LIBRARY}.lib")
    else()
      set(LIB_FILE "${${MODULE_NAME}_INSTALL_DIRECTORY}/lib/lib${LIBRARY}.a")
    endif()

    if(NOT EXISTS ${LIB_FILE})
      set(ALL_LIBS_EXIST FALSE)
      break()
    endif()
  endforeach()

  # 라이브러리가 이미 존재하면 설치 과정 건너뛰기
  if(NOT ALL_LIBS_EXIST)
    include(FetchContent)

    FetchContent_Declare(
      ${MODULE_NAME}
      GIT_REPOSITORY ${PACKAGE_REPOSITORY_URL}
      GIT_TAG ${PACKAGE_REPOSITORY_TAG}
      GIT_SHALLOW TRUE
      SOURCE_DIR ${${MODULE_NAME}_SOURCE_DIRECTORY}
      BINARY_DIR ${${MODULE_NAME}_BUILD_DIRECTORY}
    )

    FetchContent_GetProperties(${MODULE_NAME})

    if(NOT ${MODULE_NAME}_POPULATED)
      message(STATUS "Installing ${PACKAGE_NAME}...")
      FetchContent_Populate(${MODULE_NAME})

      # Add the subdirectory with the compile arguments
      set(CMAKE_INSTALL_PREFIX ${${MODULE_NAME}_INSTALL_DIRECTORY})
      add_subdirectory(
        ${${MODULE_NAME}_SOURCE_DIRECTORY}
        ${${MODULE_NAME}_BUILD_DIRECTORY}
      )

      # Install 명령 추가
      install(CODE "
        execute_process(
          COMMAND ${CMAKE_COMMAND} --build . --target install
          WORKING_DIRECTORY ${${MODULE_NAME}_BUILD_DIRECTORY}
        )"
      )

      # Configuration 단계에서 즉시 install 실행
      execute_process(
        COMMAND ${CMAKE_COMMAND} -DCMAKE_INSTALL_PREFIX=${${MODULE_NAME}_INSTALL_DIRECTORY}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        ${PACKAGE_COMPILE_ARGUMENTS}
        ${${MODULE_NAME}_SOURCE_DIRECTORY}
        WORKING_DIRECTORY ${${MODULE_NAME}_BUILD_DIRECTORY}
      )
      execute_process(
        COMMAND ${CMAKE_COMMAND} --build . --target install
        WORKING_DIRECTORY ${${MODULE_NAME}_BUILD_DIRECTORY}
      )
      message(STATUS "Finished installing ${PACKAGE_NAME}")
    endif()
  else()
    message(STATUS "Found existing installation for ${PACKAGE_NAME}, skipping build")
  endif()

  foreach(LIBRARY ${PACKAGE_LIBRARIES})
    configure_library(${LIBRARY} ${MODULE_NAME})
  endforeach()
endfunction()
