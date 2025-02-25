#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

source ${SCRIPT_DIR}/functions.sh

get_linux_type;

if [ ! "${LINUX_TYPE}" == "DEBIAN" ]; then
  echo "This does not appear to be Debian GNU/Linux. Exiting."; exit 1
fi

if [ "$(find /usr/local/share/ca-certificates/ -type f | wc -l)" == "0" ]; then
  NO_FILES=TRUE
else 
  TEMP_COLOR=lred; print_color "Files to be removed by this script:\n"
  ls -l /usr/local/share/ca-certificates/*
  echo
fi

if [ $NO_FILES ]; then
  TEMP_COLOR=lcyan; print_color "There are no custom files in /usr/local/share/ca-certificates\nPress"
  TEMP_COLOR=lred; print_color " x ";
  TEMP_COLOR=lcyan; print_color "To run the script and reset anyway or any other key to exit.\n"
else
TEMP_COLOR=lred;  print_color "This script will remove custom Certificate Authority certificates from the servers trust store.\n";
TEMP_COLOR=lred;  print_color "Press ";
TEMP_COLOR=lcyan; print_color "x";
TEMP_COLOR=lred;  print_color " to remove your custom CAs from the server trust store. Any other key will exit.\n";
fi


read -s -n 1 RESPONSE
if [ ! "$RESPONSE" = "x" ]; then printf "Nothing done.\n"; exit 0; fi

FILE_COUNT=$(find /usr/local/share/ca-certificates/ -type f | wc -l)
mv /usr/local/share/ca-certificates/* /tmp 2>/dev/null
TEMP_COLOR=lcyan; print_color "${FILE_COUNT} files moved to /tmp directory.\n"
update-ca-certificates --fresh

