#!/bin/bash

# Call from the RDS directory, e.g.:
#   cd 2022/04/RDS_Compliance_Scans_2022-04-22
#   ../../../parse-rds.sh

# Process each line in the heredoc
while read -r rds_info; do
  # Split the line into an array using '|' as the delimiter
  IFS='|' read -r -a array <<< "$rds_info"
  nessus=${array[0]}
  name=${array[1]}
  
  echo
  echo "========== $name ========="
  # Display host IP
  grep 'name="host-ip">' "$nessus"
  # Display host FQDN
  grep 'name="host-fqdn">' "$nessus"
  # Display Version
  grep "Version    " "$nessus"
  # Parse Nessus XML and display summary to CSV
  parse-nessus-xml.py "$nessus" | awk '/SUMMARY/,/CSV/'
done <<EOF
RDS_Compliance_-_Credhub_Prod_??????.nessus|credhub/production
RDS_Compliance_-_Credhub_Tooling_??????.nessus|credhub/tooling
RDS_Compliance_-_OpsUAA_Tooling_??????.nessus|opsuaa/tooling
RDS_Compliance_Scan_-_ATC_Tooling_??????.nessus|atc/tooling
RDS_Compliance_Scan_-_Bosh_Tooling_??????.nessus|bosh/tooling
RDS_Compliance_Scan_BOSH_Prod_??????.nessus|bosh/production
RDS_Compliance_Scan_CF_Prod_??????.nessus|ccdb/production
EOF
