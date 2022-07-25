#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -a  # Mark variables which are modified or created for export.

# Set (and export) env variables
source .env
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

# Make sure data dirs are created without root being the owner
mkdir -p ${EXECUTION_DATA}
mkdir -p ${CONSENSUS_DATA}

docker-compose pull
docker-compose down
docker-compose up -d