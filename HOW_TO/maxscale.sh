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

if [ "$LINUX_TYPE" == "REDHAT" ]; then
  INSTALL_CLIENT="yum install MariaDB-client"
else
  INSTALL_CLIENT="apt install mariadb-client"
fi
KEYFILE=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.key)
ALLPURPOSEPEM=$(ls $PUBLISH_DIR/$MY_ORGANIZATION.pem)
CLIENTPEM=$(ls $PUBLISH_DIR/client_$MY_ORGANIZATION.pem)
SERVERPEM=$(ls $PUBLISH_DIR/server_$MY_ORGANIZATION.pem)

if [ ! $SERVERPEM ] && [ ! $ALLPURPOSEPEM ]; then echo "NO AVAILABLE PEM!"; exit 1; fi

if [  $SERVERPEM ] && [ ! $ALLPURPOSEPEM ]; then
  DEMOPEM=$SERVERPEM
else
  DEMOPEM=$ALLPURPOSEPEM
fi

OUTPUT="
Set up the Mariadb Database Server for SSL/TLS before setting up maxscale. Note that for Mariadb Server 11.4 and higher
you do not need to set it up because certificates are generated on startup and stored in memory.

It is a good idea to install the mariadb client on the maxscale server. It is an excellent tool for testing 
connections and general debugging. For example:
${INSTALL_CLIENT}
 
Use the scp command to copy the contents of the ${PUBLISH_DIR} directory to the same location on maxscale server.

Run the script add_CA_to_host_trust_store.sh on the maxscale server. 

Use the following settings in /etc/maxscale.cnf file:

[maxscale]
threads=auto
admin_host            = 0.0.0.0
admin_port            = 8989
admin_ssl_key  = ${KEYFILE}
admin_ssl_cert = ${DEMOPEM}
admin_ssl_ca   = ${PUBLISH_DIR}/myCA.pem

Use systemctl to restart maxscale.

You can test to see if curl will load the admin portal, recognizing the certificate as valid for https. 
For example, if the name maxscale.widgets-and-gadgets.com can be resolved from DNS or an entry 
in /etc/hosts the following curl command should work without error:
curl  https://maxscale.widgets-and-gadgetsx.com:8989

If you add the file myCA.pem into the trusted root certificates on your work-station, your browser will be able 
to open the URL https://maxscale.widgets-and-gadgetsx.com:8989 without warning that the connection is not secure.
The initial user/password for login to the admin GUI is admin/mariadb.

After you have the admin GUI running properly, you can 



"

printf "${OUTPUT}"
