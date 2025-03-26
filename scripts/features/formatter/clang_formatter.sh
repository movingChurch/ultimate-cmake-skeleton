#!/bin/bash

function formatter::check_installation() {
  if ! command -v clang-format &>/dev/null; then
    logger::print_error "clang-format is not installed."
    logger::print "Installation instructions:"
    logger::print "  Ubuntu/Debian: sudo apt-get install clang-format"
    logger::print "  macOS: brew install clang-format"
    logger::print "  Windows: Install LLVM"
    exit 1
  fi
}

function formatter::process_files() {
  local file_pattern="$1"
  shift
  local excluded_dirs=("$@")

  while IFS= read -r source_file; do
    local relative_path=$(file_utils::get_relative_path "${source_file}")
    counter_manager::increment "total"

    logger::print "Checking: ${relative_path}"

    if ! clang-format --dry-run -Werror -style=file "${source_file}" &>/dev/null; then
      logger::print "Formatting: ${relative_path}"
      counter_manager::add_changed_file "${source_file}"
      counter_manager::increment "changed"

      if ! clang-format -i -style=file "${source_file}" 2>/tmp/format_error; then
        counter_manager::increment "errors"
        counter_manager::add_error_file "${source_file}"
        logger::print_error "Failed to format: ${relative_path}"
        cat /tmp/format_error
      else
        counter_manager::increment "formatted"
        logger::print_success "Formatted: ${relative_path}"
      fi
    else
      logger::print "Already formatted: ${relative_path}"
    fi
  done < <(file_utils::find_source_files "${file_pattern}" "${excluded_dirs[@]}")
}

function formatter::print_summary() {
  local total_files=$(counter_manager::get_value "total")
  local changed_files=$(counter_manager::get_value "changed")
  local formatted_files=$(counter_manager::get_value "formatted")
  local error_count=$(counter_manager::get_value "errors")

  logger::print "Formatting Results:"
  logger::print "-------------------"
  logger::print "Total files scanned: ${total_files}"
  logger::print "Files requiring formatting: ${changed_files}"
  logger::print "Successfully formatted files: ${formatted_files}"

  if [ ${changed_files} -gt 0 ]; then
    logger::print ""
    logger::print "Modified files:"
    while IFS= read -r file; do
      logger::print "- $(file_utils::get_relative_path "${file}")"
    done < <(counter_manager::get_changed_files)
  fi

  if [ ${error_count} -gt 0 ]; then
    logger::print ""
    logger::print_error "Failed to format ${error_count} files:"
    while IFS= read -r file; do
      logger::print_error "- $(file_utils::get_relative_path "${file}")"
    done < <(counter_manager::get_error_files)
    return 1
  fi

  return 0
}
