#!/bin/sh

LOG_FILE=/var/log/monitorFQDN-script.log
exec 3>&1 1>>${LOG_FILE} 2>&1

declare -a Target_Hostname_array=(example1 example2 example3)

for Target_Hostname in "${Target_Hostname_array[@]}"
do

        this_hostname=${Target_Hostname}.example.domain
          echo "${this_hostname}"

        resolve_array=( $(dig +answer $this_hostname +short | tail -n4) )
        resolve_array_length=${#resolve_array[@]}
        #echo $resolve_array_length

        for resolve_result in "${resolve_array[@]}"
        do
          echo "${resolve_result}"
          if grep -Fx ${resolve_result} ${this_hostname}.txt
        then
                echo "FQDN resolve unchanged!"
        else
                echo "FQDN resolve changed! Sending email"
                echo "FQDN resolve changed! Attached is configured. Check FW Now!" | mail -s "FQDN Changed! ${this_hostname}" -a ${this_hostname}.txt -r 'Cisco TACACS Report <monitorFQDN.no-reply@philips.com>' your_email_addr@example.com
        fi
        done
done
