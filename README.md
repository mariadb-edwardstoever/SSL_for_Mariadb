# SSL in Maxscale and Replication

### Notes by Edward Stoever for Mariadb Support
Created February, 2025 

##### ATTENTION ######
```
It is assumed you have a basic knowledge of Linux system administration.
It is assumed you have a basic knowledge of how a MariaDB database and Maxscale are administered. 
The commands in this project are written as scripts for the bash command line.
If you do not have the experience to understand the bash scripts and commands herein, 
you should take the time to learn them in a test environment.
```

# INSTRUCTIONS

Begin by changing directory into your linux distribution (REDHAT or DEBIAN) and running the script step_1.sh
```
./step_1.sh
```
That copies the file `vars.sh` into the current working directory.
### Edit the vars.sh file that is copied into the working directory.
Each option in the file is fully explained. Make changes where necessary. 

Next run the script step_2.sh
```
./step_2.sh
```

### Edit the cfg files that are copied into the working directory.

### OWN_org_details.cfg
This file is where you will put details about your own organization.

### OWN_all-purpose_extensions.cfg
If you create an all-purpose certificate, edit this file so that the DNS.1 equals a wildcard of your domain. For example, change `*.widgets-and-gadgets.com` to a wildcard for the domain that you will use for https browser connections. This will be useful for maxscale Admin GUI.

### CA_configuration.cfg
If you create your own CA Certificate, you can edit this file to generate a Certificate Authority organization that you want. It is recommended that the organization not match your own organization so as not to appear self-signed.

Next run the script step_3.sh. If you create your own CA Certificate, you will need to input a passphrase multiple times. _Do not lose your passphrase!_
```
./step_3.sh
```

Next, run the script step_4.sh. If created your own CA Certificate, you will need to input the passphrase for each signed certificate you create.
```
./step_4.sh
```

RE: Support tickets CS0755469, 211733

