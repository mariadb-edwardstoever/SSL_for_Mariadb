#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support

function print_color () {
  if [ -z "$TEMP_COLOR" ]; then printf "$1"; return; fi
if [ $TEMP_COLOR ]; then
  case "$TEMP_COLOR" in
    default) i="0;36" ;; red)  i="0;31" ;; blue) i="0;34" ;; green) i="0;32" ;; yellow) i="0;33" ;; magenta) i="0;35" ;; cyan) i="0;36" ;; lred) i="1;31" ;; lblue) i="1;34" ;; lgreen) i="1;32" ;; lyellow) i="1;33" ;; lmagenta) i="1;35" ;; lcyan) i="1;36" ;; *) i="0" ;;
  esac
fi
  printf "\033[${i}m${1}\033[0m"
}


function get_linux_type () {
  LINUX_TYPE=$(cat /etc/os-release | grep PRETTY |cut -d\" -f2 | head -c 7 | sed "s/ //g"| tr '[:lower:]' '[:upper:]')
}

function get_current_md5s () {
# myCA.key
if [ ! -f myCA.key ]; then MYCAKEY=$(find $(dirname $PWD) -name myCA.key | grep AUTHORITY); else MYCAKEY=$PWD/myCA.key; fi

# OWN_org_details.cfg
if [ ! -f OWN_org_details.cfg ]; then OWNORGDET=$(find $(dirname $PWD) -name OWN_org_details.cfg | grep COMMON); else OWNORGDET=$PWD/OWN_org_details.cfg; fi

# OWN_extensions.cfg
if [ ! -f OWN_extensions.cfg ]; then OWNEXTENS=$(find $(dirname $PWD) -name OWN_extensions.cfg | grep COMMON); else OWNEXTENS=$PWD/OWN_extensions.cfg; fi

# CA_configuration.cfg
if [ ! -f CA_configuration.cfg ]; then CACONFIG=$(find $(dirname $PWD) -name CA_configuration.cfg | grep COMMON); else CACONFIG=$PWD/CA_configuration.cfg; fi

# vars.sh
if [ ! -f vars.sh ]; then VARSSH=$(find $(dirname $PWD) -name vars.sh | grep COMMON); else VARSSH=$PWD/vars.sh; fi

# myCA.key
CURR_MD5MYCAKEY="$(md5sum ${MYCAKEY} | awk '{print $1}')" 

# OWN_org_details.cfg
CURR_MD5OWNORGD="$(cat ${OWNORGDET} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" 

# OWN_extensions.cfg
CURR_MD5OWNEXTN="$(cat ${OWNEXTENS} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" 

# CA_configuration.cfg
CURR_MD5CACONFI="$(cat ${CACONFIG} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)" 

# vars.sh
CURR_MD5VARS_SH="$(cat ${VARSSH} | grep -v "^#" | tr -d "[:space:]" | md5sum |  cut -d' ' -f1)"
}

MD5MYCAKEY="24a044e4a0d8e0467105cb6a3784401d" # myCA.key
MD5OWNORGD="f3b77ede7c399bf5648e4b3bce23158e" # OWN_org_details.cfg
MD5OWNEXTN="e07a9dadf771d734cf1cf3ba0e44d8a5" # OWN_extensions.cfg
MD5CACONFI="ebbed6f7c0482fe4ec734bcc0e8469c8" # CA_configuration.cfg
MD5VARS_SH="27d17bfe16d06a5b24665fbdaa32d73a" # vars.sh

