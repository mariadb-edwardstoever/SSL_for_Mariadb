#!/usr/bin/env bash
# Script by Edward Stoever for Mariadb Support
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR


if [ ! -f vars.sh ]; then
  echo "vars.sh does not exist. Scripts must be run in the proper order. Exiting."; exit 1
fi
source ${SCRIPT_DIR}/functions.sh
source ${SCRIPT_DIR}/vars.sh 2>/dev/null

MY_ORGANIZATION=$(echo ${MY_ORGANIZATION} | sed 's/ //g')


unset ERR
get_linux_type;

TEMP_COLOR=lcyan; print_color "Detected Linux Type: ${LINUX_TYPE}\n\n"; unset TEMP_COLOR;

if [ ! "${LINUX_TYPE}" == "DEBIAN" ] && [ ! "${LINUX_TYPE}" == "REDHAT" ] && [ ! "${LINUX_TYPE}" == "UBUNTU" ] && [ ! "${LINUX_TYPE}" == "ROCKYL" ]; then
  TEMP_COLOR=lred; print_color "Unsupported Linux type. Exiting.\n\n"; exit 1
fi 

if [ ! -f myCA.pem ]; then
  TEMP_COLOR=lred; print_color "The file myCA.pem does not exist in $SCRIPT_DIR. "; unset TEMP_COLOR; print_color "\nNothing done.\n"
exit 1
fi

if [ "${LINUX_FAMILY}" == "DEBIAN" ] && [ ! -d /usr/local/share/ca-certificates/ ]; then 
 TEMP_COLOR=lred; print_color "The directory /usr/local/share/ca-certificates/ does not exist. "; unset TEMP_COLOR; print_color "\nNothing done.\n"
 exit 1
fi

if [ "${LINUX_FAMILY}" == "REDHAT" ] && [ ! -d /etc/pki/ca-trust/source/anchors ]; then 
  TEMP_COLOR=lred; print_color "The directory /etc/pki/ca-trust/source/anchors does not exist. "; unset TEMP_COLOR; print_color "\nNothing done.\n"
  exit 1
fi

if [ "${LINUX_FAMILY}" == "DEBIAN" ]; then
  cp myCA.pem /usr/local/share/ca-certificates/myCA.crt || ERR=true
  update-ca-certificates || ERR=true
fi

if [ "${LINUX_FAMILY}" == "REDHAT" ]; then
  cp myCA.pem /etc/pki/ca-trust/source/anchors/ || ERR=true
  update-ca-trust extract || ERR=true
fi


if [ ${ERR} ]; then
  TEMP_COLOR=lred; print_color "Something went wrong.\n"; exit 1
else
  TEMP_COLOR=lgreen; print_color "myCA added to trust store.\n"; unset TEMP_COLOR;
fi



TEMP_COLOR=lcyan; print_color "Testing each certificate against the trusted store.\nEach will respond with OK if the Certificate Authority is trusted on this server.\n"; unset TEMP_COLOR;
# This command will verify against trust store
if [ -f myCA.pem ]; then
  openssl verify ./myCA.pem
fi

if [ -f ${MY_ORGANIZATION}.pem ]; then
  openssl verify ./${MY_ORGANIZATION}.pem
fi

if [ -f server_${MY_ORGANIZATION}.pem ]; then
  openssl verify ./server_${MY_ORGANIZATION}.pem
fi

if [ -f client_${MY_ORGANIZATION}.pem ]; then
  openssl verify ./client_${MY_ORGANIZATION}.pem
fi
echo ""
unset ERR
if [ "$SCRIPT_DIR" != "$PUBLISH_DIR" ]; then
  mkdir -p  ${PUBLISH_DIR}/HOW_TO/ || ERR=TRUE
  CHMODDIR=${PUBLISH_DIR}/HOW_TO
  if [ -d ${CHMODDIR} ]; then
    # MAKE ALL DIRECTORIES WITH CORRECT MODE
    while [ "$CHMODDIR" != "/" ]; do echo "Certifying mode of ${CHMODDIR}"; chmod 755 $CHMODDIR; CHMODDIR=$(dirname "$CHMODDIR"); done
  fi
  cp  ${MY_ORGANIZATION}.key ${PUBLISH_DIR}/ || ERR=TRUE
  cp *.pem ${PUBLISH_DIR}/ || ERR=TRUE
  cp vars.sh  ${PUBLISH_DIR}
  cp add_CA_to_host_trust_store.sh ${PUBLISH_DIR}
  cp functions.sh ${PUBLISH_DIR}
  cp about.txt ${PUBLISH_DIR}/
  cp ../HOW_TO/* ${PUBLISH_DIR}/HOW_TO/
  chmod -R 644 ${PUBLISH_DIR}/*.key
  chmod -R 644 ${PUBLISH_DIR}/*.pem
  if [ $ERR ]; then
    TEMP_COLOR=lred;  print_color "Something went wrong copying files to the directory ${PUBLISH_DIR}\n\n"; unset TEMP_COLOR
  else
    TEMP_COLOR=lgreen;  print_color "Files copied to ${PUBLISH_DIR}\n\n";  unset TEMP_COLOR
    TEMP_COLOR=lcyan; print_color "Your work in this directory is completed.\nMove to the directory ${PUBLISH_DIR}/HOW_TO/ \nRun the scripts in that directory for instructions on how to use certificates\nwith Mariadb products to secure connections with TLS.\n\n"
  fi
fi

