function(convert_to_screaming_case INPUT OUTPUT)
  string(REPLACE "-" "_" SCREAMING_CASE_STRING "${INPUT}")
  string(REPLACE " " "_" SCREAMING_CASE_STRING "${SCREAMING_CASE_STRING}")
  string(TOUPPER "${SCREAMING_CASE_STRING}" SCREAMING_CASE_STRING)
  set(${OUTPUT} ${SCREAMING_CASE_STRING} PARENT_SCOPE)
endfunction()
