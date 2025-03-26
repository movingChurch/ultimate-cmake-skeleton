cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

file(GLOB SCRIPT_FILES "${CMAKE_CURRENT_SOURCE_DIR}/executable/*")

foreach(SCRIPT_FILE ${SCRIPT_FILES})
  if(EXISTS ${SCRIPT_FILE})
    get_filename_component(SCRIPT_NAME ${SCRIPT_FILE} NAME)
    message(STATUS "Executing script: ${SCRIPT_NAME}")

    execute_process(
      COMMAND chmod +x ${SCRIPT_NAME}
      COMMAND sh ${SCRIPT_NAME}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/executable
      RESULT_VARIABLE SCRIPT_RESULT
      OUTPUT_VARIABLE SCRIPT_OUTPUT
      ERROR_VARIABLE SCRIPT_ERROR
    )

    if(SCRIPT_OUTPUT)
      message(STATUS "Script output:\n${SCRIPT_OUTPUT}")
    endif()

    if(NOT SCRIPT_RESULT EQUAL 0)
      message(FATAL_ERROR "Script ${SCRIPT_NAME} failed with error:\n${SCRIPT_ERROR}")
    endif()
  endif()
endforeach()