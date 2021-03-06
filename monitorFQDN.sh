#!/bin/sh

LOG_FILE=/var/log/monitorFQDN-script.log
exec 3>&1 1>>${LOG_FILE} 2>&1
Working_Dir=/root/scripts/monitorFQDN/

declare -a Target_Hostname_array=(host1 host2 host3)

for Target_Hostname in "${Target_Hostname_array[@]}"
do

        this_hostname=${Target_Hostname}.domain.com
          echo "${this_hostname}"

        resolve_array=( $(dig +answer $this_hostname +short | tail -n4) )
        resolve_array_length=${#resolve_array[@]}
        #echo $resolve_array_length

        for resolve_result in "${resolve_array[@]}"
        do
          echo "${resolve_result}"
          if grep -Fx ${resolve_result} ${Working_Dir}${this_hostname}.txt
        then
                echo "${Working_Dir}${this_hostname}.txt"
                echo "FQDN resolve unchanged!"
        else
                echo "FQDN resolve changed! Sending email"
                #echo "FQDN resolve changed! Attached is configured. Check FW Now!" | mail -s "FQDN Changed! ${this_hostname}" -a ${Working_Dir}${this_hostname}.txt -r 'monitorFQDN <monitorFQDN.no-reply@example.com>' example@example.com
                
                #Send email notification including old and new IP resolve.
                printf "FQDN resolve changed! \nNew IP are\n$(dig +answer ${this_hostname} +short | tail -n4) \n\nOld IP are\n$(cat ${Working_Dir}${this_hostname}.txt) \n" | mail -s "FQDN Changed! ${this_hostname}" -a ${Working_Dir}${this_hostname}.txt -r 'FQDN Monitor <monitorFQDN.no-reply@example.com>' example@example.com
                                
                #Overwrite baseline file if FQDN resolve is changed. So the email notification will be sent for only once.
                dig +answer ${this_hostname} +short | tail -n4 > ${Working_Dir}${this_hostname}.txt
        fi
        done
done
