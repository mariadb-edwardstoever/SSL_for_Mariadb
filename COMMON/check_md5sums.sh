#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
unset ERR
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

source ${SCRIPT_DIR}/functions.sh
get_current_md5s

# myCA.key
if [ "${CURR_MD5MYCAKEY}" == "${MD5MYCAKEY}" ]; then
  TEMP_COLOR=lgreen; print_color "${MYCAKEY} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${MYCAKEY} has been edited.\n\n"; unset TEMP_COLOR
fi

# OWN_org_details.cfg
if [ "${CURR_MD5OWNORGD}" == "${MD5OWNORGD}" ]; then
  TEMP_COLOR=lgreen; print_color "${OWNORGDET} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${OWNORGDET} has been edited.\n\n"; unset TEMP_COLOR
fi

# OWN_extensions.cfg
if [ "${CURR_MD5OWNEXTN}" == "$MD5OWNEXTN" ]; then
  TEMP_COLOR=lgreen; print_color "${OWNEXTENS} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${OWNEXTENS} has been edited.\n\n"; unset TEMP_COLOR
fi

# CA_configuration.cfg
if [ "${CURR_MD5CACONFI}" == "${MD5CACONFI}" ]; then
  TEMP_COLOR=lgreen; print_color "${CACONFIG} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${CACONFIG} has been edited.\n\n"; unset TEMP_COLOR
fi

# vars.sh
if [ "${CURR_MD5VARS_SH}" == "${MD5VARS_SH}" ]; then
  TEMP_COLOR=lgreen; print_color "${VARSSH} is unchanged.\n\n"; unset TEMP_COLOR
else
  TEMP_COLOR=lmagenta; print_color "${VARSSH} has been edited.\n\n"; unset TEMP_COLOR
fi



