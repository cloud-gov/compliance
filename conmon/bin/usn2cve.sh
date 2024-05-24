#!/bin/sh 

# usn2cve.sh
# This script fetches CVE details for a given USN (Ubuntu Security Notice)
# It retrieves the CVEs from the USN page on the Ubuntu website and then
# fetches detailed information for each CVE from the NVD (National Vulnerability Database) API.
# Usage:
#   ./usn2cve.sh USN-XXXX-XX

USN=$1
log_file="usn2cve.log"

# Logging function to log information messages
log_info() {
    echo "[INFO] $1" | tee -a $log_file
}

# Logging function to log error messages
log_error() {
    echo "[ERROR] $1" | tee -a $log_file >&2
}

# Check if a USN was provided as an argument
if [ -z "$USN" ]; then
    log_error "No USN provided. Usage: ./usn2cve.sh USN-XXXX-XX"
    exit 1
fi

# Fetch CVEs from Ubuntu Security Notices
cve_list=$(curl -s "https://ubuntu.com/security/notices/$USN" | grep -v 'CVEs' | grep '>CVE' | sed 's/^.*CVE/CVE/' | sed 's/<.*//')

# Check if any CVEs were found
if [ -z "$cve_list" ]; then
    log_error "No CVEs found for USN $USN"
    exit 1
fi

# Process CVEs in a loop
n=0
cve_count() {
  while read -r CVE; do
      n=$((n + 1))
      # Fetch CVE details from NVD
      cve_details=$(curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0/$CVE" | jq '.result.CVE_Items[]| [ .cve.CVE_data_meta.ID, .impact.baseMetricV3.cvssV3.baseScore ] | @tsv')
      
      # Check if any details were found for the CVE
      if [ -z "$cve_details" ]; then
          log_error "No details found for CVE $CVE"
          continue
      fi
      
      # Print CVE details
      printf "%s\n" "$cve_details" | (xargs printf; echo)
  done
}

# Process the list of CVEs
echo "$cve_list" | cve_count

# Log the number of CVEs processed
log_info "$n CVEs processed"
