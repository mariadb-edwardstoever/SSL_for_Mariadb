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
OPTIONS_FILE='/etc/mysql/mariadb.conf.d/zz-custom-ssl-server.cnf' # DEFAULT (DEBIAN)
if [ "$LINUX_TYPE" == "REDHAT" ]; then OPTIONS_FILE='/etc/my.cnf.d/zz-custom-ssl-server.cnf'; fi

KEYFILE=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.key)
ALLPURPOSEPEM=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.pem)
CLIENTPEM=$(ls $PUBLISH_DIR/client_$MY_ORGANIZATION.pem)
SERVERPEM=$(ls $PUBLISH_DIR/server_$MY_ORGANIZATION.pem)

if [ ! $SERVERPEM ] && [ ! $ALLPURPOSEPEM ]; then echo "NO AVAILABLE PEM!"; exit 1; fi

if [ ! $SERVERPEM ] && [ $ALLPURPOSEPEM ]; then
  DEMOPEM=$ALLPURPOSEPEM
else
  DEMOPEM=$SERVERPEM
fi

OUTPUT="
#####################
Using an Options file
#####################
If you create the options file ${OPTIONS_FILE} for your database server, and it looks like this:

  [mariadbd]
  ssl-cert = $DEMOPEM
  ssl-key  = $KEYFILE
  ssl-ca   = $PUBLISH_DIR/myCA.pem

You can review the values in the [mariadbd] groups of your options files with this command:
  my_print_defaults mariadbd

You can now restart the mariadb instance, and verify that the values are as expected:
systemctl restart mariadb

mariadb 
select * from information_schema.GLOBAL_VARIABLES where VARIABLE_NAME in('ssl_ca','ssl_cert','ssl_key');
+---------------+-------------------------------------------------------+
| VARIABLE_NAME | VARIABLE_VALUE                                        |
+---------------+-------------------------------------------------------+
| SSL_CA        | /etc/mariadb/certs/myCA.pem                           |
| SSL_CERT      | /etc/mariadb/certs/server_widgets-and-gadgets.com.pem |
| SSL_KEY       | /etc/mariadb/certs/widgets-and-gadgets.com.key        |
+---------------+-------------------------------------------------------+

"

printf "${OUTPUT}"
