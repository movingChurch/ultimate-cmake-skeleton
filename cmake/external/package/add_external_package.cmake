include(${CMAKE_SOURCE_DIR}/cmake/core/string/convert_to_uppercase_with_underscores.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/package/set_external_package_paths.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/library/check_libraries_exist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/library/configure_static_library.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/package/install_external_package.cmake)

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

  convert_to_uppercase_with_underscores(${PACKAGE_NAME} PACKAGE_IDENTIFIER)
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
