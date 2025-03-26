#!/bin/bash

set -e

SCRIPT_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
PROJECT_ROOT_DIRECTORY="$(cd "${SCRIPT_DIRECTORY}/../.." && pwd)"

SOURCE_FILE_EXTENSIONS=(
  "*.cpp"
  "*.hpp"
  "*.c"
  "*.h"
  "*.cc"
  "*.hh"
)

EXCLUDED_DIRECTORIES=(
  "build"
  "install"
)

FORMATTED_FILES_COUNT=0
ERROR_COUNT=0
ERROR_FILES=()

function print_section_header() {
  echo "====================================="
  echo "$1"
  echo "====================================="
}

function check_clang_format_installation() {
  if ! command -v clang-format &>/dev/null; then
    echo "Error: clang-format is not installed."
    echo "Installation instructions:"
    echo "  Ubuntu/Debian: sudo apt-get install clang-format"
    echo "  macOS: brew install clang-format"
    echo "  Windows: Install LLVM"
    exit 1
  fi
}

function format_source_files() {
  local FILE_PATTERN="$1"

  find "${PROJECT_ROOT_DIRECTORY}" \
    -type f \
    -name "${FILE_PATTERN}" \
    ! -path "*/build/*" \
    ! -path "*/install/*" \
    -print0 | while IFS= read -r -d '' SOURCE_FILE; do
    echo "Formatting: ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"
    if ! clang-format -i -style=file "${SOURCE_FILE}" 2>/tmp/format_error; then
      ERROR_COUNT=$((ERROR_COUNT + 1))
      ERROR_FILES+=("${SOURCE_FILE}")
      echo "Error formatting ${SOURCE_FILE}:"
      cat /tmp/format_error
    else
      FORMATTED_FILES_COUNT=$((FORMATTED_FILES_COUNT + 1))
    fi
  done
}

function check_formatting_changes() {
  if git diff --quiet; then
    echo "No formatting changes were necessary."
  else
    echo "Formatting changes have been applied."
    echo "Modified files:"
    git diff --name-only
  fi
}

function print_error_summary() {
  if [ ${ERROR_COUNT} -gt 0 ]; then
    echo "====================================="
    echo "ERROR SUMMARY"
    echo "====================================="
    echo "Failed to format ${ERROR_COUNT} files:"
    for error_file in "${ERROR_FILES[@]}"; do
      echo "- ${error_file#${PROJECT_ROOT_DIRECTORY}/}"
    done
    return 1
  fi
  return 0
}

function main() {
  print_section_header "Starting Code Formatting"

  check_clang_format_installation

  echo "Project root directory: ${PROJECT_ROOT_DIRECTORY}"

  for FILE_EXTENSION in "${SOURCE_FILE_EXTENSIONS[@]}"; do
    format_source_files "${FILE_EXTENSION}"
  done

  print_section_header "Formatting Complete"
  echo "Total files processed successfully: ${FORMATTED_FILES_COUNT}"

  check_formatting_changes
  print_error_summary
}

trap 'echo "Script failed! See error messages above."; exit 1' ERR

main
exit_code=$?

if [ ${exit_code} -ne 0 ]; then
  echo "Format script failed with exit code: ${exit_code}"
  exit ${exit_code}
fi

exit 0
