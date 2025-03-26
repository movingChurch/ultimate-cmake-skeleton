include(${CMAKE_SOURCE_DIR}/cmake/external/library/get_library_filename.cmake)

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
