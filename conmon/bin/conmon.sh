#!/bin/bash

# conmon.sh
# This script is used for setting up directories and environment variables for continuous monitoring (ConMon) tasks,
# renaming files to replace spaces with underscores, and processing Nessus and ZAP scan results.
# It includes functions for preparing directories, renaming files, generating Nessus and ZAP summaries, and more.
# Usage:
#   source conmon.sh
#   Call the functions defined in the script as needed.

GFSROOT="/Volumes/GoogleDrive/My Drive/18F_ISSO/FedRAMP JAB - cloud.gov - 3PAO Access"
SCANROOT="${GFSROOT}/ZAP and Nessus results/"
CMROOT="/Users/$(whoami)/Documents/ConMon"
log_file="conmon.log"

# Logging function to log information messages
log_info() {
    echo "[INFO] $1" | tee -a $log_file
}

# Logging function to log error messages
log_error() {
    echo "[ERROR] $1" | tee -a $log_file >&2
}

# Function to log and handle failures
cmfail() {
  log_error "$*"
  return 1
}

# Function to set up directories and environment variables
setup_dirs() {
  year=$1
  mo=$2
  dy=$3

  [ -z "$year" ] && cmfail "Call 'setup_dirs YYYY MM DD'" && return 1
  [ -z "$mo" ] && cmfail "Call 'setup_dirs YYYY MM DD'" && return 1
  [ -z "$dy" ] && cmfail "Call 'setup_dirs YYYY MM DD'" && return 1

  MonthDir="$CMROOT/$year/$mo"
  ProdToolDir="$MonthDir/Production-and-Tooling-Vulnerability-and-Compliance-scans_$year-$mo-$dy"
  RDSDir="$MonthDir/RDS_Compliance_Scans_$year-$mo-$dy"
  nessus_scans="$ProdToolDir/Production Vulnerability ?can*.nessus $ProdToolDir/Tooling Vulnerability ?can*.nessus"

  log_info "Setting up directories and env vars"
  set -x
  mkdir -p "$ProdToolDir" || log_error "Failed to create $ProdToolDir"
  mkdir -p "$RDSDir" || log_error "Failed to create $RDSDir"
  export MonthDir
  export ProdToolDir
  export REMOTEROOT="$SCANROOT/${year}${mo}${dy}-ZAP-Nessus"
  export CMYEAR=$year
  export CMMO=$mo
  export CMDY=$dy
  set +x
}

# Function to replace spaces with underscores in filenames
spaces2underscore() {
    log_info "Replacing spaces with underscores in filenames"
    for i in *\ *; do
        new="${i// /_}"
        mv "$i" "$new" || log_error "Failed to rename $i to $new"
    done
}

# Function to process Nessus scan results for Log4j vulnerabilities
nessus_log4j() {
  printf "======\nFULL REPORT\n=====\n"
  eval parse-nessus-xml.py -l "$nessus_scans"
  printf "\n\n======\nSUMMARY FOR CONMON\n=====\n"
  eval parse-nessus-xml.py -l "$nessus_scans" | grep -E '(UNSAFE|plugin)'
}

# Function to process Nessus scan results for daemons
nessus_daemons() {
  eval parse-nessus-xml.py -d "$nessus_scans"
}

# Function to generate a CSV from Nessus scan results
nessus_csv() {
  [ -z "$CMMO" ] && cmfail "need to set CMMO" && return 1
  this="$CMROOT/$CMYEAR/$CMMO.nessus.csv"
  parse-nessus-xml.py -m 9 -c "$nessus_scans" 2>/dev/null | tail +3 > "$this" || log_error "Failed to create CSV from Nessus scans"
  log_info "$this ready"
}

# Function to prepare Nessus scan summaries
prep_nessus() {
  set -x
  [ -z "$CMMO" ] && cmfail "need to set CMMO" && return 1
  this="$CMROOT/$CMYEAR/$CMMO.nessus_summary.txt"
  if [ "$CMMO" = 01 ]; then
    last_mo=12
    last_yr=$((CMYEAR - 1))
    last="$CMROOT/$last_yr/$last_mo.nessus_summary.txt"
  else
    this_mo="${CMMO#0}"
    last_mo=$(printf "%02d\n" $((this_mo - 1)))
    last="$CMROOT/$CMYEAR/$last_mo.nessus_summary.txt"
  fi

  eval parse-nessus-xml.py -m 9 -s "$nessus_scans" |
      grep -Ev '(SUMMARY|CSV)' | grep -v '^33851,' | # 33851 is unmanaged daemons
      grep -v '^$' | gsed -e 's/\t/../' > "$this" || log_error "Failed to create Nessus summary"

  work="$CMROOT/$CMYEAR/$CMMO.nessus_work.txt"
  cat > "$work" <<END
LAST MONTH (fixed)
    THIS MONTH (new)
        BOTH  (persisting)
END
  comm "$last" "$this" >> "$work" || log_error "Failed to compare last and this month's summaries"
  set +x
  log_info "$work ready"
}

# Function to prepare ZAP scan summaries
prep_zap() {
  [ -z "$CMMO" ] && cmfail "need to set CMMO" && return 1
  [ "$CMMO" = 1 ] && cmfail "not set up for year rollover" && return 1
  this="$CMROOT/$CMYEAR/$CMMO.zap_summary.txt"
  this_mo="${CMMO#0}"
  last_mo=$(printf "%02d\n" $((this_mo - 1)))
  last="$CMROOT/$CMYEAR/$last_mo.zap_summary.txt"

  parse-owasp-zap-xml.py "$MonthDir"/*-ZAP-*.xml | 
    gsed 's/\t/../' | uniq > "$this" || log_error "Failed to create ZAP summary"

  work="$CMROOT/$CMYEAR/$CMMO.zap_work.txt"
  cat > "$work" <<END
LAST MONTH (fixed)
    THIS MONTH (new)
        BOTH  (persisting)
END
  comm "$last" "$this" >> "$work" || log_error "Failed to compare last and this month's summaries"
  log_info "$work ready"
}

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This script is meant to be sourced, not executed directly."
fi
