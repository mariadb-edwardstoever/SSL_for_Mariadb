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
OPTIONS_FILE='/etc/mysql/mariadb.conf.d/50-client.cnf' # DEFAULT (DEBIAN)
if [ "$LINUX_TYPE" == "REDHAT" ]; then OPTIONS_FILE='/etc/my.cnf.d/client.cnf'; fi

KEYFILE=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.key)
ALLPURPOSEPEM=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.pem)
CLIENTPEM=$(ls $PUBLISH_DIR/client_$MY_ORGANIZATION.pem)
SERVERPEM=$(ls $PUBLISH_DIR/server_$MY_ORGANIZATION.pem)

if [ ! $CLIENTPEM ] && [ ! $ALLPURPOSEPEM ]; then echo "NO AVAILABLE PEM!"; exit 1; fi

if [ ! $CLIENTPEM ] && [ $ALLPURPOSEPEM ]; then
  DEMOPEM=$ALLPURPOSEPEM
else
  DEMOPEM=$CLIENTPEM
fi

OUTPUT="There are two methods for connecting the mariadb client to a server using SSL.

######################################
METHOD #1 using command line arguments
######################################
  Command line arguments override any values saved in options files. 
  Assuming the user is edward, password is MYPASSWORD, and host is 192.168.8.200
  If the CA certificate is trusted on the server, this command should work:
    mariadb --ssl-cert=$DEMOPEM --ssl-key=$KEYFILE -h 192.168.8.200 -u edward -pMYPASSWORD

  If that command does not work you can try this:
    mariadb --ssl-ca=$PUBLISH_DIR/myCA.pem --ssl-cert=$DEMOPEM --ssl-key=$KEYFILE -h 192.168.8.200 -u edward -pMYPASSWORD

Verify that any connection is using SSL with this SQL statement:
SHOW SESSION STATUS LIKE 'Ssl_cipher';
+---------------+------------------------+
| Variable_name | Value                  |
+---------------+------------------------+
| Ssl_cipher    | TLS_AES_256_GCM_SHA384 |
+---------------+------------------------+

If the Value is not null or empty, then the connection is using SSL.

###############################
METHOD #2 using an Options file
###############################
If you set up an options file for clients, it will use the values you place in the section headed with [client]. 
For example, in the file $OPTIONS_FILE, you add this section:

  [client]
  ssl-cert = $DEMOPEM
  ssl-key  = $KEYFILE
  ssl-ca   = $PUBLISH_DIR/myCA.pem

You can review the values in the [client] groups of your options files with this command:
  my_print_defaults client

You can now connect with this much shorter command:
  mariadb -h 192.168.8.200 -u edward -pMYPASSWORD

"

printf "${OUTPUT}"
