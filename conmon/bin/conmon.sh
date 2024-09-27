#!/bin/bash

# conmon.sh - Continuous Monitoring Script
# Sets up directories, handles Nessus scan processing, and generates reports

# Define root directories
GFSROOT="/Volumes/GoogleDrive/My Drive/18F_ISSO/FedRAMP JAB - cloud.gov - 3PAO Access"
SCANROOT="${GFSROOT}/ZAP and Nessus results"
CMROOT="$HOME/Documents/ConMon"
LOG_FILE="$CMROOT/conmon.log"

# Enable logging to a log file
exec > >(tee -a $LOG_FILE) 2>&1

# Fail function for error handling
cmfail() {
  echo -e "\e[31mFAIL:\e[0m $*" >&2
  return 1
}

# Setup directories based on date
setup_dirs() {
  local year="$1"
  local mo="$2"
  local dy="$3"

  if [[ -z "$year" || -z "$mo" || -z "$dy" ]]; then
    cmfail "Usage: setup_dirs YYYY MM DD"
    return 1
  fi

  MonthDir="$CMROOT/$year/$mo"
  mkdir -p "$MonthDir" || cmfail "Failed to create directory: $MonthDir"

  echo -e "\e[32mDirectory created:\e[0m $MonthDir"
  echo "Please move all Nessus scan files into this directory."

  export MonthDir
  export REMOTEROOT="$SCANROOT/${year}${mo}${dy}-ZAP-Nessus"
  export CMYEAR="$year"
  export CMMO="$mo"
  export CMDY="$dy"
}

# Collect Nessus scan files from the relevant subfolders
collect_nessus_scans() {
  nessus_scans=()

  if [[ -z "$MonthDir" ]]; then
    cmfail "MonthDir is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  # Find all Nessus files in the relevant subfolders (Production, Tooling, RDS)
  if [[ -d "$MonthDir" ]]; then
    while IFS= read -r -d '' file; do
      nessus_scans+=("$file")
    done < <(find "$MonthDir" -type f \( -iname "*.nessus" -o -iname "*.xml" \) -print0)
  else
    cmfail "MonthDir does not exist: $MonthDir"
    return 1
  fi
}

# Generate Nessus reports (Log4J, Daemons, Summary, CSV)
nessus_log4j() {
  collect_nessus_scans || return 1

  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Nessus scan files found. Please ensure the files are in the MonthDir.\e[0m"
    return 1
  fi

  local filtered_scans=()
  for file in "${nessus_scans[@]}"; do
    if [[ "$(basename "$file")" =~ ^(Production|Tooling).*\.nessus$ ]]; then
      filtered_scans+=("$file")
    fi
  done

  if [[ ${#filtered_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Production or Tooling Nessus scan files found.\e[0m"
    return 1
  fi

  local report_dir="$CMROOT/$CMYEAR/$CMMO/reports"
  mkdir -p "$report_dir" || cmfail "Failed to create report directory: $report_dir"

  echo -e "\e[34m======= LOG4J REPORT =======\e[0m"
  parse-nessus-xml.py -l "${filtered_scans[@]}" -o "$report_dir"

  echo -e "\e[34m======= DAEMON REPORT =======\e[0m"
  parse-nessus-xml.py -d "${filtered_scans[@]}" -o "$report_dir"

  echo -e "\e[34m======= SUMMARY FOR CONMON =======\e[0m"
  parse-nessus-xml.py -s "${filtered_scans[@]}" -o "$report_dir"

  echo -e "\e[34m======= CSV REPORT =======\e[0m"
  parse-nessus-xml.py -c "${filtered_scans[@]}" -o "$report_dir"

  echo -e "\e[32mAll reports have been generated and saved to $report_dir\e[0m"
}

# Generate Daemon Report Separately
nessus_daemons() {
  collect_nessus_scans || return 1

  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Nessus scan files found. Please ensure the files are in the MonthDir.\e[0m"
    return 1
  fi

  local filtered_scans=()
  for file in "${nessus_scans[@]}"; do
    if [[ "$(basename "$file")" =~ ^(Production|Tooling).*\.nessus$ ]]; then
      filtered_scans+=("$file")
    fi
  done

  if [[ ${#filtered_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Production or Tooling Nessus scan files found.\e[0m"
    return 1
  fi

  local report_dir="$CMROOT/$CMYEAR/$CMMO/reports"
  mkdir -p "$report_dir" || cmfail "Failed to create report directory: $report_dir"

  echo -e "\e[34m======= DAEMON REPORT =======\e[0m"
  parse-nessus-xml.py -d "${filtered_scans[@]}" -o "$report_dir"

  echo -e "\e[32mDaemon report has been generated and saved to $report_dir/daemon_report.txt\e[0m"
}

# Generate CSV Report Separately
nessus_csv() {
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  collect_nessus_scans || return 1

  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Nessus scan files found. Please ensure the files are in the MonthDir.\e[0m"
    return 1
  fi

  local report_dir="$CMROOT/$CMYEAR/$CMMO/reports"
  mkdir -p "$report_dir" || cmfail "Failed to create report directory: $report_dir"

  parse-nessus-xml.py -c "${nessus_scans[@]}" -o "$report_dir"

  echo -e "\e[32mCSV report has been generated and saved to $report_dir\e[0m"
}

# Prepare Nessus Summary Report
prep_nessus() {
  set -x
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  collect_nessus_scans || return 1

  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo -e "\e[31mNo Nessus scan files found. Please ensure the files are in the MonthDir.\e[0m"
    return 1
  fi

  local report_dir="$CMROOT/$CMYEAR/$CMMO/reports"
  mkdir -p "$report_dir" || cmfail "Failed to create report directory: $report_dir"

  local this_summary="$report_dir/${CMMO}_nessus_summary.txt"
  local last_summary
  if [[ "$CMMO" == "01" ]]; then
    local last_mo="12"
    local last_yr=$(( CMYEAR - 1 ))
    last_summary="$CMROOT/$last_yr/$last_mo/reports/${last_mo}_nessus_summary.txt"
  else
    local this_mo="${CMMO#0}"
    local last_mo
    printf -v last_mo "%02d" $(( this_mo - 1 ))
    last_summary="$CMROOT/$CMYEAR/$last_mo/reports/${last_mo}_nessus_summary.txt"
  fi

  # Generate current summary report using parse-nessus-xml.py
  parse-nessus-xml.py -s "${nessus_scans[@]}" -o "$report_dir"

  local work="$report_dir/${CMMO}_nessus_work.txt"
  {
    echo "LAST MONTH (fixed)"
    echo "  THIS MONTH (new)"
    echo "    BOTH  (persisting)"
    if [[ -f "$last_summary" ]]; then
      # Compare this month's and last month's summaries
      comm -3 <(sort "$last_summary") <(sort "$this_summary")
    else
      echo "No previous month's summary available."
      cat "$this_summary"
    fi
  } > "$work"

  set +x
  echo -e "\e[32mNessus summary work file is ready at $work\e[0m"
}

# Prepare ZAP Summary Report
prep_zap() {
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi
  if [[ "$CMMO" == "01" ]]; then
    cmfail "Year rollover not yet implemented"
    return 1
  fi
  local report_dir="$CMROOT/$CMYEAR/$CMMO/reports"
  mkdir -p "$report_dir" || cmfail "Failed to create report directory: $report_dir"

  local this_summary="$report_dir/${CMMO}_zap_summary.txt"
  local this_mo="${CMMO#0}"
  local last_mo
  printf -v last_mo "%02d" $(( this_mo - 1 ))
  local last_summary="$CMROOT/$CMYEAR/$last_mo/reports/${last_mo}_zap_summary.txt"

  # Generate current ZAP summary
  parse-owasp-zap-xml.py "$MonthDir"/*-ZAP-*.xml |
    sed 's/\t/../' | uniq > "$this_summary"

  local work="$report_dir/${CMMO}_zap_work.txt"
  {
    echo "LAST MONTH (fixed)"
    echo "  THIS MONTH (new)"
    echo "    BOTH  (persisting)"
    if [[ -f "$last_summary" ]]; then
      comm -3 <(sort "$last_summary") <(sort "$this_summary")
    else
      echo "No previous month's ZAP summary available."
      cat "$this_summary"
    fi
  } > "$work"
  echo -e "\e[32mZAP summary work file is ready at $work\e[0m"
}

# Display usage information
usage() {
  echo "Usage: $0 <command> [arguments]"
  echo "Commands:"
  echo "  setup_dirs YYYY MM DD    Set up directories for the specified date."
  echo "  nessus_log4j             Generate Log4J, Daemons, Summary, and CSV reports."
  echo "  nessus_daemons           Generate Daemons report."
  echo "  nessus_csv               Generate CSV report."
  echo "  prep_nessus              Prepare Nessus summary report."
  echo "  prep_zap                 Prepare ZAP summary report."
  exit 1
}

# Main script execution
case "$1" in
  setup_dirs)
    setup_dirs "$2" "$3" "$4" || exit 1
    ;;
  nessus_log4j)
    nessus_log4j || exit 1
    ;;
  nessus_daemons)
    nessus_daemons || exit 1
    ;;
  nessus_csv)
    nessus_csv || exit 1
    ;;
  prep_nessus)
    prep_nessus || exit 1
    ;;
  prep_zap)
    prep_zap || exit 1
    ;;
  *)
    usage
    ;;
esac
