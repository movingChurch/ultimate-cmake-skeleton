#!/bin/bash

COUNTER_DIRECTORY="/tmp/format_counters"
declare -A COUNTER_FILES=(
  ["total"]="${COUNTER_DIRECTORY}/total"
  ["formatted"]="${COUNTER_DIRECTORY}/formatted"
  ["changed"]="${COUNTER_DIRECTORY}/changed"
  ["errors"]="${COUNTER_DIRECTORY}/errors"
)
CHANGED_FILES_LIST="${COUNTER_DIRECTORY}/changed_files"
ERROR_FILES_LIST="${COUNTER_DIRECTORY}/error_files"

function counter_manager::initialize() {
  mkdir -p "${COUNTER_DIRECTORY}"
  for counter_file in "${COUNTER_FILES[@]}"; do
    echo 0 >"${counter_file}"
  done
  >"${CHANGED_FILES_LIST}"
  >"${ERROR_FILES_LIST}"
}

function counter_manager::increment() {
  local counter_name="$1"
  local current_value=$(cat "${COUNTER_FILES[${counter_name}]}")
  echo $((current_value + 1)) >"${COUNTER_FILES[${counter_name}]}"
}

function counter_manager::get_value() {
  local counter_name="$1"
  cat "${COUNTER_FILES[${counter_name}]}"
}

function counter_manager::add_changed_file() {
  echo "$1" >>"${CHANGED_FILES_LIST}"
}

function counter_manager::add_error_file() {
  echo "$1" >>"${ERROR_FILES_LIST}"
}

function counter_manager::get_changed_files() {
  cat "${CHANGED_FILES_LIST}"
}

function counter_manager::get_error_files() {
  cat "${ERROR_FILES_LIST}"
}

function counter_manager::cleanup() {
  rm -rf "${COUNTER_DIRECTORY}"
}
