#!/bin/bash

SERVER_DIR_PATH_PREFIX="/tmp/squashfused-server-"
DAEMON_DIR_HOST_PATH_PREFIX="/tmp/squashfused-"

DAEMON_DIR_CONT_PATH="/squashfused"
BRIDGE_DIR_CONT_PATH="$DAEMON_DIR_CONT_PATH/bridge_dir"
BRIDGE_FIFO_CONT_PATH="$DAEMON_DIR_CONT_PATH/bridge_fifo"

path::set_server() {
  local HOST_ID=${1:-?}
  if [[ "$HOST_ID" == "?" ]]; then
    # Find a server that this can talk to.
    # This is a workaround to identifying the UID from hooks, which is a pain.
    for CANDIDATE_DIR in $(ls $(dirname "$SERVER_DIR_PATH_PREFIX") | grep $(basename "$SERVER_DIR_PATH_PREFIX")); do
      CANDIDATE_PATH=$(dirname "$SERVER_DIR_PATH_PREFIX")/"$CANDIDATE_DIR"
      if [[ -w "$CANDIDATE_PATH/spawn" ]]; then
        HOST_ID=${CANDIDATE_PATH#$SERVER_DIR_PATH_PREFIX}
      fi
    done
  fi
  export SERVER_DIR_PATH="$SERVER_DIR_PATH_PREFIX""$HOST_ID"
  export SERVER_FIFO_PATH="$SERVER_DIR_PATH/spawn"
  export SERVER_MAP_DIR_PATH="$SERVER_DIR_PATH/map"
  export SERVER_LOG_DIR_PATH="$SERVER_DIR_PATH/log"
}

path::set_host() {
  local DAEMON_ID=$1
  export DAEMON_DIR_HOST_PATH="$DAEMON_DIR_HOST_PATH_PREFIX""$DAEMON_ID"
  export DAEMON_PID_PATH="$DAEMON_DIR_HOST_PATH/daemon_pid"
  export BRIDGE_DIR_HOST_PATH="$DAEMON_DIR_HOST_PATH/bridge_dir"
  export BRIDGE_FIFO_HOST_PATH="$DAEMON_DIR_HOST_PATH/bridge_fifo"
  export CONST_DST_HOST_PATH="$DAEMON_DIR_HOST_PATH/const_dst"
}

path::container_id_to_daemon_id() {
  local CONTAINER_ID=$1
  echo "$SERVER_MAP_DIR_PATH/$CONTAINER_ID"
}
