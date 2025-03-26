include(${CMAKE_SOURCE_DIR}/cmake/convert_to_screaming_case.cmake)

function(set_external_package_paths PACKAGE_NAME PACKAGE_IDENTIFIER)
  set(${PACKAGE_IDENTIFIER}_SOURCE_PATH ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/source PARENT_SCOPE)
  set(${PACKAGE_IDENTIFIER}_BUILD_PATH ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/build PARENT_SCOPE)
  set(${PACKAGE_IDENTIFIER}_INSTALL_PATH ${CMAKE_SOURCE_DIR}/install/${PACKAGE_NAME}/${CMAKE_BUILD_TYPE} PARENT_SCOPE)
endfunction()

function(get_library_filename LIBRARY_NAME OUTPUT_FILENAME)
  if(WIN32)
    set(${OUTPUT_FILENAME} "${LIBRARY_NAME}.lib" PARENT_SCOPE)
  else()
    set(${OUTPUT_FILENAME} "lib${LIBRARY_NAME}.a" PARENT_SCOPE)
  endif()
endfunction()

function(configure_static_library LIBRARY_NAME PACKAGE_IDENTIFIER)
  if(NOT TARGET ${LIBRARY_NAME})
    add_library(${LIBRARY_NAME} STATIC IMPORTED GLOBAL)

    get_library_filename(${LIBRARY_NAME} LIBRARY_FILENAME)

    set_target_properties(${LIBRARY_NAME} PROPERTIES
      IMPORTED_LOCATION "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/lib/${LIBRARY_FILENAME}"
      INTERFACE_INCLUDE_DIRECTORIES "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/include"
    )
  endif()
endfunction()

function(check_libraries_exist PACKAGE_IDENTIFIER LIBRARIES RESULT_VAR)
  set(ALL_EXIST TRUE)

  foreach(LIBRARY_NAME ${LIBRARIES})
    get_library_filename(${LIBRARY_NAME} LIBRARY_FILENAME)
    set(LIBRARY_PATH "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/lib/${LIBRARY_FILENAME}")

    if(NOT EXISTS ${LIBRARY_PATH})
      set(ALL_EXIST FALSE)
      break()
    endif()
  endforeach()

  set(${RESULT_VAR} ${ALL_EXIST} PARENT_SCOPE)
endfunction()

function(install_external_package PACKAGE_NAME PACKAGE_IDENTIFIER)
  message(STATUS "Installing ${PACKAGE_NAME}...")

  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DCMAKE_INSTALL_PREFIX=${${PACKAGE_IDENTIFIER}_INSTALL_PATH}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    ${PACKAGE_COMPILE_ARGUMENTS}
    ${${PACKAGE_IDENTIFIER}_SOURCE_PATH}
    WORKING_DIRECTORY ${${PACKAGE_IDENTIFIER}_BUILD_PATH}
  )

  execute_process(
    COMMAND ${CMAKE_COMMAND} --build . --target install
    WORKING_DIRECTORY ${${PACKAGE_IDENTIFIER}_BUILD_PATH}
  )

  message(STATUS "Finished installing ${PACKAGE_NAME}")
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

  convert_to_screaming_case(${PACKAGE_NAME} PACKAGE_IDENTIFIER)
  set_external_package_paths(${PACKAGE_NAME} ${PACKAGE_IDENTIFIER})

  check_libraries_exist(${PACKAGE_IDENTIFIER} "${PACKAGE_LIBRARIES}" LIBRARIES_EXIST)

  if(NOT LIBRARIES_EXIST)
    include(FetchContent)

    FetchContent_Declare(
      ${PACKAGE_IDENTIFIER}
      GIT_REPOSITORY ${PACKAGE_REPOSITORY_URL}
      GIT_TAG ${PACKAGE_REPOSITORY_TAG}
      GIT_SHALLOW TRUE
      SOURCE_DIR ${${PACKAGE_IDENTIFIER}_SOURCE_PATH}
      BINARY_DIR ${${PACKAGE_IDENTIFIER}_BUILD_PATH}
    )

    FetchContent_GetProperties(${PACKAGE_IDENTIFIER})

    if(NOT ${PACKAGE_IDENTIFIER}_POPULATED)
      FetchContent_Populate(${PACKAGE_IDENTIFIER})

      set(CMAKE_INSTALL_PREFIX ${${PACKAGE_IDENTIFIER}_INSTALL_PATH})
      add_subdirectory(
        ${${PACKAGE_IDENTIFIER}_SOURCE_PATH}
        ${${PACKAGE_IDENTIFIER}_BUILD_PATH}
      )

      install(CODE "
        execute_process(
          COMMAND ${CMAKE_COMMAND} --build . --target install
          WORKING_DIRECTORY ${${PACKAGE_IDENTIFIER}_BUILD_PATH}
        )"
      )

      install_external_package(${PACKAGE_NAME} ${PACKAGE_IDENTIFIER})
    endif()
  else()
    message(STATUS "Found existing installation for ${PACKAGE_NAME}, skipping build")
  endif()

  foreach(LIBRARY_NAME ${PACKAGE_LIBRARIES})
    configure_static_library(${LIBRARY_NAME} ${PACKAGE_IDENTIFIER})
  endforeach()
endfunction()
