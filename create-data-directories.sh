#!/usr/bin/env bash
# This script has to be executed with elevated priviliges in order to change ownership and file permissions.
# See https://nimbus.guide/data-dir.html#permissions for more details
#
# How to execute: $ sudo ./create-data-directories.sh $(whoami)


set -e
set -a

source .env

USERNAME=$1

mkdir -p ${CONSENSUS_DATA}/validators
mkdir -p ${CONSENSUS_DATA}/secrets
mkdir -p ${EXECUTION_DATA}

USER_ID="$(id -u ${USERNAME})"
GROUP_ID="$(id -g ${USERNAME})"


# Changing ownership to `user:group` for all files/directories in <data-dir>.
chown ${USER_ID}:${GROUP_ID} -R ${CONSENSUS_DATA}
chown ${USER_ID}:${GROUP_ID} -R ${EXECUTION_DATA}
# Set permissions to (rwx------ 0700) for all directories starting from <data-dir>
find ${CONSENSUS_DATA} -type d -exec chmod 700 {} \;

# Set permissions to (rw------- 0600) for all files inside <data-dir>/validators
find ${CONSENSUS_DATA}/validators -type f -exec chmod 0600 {} \;

# Set permissions to (rw------- 0600) for all files inside <data-dir>/secrets
find ${CONSENSUS_DATA}/secrets -type f -exec chmod 0600 {} \;

echo "Successfully created directories ${CONSENSUS_DATA}, ${EXECUTION_DATA} and set ownership / permissions."
