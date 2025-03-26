#!/bin/bash

declare -A LOG_LEVELS=(
  ["INFO"]="[INFO]"
  ["WARNING"]="[WARNING]"
  ["ERROR"]="[ERROR]"
  ["SUCCESS"]="[SUCCESS]"
)

function logger::print_header() {
  echo "====================================="
  echo "$1"
  echo "====================================="
}

function logger::print() {
  echo "$1"
}

function logger::print_error() {
  echo "${LOG_LEVELS[ERROR]} $1" >&2
}

function logger::print_warning() {
  echo "${LOG_LEVELS[WARNING]} $1"
}

function logger::print_success() {
  echo "${LOG_LEVELS[SUCCESS]} $1"
}
