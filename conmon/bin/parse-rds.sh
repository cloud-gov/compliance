#!/bin/bash

# parse-rds.sh
# This script parses RDS compliance scan results and outputs relevant information.
# It reads from a predefined list of Nessus files and associated names, then extracts
# and processes data from these files.
# Usage:
#   cd to the directory containing the Nessus files
#   ../../../parse-rds.sh

log_file="parse-rds.log"

# Logging function to log information messages
log_info() {
    echo "[INFO] $1" | tee -a "$log_file"
}

# Logging function to log error messages
log_error() {
    echo "[ERROR] $1" | tee -a "$log_file" >&2
}

# Main processing function
process_rds() {
    local nessus="$1"
    local name="$2"

    if [ ! -f "$nessus" ]; then
        log_error "Nessus file $nessus not found for $name"
        return 1
    fi

    echo
    echo "========== $name ========="
    log_info "Processing $nessus for $name"

    grep 'name="host-ip">' "$nessus" || log_error "No host-ip found in $nessus"
    grep 'name="host-fqdn">' "$nessus" || log_error "No host-fqdn found in $nessus"
    grep "Version    " "$nessus" || log_error "No version found in $nessus"

    parse-nessus-xml.py "$nessus" | awk '/SUMMARY/,/CSV/' || log_error "Failed to parse $nessus with parse-nessus-xml.py"
}

# List of RDS compliance scan results to process
rds_list=(
    "RDS_Compliance_-_Credhub_Prod_??????.nessus|credhub/production"
    "RDS_Compliance_-_Credhub_Tooling_??????.nessus|credhub/tooling"
    "RDS_Compliance_-_OpsUAA_Tooling_??????.nessus|opsuaa/tooling"
    "RDS_Compliance_Scan_-_ATC_Tooling_??????.nessus|atc/tooling"
    "RDS_Compliance_Scan_-_Bosh_Tooling_??????.nessus|bosh/tooling"
    "RDS_Compliance_Scan_BOSH_Prod_??????.nessus|bosh/production"
    "RDS_Compliance_Scan_CF_Prod_??????.nessus|ccdb/production"
)

# Process each entry in the list
for rds_info in "${rds_list[@]}"; do
    IFS='|' read -r nessus name <<< "$rds_info"
    process_rds "$nessus" "$name"
done
