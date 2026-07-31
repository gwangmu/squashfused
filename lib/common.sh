#!/bin/bash

log::file() {
  local filepath=$1
  exec 3>"$filepath"
  exec 2>&3
}

log::echo() {
  local msg=${1:-}
  echo "$msg" >&3 || true
}

state::load() {  
  CONTAINER_STATE=$(cat)
}

state::read() {
  local field=$1
  echo "$CONTAINER_STATE" | jq -r "$field"
}

state::add() {
  local field=$1
  local value=$2
  CONTAINER_STATE=$(echo "$CONTAINER_STATE" | jq "$field"' += '"$value")
}

state::print() {
  echo "$CONTAINER_STATE"
}
