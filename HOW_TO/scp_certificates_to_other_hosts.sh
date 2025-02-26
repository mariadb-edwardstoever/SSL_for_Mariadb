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
You can use the certificates in ${PUBLISH_DIR} on other Linux servers in your environment. 
You can use script ${PUBLISH_DIR}/add_CA_to_host_trust_store.sh to add the CA to the trusted certificates of any host.

# Example of the ssh command to the create same directory structure on the remote host:
ssh root@e177.edw.ee mkdir -p $PUBLISH_DIR/HOW_TO

Verify the mode of each directory in the path to $PUBLISH_DIR/HOW_TO on the remote server. Each should be 755 (drwxr-xr-x).

# Example of the scp command to copy contents of $PUBLISH_DIR and its subdirectories to the remote host:
scp -r $PUBLISH_DIR/* root@e177.edw.ee:$PUBLISH_DIR/

"

printf "${OUTPUT}"
