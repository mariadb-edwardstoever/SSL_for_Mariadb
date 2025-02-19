#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

source ${SCRIPT_DIR}/functions.sh

get_linux_type;

if [ ! "${LINUX_TYPE}" == "DEBIAN" ]; then
  echo "This does not appear to be Debian GNU/Linux. Exiting."; exit 1
fi


TEMP_COLOR=lred;  print_color "This script will remove custom Certificate Authority certificates from the servers trust store.\n";
TEMP_COLOR=lred;  print_color "Press ";
TEMP_COLOR=lcyan; print_color "x";
TEMP_COLOR=lred;  print_color " to remove your custom CAs from the server trust stopre. Any other key will exit.\n";



read -s -n 1 RESPONSE
if [ ! "$RESPONSE" = "x" ]; then printf "Nothing done.\n"; exit 0; fi

rm /usr/local/share/ca-certificates/myCA.crt
update-ca-certificates --fresh

