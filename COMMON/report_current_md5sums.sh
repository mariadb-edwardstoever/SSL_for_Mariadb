#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
unset ERR
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

source ${SCRIPT_DIR}/functions.sh

echo
# myCA.key
if [ ! -f myCA.key ]; then MYCAKEY=$(find $(dirname $PWD) -name myCA.key | grep AUTHORITY); else MYCAKEY=$PWD/myCA.key; fi
CURRENT="$(md5sum ${MYCAKEY} | awk '{print $1}')"
TEMP_COLOR=lcyan; print_color "${MYCAKEY} :"; unset TEMP_COLOR; print_color " ${CURRENT}\n\n"; unset TEMP_COLOR

# OWN_org_details.cfg
if [ ! -f OWN_org_details.cfg ]; then OWNORGDET=$(find $(dirname $PWD) -name OWN_org_details.cfg | grep COMMON); else OWNORGDET=$PWD/OWN_org_details.cfg; fi
CURRENT="$(cat ${OWNORGDET} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)"
TEMP_COLOR=lcyan; print_color "${OWNORGDET} :"; unset TEMP_COLOR; print_color " ${CURRENT}\n\n"; unset TEMP_COLOR


# OWN_extensions.cfg
if [ ! -f OWN_extensions.cfg ]; then OWNEXTENS=$(find $(dirname $PWD) -name OWN_extensions.cfg | grep COMMON); else OWNEXTENS=$PWD/OWN_extensions.cfg; fi
CURRENT="$(cat ${OWNEXTENS} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)"
TEMP_COLOR=lcyan; print_color "${OWNEXTENS} :"; unset TEMP_COLOR; print_color " ${CURRENT}\n\n"; unset TEMP_COLOR


# CA_configuration.cfg
if [ ! -f CA_configuration.cfg ]; then CACONFIG=$(find $(dirname $PWD) -name CA_configuration.cfg | grep COMMON); else CACONFIG=$PWD/CA_configuration.cfg; fi
CURRENT="$(cat ${CACONFIG} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)"
TEMP_COLOR=lcyan; print_color "${CACONFIG} :"; unset TEMP_COLOR; print_color " ${CURRENT}\n\n"; unset TEMP_COLOR

# vars.sh
if [ ! -f vars.sh ]; then VARSSH=$(find $(dirname $PWD) -name vars.sh | grep COMMON); else VARSSH=$PWD/vars.sh; fi
CURRENT="$(cat ${VARSSH} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)"
TEMP_COLOR=lcyan; print_color "${VARSSH} :"; unset TEMP_COLOR; print_color " ${CURRENT}\n\n"; unset TEMP_COLOR



