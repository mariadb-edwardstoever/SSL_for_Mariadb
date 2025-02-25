# SSL/TLS for Mariadb

Created February, 2025 

To download the mariadb_quick_review script direct to your linux server, you may use git or wget:
```
git clone https://github.com/mariadb-edwardstoever/SSL_for_Mariadb.git
```
```
wget https://github.com/mariadb-edwardstoever/SSL_for_Mariadb/archive/refs/heads/master.zip
```

## Overview
The goal of this project is to make the task of generating one or more certificates for your Mariadb installations as easy as possible.

## Important items to be aware of
* Transport Layer Security (TLS) was formerly known as Secure Socket Layer (SSL). The program for creating scripts is "openssl". Thus the terms SSL and TLS are often used interchangeably, even though _technically_ TLS is a more modern and more secure protocol.
* This project will help you to create signed certificates for the connections on your private network (intranet). It will be easy for you to make the CA certificate provided in the project trusted by your hosts.
* By using this project to create your certificates for SSL/TLS, you will not have to share the subdomains of your intranet on the open internet.
* Starting from 11.4, MariaDB server enables TLS automatically. Certificates are generated on startup and stored in memory. Certificate verification is enabled by default on the client side and certificates are verified if the authentication plugin itself is MitM safe (mysql_native_password, ed25519, parsec). If you are using 11.4 software or higher, your connections to the database are secure without having to generate and manage certificates on the server.
* Even with the advent of 11.4, there are good reasons to use TLS certificates, such as for maxscale. 

# INSTRUCTIONS

Begin by changing directory into your linux distribution (REDHAT or DEBIAN) and running the script step_1.sh
```
./step_1.sh
```
That copies the file `vars.sh` into the current working directory.
### Edit the vars.sh file that is copied into the working directory.
Each option in the file is fully explained. Make changes where necessary. 

---
Next run the script step_2.sh
```
./step_2.sh
```

### Edit the cfg files that are copied into the working directory.

### OWN_org_details.cfg
This file is where you will put details about your own organization.

### OWN_all-purpose_extensions.cfg
Edit this file so that the DNS.1 equals a wildcard of your domain.

### CA_configuration.cfg
If you create your own CA Certificate, you can edit this file to generate a Certificate Authority organization that you want.

---
Next run the script step_3.sh. If you create your own CA Certificate, you will need to input a passphrase multiple times. 
```
./step_3.sh
```

---
Next, run the script step_4.sh. If created your own CA Certificate, you will need to input the passphrase for each signed certificate you create.
```
./step_4.sh
```

---
Next, run the script add_CA_to_host_trust_store.sh
```
./add_CA_to_host_trust_store.sh
```
This script will add the CA to the hosts trust store. It will then verify that each certificate is now trusted. Finally, it will copy the certificates to the directory you specified by the variable PUBLISH_DIR (default /etc/mariadb/certs).

---
Next, change directories to PUBLISH_DIR/HOW_TO (default /etc/mariadb/certs/HOW_TO).
Here, you will find scripts that will output instructions for configuring Mariadb software to use your certificates. Run each script to recieve instructions specific to the certificates you generated.
 


RE: Support tickets CS0755469, 211733

