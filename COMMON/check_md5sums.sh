#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
unset ERR
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

source ${SCRIPT_DIR}/functions.sh

# myCA.key
if [ ! -f myCA.key ]; then MYCAKEY=$(find $(dirname $PWD) -name myCA.key | grep AUTHORITY); else MYCAKEY=$PWD/myCA.key; fi
if [ "$(md5sum ${MYCAKEY} | awk '{print $1}')" == "${MD5MYCAKEY}" ]; then
  TEMP_COLOR=lgreen; print_color "${MYCAKEY} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${MYCAKEY} has been edited.\n\n"; unset TEMP_COLOR
fi

# OWN_org_details.cfg
if [ ! -f OWN_org_details.cfg ]; then OWNORGDET=$(find $(dirname $PWD) -name OWN_org_details.cfg | grep COMMON); else OWNORGDET=$PWD/OWN_org_details.cfg; fi
if [ "$(cat ${OWNORGDET} | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" == "${MD5OWNORGD}" ]; then
  TEMP_COLOR=lgreen; print_color "${OWNORGDET} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${OWNORGDET} has been edited.\n\n"; unset TEMP_COLOR
fi

# OWN_extensions.cfg
if [ ! -f OWN_extensions.cfg ]; then OWNEXTENS=$(find $(dirname $PWD) -name OWN_extensions.cfg | grep COMMON); else OWNEXTENS=$PWD/OWN_extensions.cfg; fi
if [ "$(cat ${OWNEXTENS} | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" == "$MD5OWNEXTN" ]; then
  TEMP_COLOR=lgreen; print_color "${OWNEXTENS} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${OWNEXTENS} has been edited.\n\n"; unset TEMP_COLOR
fi

# CA_configuration.cfg
if [ ! -f CA_configuration.cfg ]; then CACONFIG=$(find $(dirname $PWD) -name CA_configuration.cfg | grep COMMON); else CACONFIG=$PWD/CA_configuration.cfg; fi
if [ "$(cat ${CACONFIG} | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" == "${MD5CACONFI}" ]; then
  TEMP_COLOR=lgreen; print_color "${CACONFIG} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${CACONFIG} has been edited.\n\n"; unset TEMP_COLOR
fi

# vars.sh
if [ ! -f vars.sh ]; then VARSSH=$(find $(dirname $PWD) -name vars.sh | grep COMMON); else VARSSH=$PWD/vars.sh; fi
if [ "$(cat ${VARSSH} | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" == "${MD5VARS_SH}" ]; then
  TEMP_COLOR=lgreen; print_color "${VARSSH} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${VARSSH} has been edited.\n\n"; unset TEMP_COLOR
fi



