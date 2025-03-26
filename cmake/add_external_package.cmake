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

  include(ExternalProject)
  ExternalProject_Add(
    ${MODULE_NAME}_EXTERNAL
    GIT_REPOSITORY ${PACKAGE_REPOSITORY_URL}
    GIT_TAG ${PACKAGE_REPOSITORY_TAG}
    GIT_SHALLOW TRUE
    CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=${${MODULE_NAME}_INSTALL_DIRECTORY}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    ${PACKAGE_COMPILE_ARGUMENTS}
    SOURCE_DIR ${${MODULE_NAME}_SOURCE_DIRECTORY}
    BINARY_DIR ${${MODULE_NAME}_BUILD_DIRECTORY}
    INSTALL_DIR ${${MODULE_NAME}_INSTALL_DIRECTORY}
    TEST_COMMAND ""
  )

  foreach(LIBRARY ${PACKAGE_LIBRARIES})
    configure_library(${LIBRARY} ${MODULE_NAME})
  endforeach()
endfunction()
