#!/bin/sh

#Specify the host part of the FQDN if they are in same domain. Or specify whole FQDN and change line 9 accordingly.
declare -a Target_Hostname_array=(example_host1  example_host2)

for Target_Hostname in "${Target_Hostname_array[@]}"
do
        #Specify the domain part of the FQDN
        this_hostname=${Target_Hostname}.example-domain.com
        # tail -n4 returns first 4 lines of dig ouput, it should be enough to retrieve all A record. 
        # Increase it if there are more A records for the FQDN
        dig +answer ${this_hostname} +short | tail -n4 > ${this_hostname}.txt
        echo "${this_hostname} baseline file created!"
done
