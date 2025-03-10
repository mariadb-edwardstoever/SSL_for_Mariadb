#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
unset ERR 
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

if [ ! -f vars.sh ]; then
  echo "vars.sh does not exist. Scripts must be run in the proper order. Exiting."; exit 1
fi

source ${SCRIPT_DIR}/functions.sh
source ${SCRIPT_DIR}/vars.sh

get_current_md5s

if [ "$(basename $SCRIPT_DIR)" == "COMMON" ]; then
  TEMP_COLOR=lred; print_color "Do not run scripts from the COMMON directory. "; unset TEMP_COLOR; print_color "Exiting.\n\n"; exit 1;
fi


if [ "${CURR_MD5VARS_SH}" == "${MD5VARS_SH}" ]; then
  TEMP_COLOR=lred; print_color "vars.sh has not been edited.\nYou definitely want to edit that file.\nPress ";
  TEMP_COLOR=lcyan; print_color "c";
  TEMP_COLOR=lred; print_color " to continue with a fantasy company name or any other key to exit.\n"; unset TEMP_COLOR;
  read -s -n 1 RESPONSE
  if [ ! "$RESPONSE" = "c" ]; then printf "Nothing done.\n"; exit 0; fi
fi


if [ ! "$USE_PROVIDED_CA" == "YES" ]; then
  if [ -f CA_configuration.cfg ]; then
    if [ ! "${CURR_MD5CACONFI}" == "${MD5CACONFI}" ]; then
        TEMP_COLOR=lcyan; print_color  "The file CA_configuration.cfg has been edited. It will not be overwritten.\n" unset TEMP_COLOR;
        CA_CONFIGURATION_EDITED=TRUE
    fi 
  fi
fi

if [ -f OWN_extensions.cfg ]; then
  if [ ! "${CURR_MD5OWNEXTN}" == "${MD5OWNEXTN}" ]; then
    TEMP_COLOR=lcyan; print_color  "The file OWN_extensions.cfg has been edited. It will not be overwritten.\n" unset TEMP_COLOR;
    OWN_ALL_PURPOSE_EXTENSIONS_EDITED=TRUE
  fi
fi

if [ -f OWN_org_details.cfg ]; then
  if [ ! "${CURR_MD5OWNORGD}" == "${MD5OWNORGD}" ]; then
    TEMP_COLOR=lcyan; print_color  "The file OWN_org_details.cfg has been edited. It will not be overwritten.\n" unset TEMP_COLOR;
    OWN_ORG_DETAILS_EDITED=TRUE
  fi
fi

if [ ! $CA_CONFIGURATION_EDITED ] && [ ! "$USE_PROVIDED_CA" == "YES" ]; then
  TEMP_COLOR=lcyan; print_color "Copying CA_configuration.cfg. "; 
  TEMP_COLOR=lred; print_color "This file should be edited before you continue.\n"; unset TEMP_COLOR;
  cp ../COMMON/CA_configuration.cfg .
fi

if [ ! $OWN_ALL_PURPOSE_EXTENSIONS_EDITED ] && [ "$GENERATE_ALL_PURPOSE_CERTIFICATE" == "YES" ]; then
  TEMP_COLOR=lcyan; print_color "Copying OWN_extensions.cfg. "; 
  TEMP_COLOR=lred; print_color "This file should be edited before you continue.\n"; unset TEMP_COLOR;
  cp ../COMMON/OWN_extensions.cfg .
fi 

if [ ! $OWN_ORG_DETAILS_EDITED ]; then
  TEMP_COLOR=lcyan; print_color "Copying OWN_org_details.cfg. "; 
  TEMP_COLOR=lred; print_color "This file should be edited before you continue.\n"; unset TEMP_COLOR;
  cp ../COMMON/OWN_org_details.cfg .
fi


if [ ! "$(ls -lrth  *.key *.csr *.srl *.pem *.crt myCA_key_passphrase.txt 2>/dev/null)" ]; then
   TEMP_COLOR=lgreen; print_color "Script completed OK.\n\n"; exit 0;
fi

TEMP_COLOR=lred;  print_color "These files will be DELETED if you agree:\n"
ls -lrth  *.key *.csr *.srl *.pem *.crt myCA_key_passphrase.txt 2>/dev/null
TEMP_COLOR=lred;  print_color "This script will remove all previously created certificate files from the directory ${SCRIPT_DIR}.\nPress "; 
TEMP_COLOR=lcyan; print_color "x"; 
TEMP_COLOR=lred;  print_color " to delete all of these files. Any other key will exit.\n";

read -s -n 1 RESPONSE
if [ ! "$RESPONSE" = "x" ]; then printf "Nothing done.\n"; exit 0; fi

rm -f *.key *.csr *.srl *.pem *.crt myCA_key_passphrase.txt || ERR=TRUE

if [ $ERR ]; then
  TEMP_COLOR=lred; print_color "Something went wrong with removing files.\n"; unset TEMP_COLOR;
  exit 1
else
  TEMP_COLOR=lgreen; print_color "File removal completed OK.\n"; unset TEMP_COLOR;
fi
