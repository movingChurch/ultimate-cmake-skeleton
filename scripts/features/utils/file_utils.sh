#!/bin/bash

function file_utils::find_source_files() {
  local pattern="$1"
  shift
  local excluded_dirs=("$@")

  local exclude_pattern=""
  for directory in "${excluded_dirs[@]}"; do
    exclude_pattern="${exclude_pattern} ! -path '*/${directory}/*'"
  done

  eval "find \"${PROJECT_ROOT_DIRECTORY}\" -type f -name \"${pattern}\" ${exclude_pattern}"
}

function file_utils::get_relative_path() {
  local full_path="$1"
  echo "${full_path#${PROJECT_ROOT_DIRECTORY}/}"
}
