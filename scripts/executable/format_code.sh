#!/bin/bash

SCRIPT_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
PROJECT_ROOT_DIRECTORY="$(cd "${SCRIPT_DIRECTORY}/../.." && pwd)"
FEATURES_DIRECTORY="${SCRIPT_DIRECTORY}/../features"

# Import features
source "${FEATURES_DIRECTORY}/utils/logger.sh"
source "${FEATURES_DIRECTORY}/utils/file_utils.sh"
source "${FEATURES_DIRECTORY}/counter/counter_manager.sh"
source "${FEATURES_DIRECTORY}/formatter/clang_formatter.sh"

# Configuration
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

function initialize_environment() {
  logger::print_header "Initializing Format Script"
  counter_manager::initialize
  formatter::check_installation
  logger::print "Project root directory: ${PROJECT_ROOT_DIRECTORY}"
}

function process_source_files() {
  for FILE_EXTENSION in "${SOURCE_FILE_EXTENSIONS[@]}"; do
    formatter::process_files "${FILE_EXTENSION}" "${EXCLUDED_DIRECTORIES[@]}"
  done
}

function print_results() {
  logger::print_header "Formatting Complete"
  formatter::print_summary
}

function cleanup_environment() {
  counter_manager::cleanup
  trap - INT TERM EXIT
}

function error_handler() {
  logger::print_error "Script failed! See error messages above."
  cleanup_environment
  exit 1
}

function main() {
  trap error_handler INT TERM EXIT

  initialize_environment
  process_source_files
  print_results
  cleanup_environment
}

main
exit_code=$?

if [ ${exit_code} -ne 0 ]; then
  logger::print_error "Format script failed with exit code: ${exit_code}"
  exit ${exit_code}
fi

exit 0
