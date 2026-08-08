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
  echo "$CONTAINER_STATE" | jq -rc "$field"
}

state::add() {
  local field=$1
  local value=$2
  CONTAINER_STATE=$(echo "$CONTAINER_STATE" | jq "$field"' += '"$value")
}

state::print() {
  echo "$CONTAINER_STATE"
}

opt::get() {
  local -n _OPTS=$1
  local _OPTS_STR=$2
  IFS=',' read -r -a _OPTS_ARR <<<"$_OPTS_STR"
  for _OPT in "${_OPTS_ARR[@]}"; do
    _OPT_NAME=${_OPT%=*}
    _OPT_NAME=${_OPT_NAME,,}
    case $_OPT in
      *=*) _OPT_VALUE=${_OPT#*=} ;;
      *) _OPT_VALUE="1" ;;
    esac
    _OPTS["$_OPT_NAME"]=$_OPT_VALUE
  done
}
