#!/bin/sh 

USN=$1

curl -s https://ubuntu.com/security/notices/$USN | grep -v 'CVEs' |
  grep '>CVE' | sed 's/^.*CVE/CVE/' | sed 's/<.*//' |
{
  n=0
  while read CVE; do
  n=$((n + 1))
  curl -s https://services.nvd.nist.gov/rest/json/cve/1.0/$CVE |
    jq '.result.CVE_Items[]| 
      [ .cve.CVE_data_meta.ID, 
        .impact.baseMetricV3.cvssV3.baseScore
        ] | @tsv
        ' | (xargs printf; echo)
  done
  echo $n CVEs
}
