#!/bin/bash 

# Call from the RDS directory, e.g.:
#   cd 2022/04/RDS_Compliance_Scans_2022-04-22
#   ../../../parse-rds.sh

while read rds_info; do
  IFS='|' read -r -a array <<< "$rds_info"
  nessus=${array[0]}
  name=${array[1]}
#  nessus_file=`ls $nessus || 
  echo
  echo =========== $name =========
  grep 'name="host-ip">' $nessus
  grep 'name="host-fqdn">' $nessus
  grep "Version    " $nessus
  parse-nessus-xml.py $nessus | awk '/SUMMARY/,/CSV/'
done<<EOF
RDS_Compliance_-_Credhub_Prod_??????.nessus|credhub/production
RDS_Compliance_-_Credhub_Tooling_??????.nessus|credhub/tooling
RDS_Compliance_-_OpsUAA_Tooling_??????.nessus|opsuaa/tooling
RDS_Compliance_Scan_-_ATC_Tooling_??????.nessus|atc/tooling
RDS_Compliance_Scan_-_Bosh_Tooling_??????.nessus|bosh/tooling
RDS_Compliance_Scan_BOSH_Prod_??????.nessus|bosh/production
RDS_Compliance_Scan_CF_Prod_??????.nessus|ccdb/production
EOF
