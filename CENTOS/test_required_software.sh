#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR
source ${SCRIPT_DIR}/functions.sh
unset NEED2INSTALL

get_linux_type;


if [ ! "${LINUX_TYPE}" == "CENTOS" ]; then
  echo "This does not appear to be Centos Linux. Exiting."; exit 1
fi

if [ ! $(which openssl 2>/dev/null) ]; then 
  NEED2INSTALL=TRUE
  yum install openssl 
fi

if [ ! $(which update-ca-trust 2>/dev/null) ]; then
  NEED2INSTALL=TRUE
  yum install ca-certificates
fi

if [ ! ${NEED2INSTALL} ]; then 
  echo "The required software is installed."
fi

