#!/bin/sh

# Assign the first script argument to the USN variable
USN=$1

# Fetch the Ubuntu security notice HTML page for the given USN
# Filter out lines containing 'CVEs', then extract lines with CVE identifiers
# Use sed to format the lines to contain only the CVE IDs
curl -s "https://ubuntu.com/security/notices/$USN" | grep -v 'CVEs' |
  grep '>CVE' | sed 's/^.*CVE/CVE/' | sed 's/<.*//' |
{
  n=0 # Initialize a counter for the number of CVEs
  # Read each CVE ID from the previous command's output
  while read -r CVE; do
    n=$((n + 1)) # Increment the CVE counter
    # Fetch the CVE details from the NVD API and format the output with jq
    curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0/$CVE" |
      jq '.result.CVE_Items[] |
        [ .cve.CVE_data_meta.ID,
          .impact.baseMetricV3.cvssV3.baseScore
        ] | @tsv' | (xargs printf; echo) # Print the CVE ID and base score
  done
  echo "$n CVEs" # Print the total number of CVEs
}
