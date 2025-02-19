#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR


if [ ! -f ../vars.sh ]; then
  echo "../vars.sh does not exist. Exiting."; exit 1
fi

if [ ! -f ../functions.sh ]; then
  echo "../functions.sh does not exist. Exiting."; exit 1
fi

source ${SCRIPT_DIR}/../vars.sh
source ${SCRIPT_DIR}/../functions.sh
get_linux_type

OUTPUT="
You can use the same certificates that you created on all Linux servers. You don't have to create them again.
So, now, copy the certificates to other hosts where you intend to use them.

# Assuming the remote host is e177.edw.ee, use ssh to create the same directory structure on the remote host:
ssh root@e177.edw.ee mkdir -p $PUBLISH_DIR/HOW_TO

# Use scp to copy all of the contents of $PUBLISH_DIR and its subdirectories to the remote host:
scp -r $PUBLISH_DIR/* root@e177.edw.ee:$PUBLISH_DIR/
"

printf "${OUTPUT}"
