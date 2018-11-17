# monitorFQDN
Monitor FQDN change, compare with local baseline, send email alert when there is change.


Create local baseline FQDN resolve record in working directory
dig +answer host1.example.com +short | tail -n4 > host1.example.com.txt
dig +answer host2.example.com +short | tail -n4 > host2.example.com.txt
dig +answer host3.example.com +short | tail -n4 > host3.example.com.txt


Create crontab entry
# Monitor FQDN change
*/2 * * * * /root/scripts/monitorFQDN/monitorFQDN.sh
