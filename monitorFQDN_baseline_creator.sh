#!/bin/sh

declare -a Target_Hostname_array=(example_host1  example_host2)

for Target_Hostname in "${Target_Hostname_array[@]}"
do

        this_hostname=${Target_Hostname}.example-domain.com
                
                dig +answer ${this_hostname} +short | tail -n4 > ${this_hostname}.txt
        echo "${this_hostname} baseline file created!"
done
