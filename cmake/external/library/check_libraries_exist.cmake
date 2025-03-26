include(${CMAKE_SOURCE_DIR}/cmake/external/library/get_library_filename.cmake)

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
