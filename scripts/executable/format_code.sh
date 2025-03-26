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

# Counter files
COUNTER_DIR="/tmp/format_counters"
mkdir -p "${COUNTER_DIR}"
TOTAL_COUNT_FILE="${COUNTER_DIR}/total"
FORMAT_COUNT_FILE="${COUNTER_DIR}/formatted"
CHANGE_COUNT_FILE="${COUNTER_DIR}/changed"
ERROR_COUNT_FILE="${COUNTER_DIR}/errors"
CHANGED_FILES_LIST="${COUNTER_DIR}/changed_files"
ERROR_FILES_LIST="${COUNTER_DIR}/error_files"

# Initialize counters
echo 0 >"${TOTAL_COUNT_FILE}"
echo 0 >"${FORMAT_COUNT_FILE}"
echo 0 >"${CHANGE_COUNT_FILE}"
echo 0 >"${ERROR_COUNT_FILE}"
>"${CHANGED_FILES_LIST}"
>"${ERROR_FILES_LIST}"

function increment_counter() {
  local counter_file="$1"
  local current_value=$(cat "${counter_file}")
  echo $((current_value + 1)) >"${counter_file}"
}

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

    increment_counter "${TOTAL_COUNT_FILE}"
    echo "[CHECK] ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"

    if ! clang-format --dry-run -Werror -style=file "${SOURCE_FILE}" &>/dev/null; then
      echo "[FORMATTING] ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"
      echo "${SOURCE_FILE}" >>"${CHANGED_FILES_LIST}"
      increment_counter "${CHANGE_COUNT_FILE}"

      if ! clang-format -i -style=file "${SOURCE_FILE}" 2>/tmp/format_error; then
        increment_counter "${ERROR_COUNT_FILE}"
        echo "${SOURCE_FILE}" >>"${ERROR_FILES_LIST}"
        echo "[ERROR] Failed to format: ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"
        cat /tmp/format_error
      else
        increment_counter "${FORMAT_COUNT_FILE}"
        echo "[SUCCESS] Formatted: ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"
      fi
    else
      echo "[SKIP] Already formatted: ${SOURCE_FILE#${PROJECT_ROOT_DIRECTORY}/}"
    fi
  done
}

function print_formatting_summary() {
  local TOTAL_FILES=$(cat "${TOTAL_COUNT_FILE}")
  local CHANGED_FILES=$(cat "${CHANGE_COUNT_FILE}")
  local FORMATTED_FILES=$(cat "${FORMAT_COUNT_FILE}")

  echo "Formatting Results:"
  echo "-------------------"
  echo "Total files scanned: ${TOTAL_FILES}"
  echo "Files requiring formatting: ${CHANGED_FILES}"
  echo "Successfully formatted files: ${FORMATTED_FILES}"

  if [ ${CHANGED_FILES} -gt 0 ]; then
    echo ""
    echo "Modified files:"
    while IFS= read -r file; do
      echo "- ${file#${PROJECT_ROOT_DIRECTORY}/}"
    done <"${CHANGED_FILES_LIST}"
  fi
}

function print_error_summary() {
  local ERROR_COUNT=$(cat "${ERROR_COUNT_FILE}")

  if [ ${ERROR_COUNT} -gt 0 ]; then
    echo ""
    echo "Error Summary:"
    echo "-------------"
    echo "Failed to format ${ERROR_COUNT} files:"
    while IFS= read -r file; do
      echo "- ${file#${PROJECT_ROOT_DIRECTORY}/}"
    done <"${ERROR_FILES_LIST}"
    return 1
  fi
  return 0
}

function cleanup() {
  rm -rf "${COUNTER_DIR}"
}

function error_handler() {
  echo "Script failed! See error messages above."
  cleanup
  exit 1
}

trap error_handler INT TERM EXIT

function main() {
  print_section_header "Starting Code Formatting"
  check_clang_format_installation
  echo "Project root directory: ${PROJECT_ROOT_DIRECTORY}"
  echo ""

  for FILE_EXTENSION in "${SOURCE_FILE_EXTENSIONS[@]}"; do
    format_source_files "${FILE_EXTENSION}"
  done

  print_section_header "Formatting Complete"
  print_formatting_summary
  print_error_summary
  cleanup

  trap - INT TERM EXIT
}

main
exit_code=$?

if [ ${exit_code} -ne 0 ]; then
  echo "Format script failed with exit code: ${exit_code}"
  exit ${exit_code}
fi

exit 0
