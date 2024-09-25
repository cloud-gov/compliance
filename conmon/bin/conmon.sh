#!/bin/bash

# conmon.sh

GFSROOT="/Volumes/GoogleDrive/My Drive/18F_ISSO/FedRAMP JAB - cloud.gov - 3PAO Access"
SCANROOT="${GFSROOT}/ZAP and Nessus results"
CMROOT="$HOME/Documents/ConMon"

cmfail() {
  echo "FAIL: $*"
  return 1
}

setup_dirs() {
  local year="$1"
  local mo="$2"
  local dy="$3"

  if [[ -z "$year" || -z "$mo" || -z "$dy" ]]; then
    cmfail "Call 'setup_dirs YYYY MM DD'"
    return 1
  fi

  MonthDir="$CMROOT/$year/$mo"

  # Ensure the directory exists
  mkdir -p "$MonthDir"

  echo "Directory created: $MonthDir"
  echo "Please move all Nessus scan files into this directory."

  export MonthDir
  export REMOTEROOT="$SCANROOT/${year}${mo}${dy}-ZAP-Nessus"
  export CMYEAR="$year"
  export CMMO="$mo"
  export CMDY="$dy"
}

collect_nessus_scans() {
  # Initialize nessus_scans array
  nessus_scans=()

  # Verify that MonthDir is set
  if [[ -z "$MonthDir" ]]; then
    cmfail "MonthDir is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  # Find Nessus files in MonthDir
  if [[ -d "$MonthDir" ]]; then
    while IFS= read -r -d '' file; do
      nessus_scans+=("$file")
    done < <(find "$MonthDir" -maxdepth 1 -type f -iname "*.nessus" -print0)
  else
    cmfail "MonthDir does not exist: $MonthDir"
    return 1
  fi
}

nessus_log4j() {
  collect_nessus_scans
  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo "No Nessus scan files found. Please ensure the files are in the MonthDir."
    return 1
  fi

  # Filter files for Production and Tooling scans
  local filtered_scans=()
  for file in "${nessus_scans[@]}"; do
    if [[ "$(basename "$file")" =~ ^(Production|Tooling).*\.nessus$ ]]; then
      filtered_scans+=("$file")
    fi
  done

  if [[ ${#filtered_scans[@]} -eq 0 ]]; then
    echo "No Production or Tooling Nessus scan files found."
    return 1
  fi

  printf "======\nFULL REPORT\n=====\n"
  parse-nessus-xml.py -l "${filtered_scans[@]}"
  printf "\n\n======\nSUMMARY FOR CONMON\n=====\n"
  parse-nessus-xml.py -l "${filtered_scans[@]}" | grep -E '(UNSAFE|plugin)'
}

nessus_daemons() {
  collect_nessus_scans
  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo "No Nessus scan files found. Please ensure the files are in the MonthDir."
    return 1
  fi

  # Filter files for Production and Tooling scans
  local filtered_scans=()
  for file in "${nessus_scans[@]}"; do
    if [[ "$(basename "$file")" =~ ^(Production|Tooling).*\.nessus$ ]]; then
      filtered_scans+=("$file")
    fi
  done

  if [[ ${#filtered_scans[@]} -eq 0 ]]; then
    echo "No Production or Tooling Nessus scan files found."
    return 1
  fi

  parse-nessus-xml.py -d "${filtered_scans[@]}"
}

nessus_csv() {
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  collect_nessus_scans
  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo "No Nessus scan files found. Please ensure the files are in the MonthDir."
    return 1
  fi

  # Process all Nessus scans for the CSV
  local this="$CMROOT/$CMYEAR/$CMMO.nessus.csv"
  parse-nessus-xml.py -m 9 -c "${nessus_scans[@]}" 2>/dev/null | tail -n +2 > "$this"
  echo "$this ready"
}

prep_nessus() {
  set -x
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi

  collect_nessus_scans
  if [[ ${#nessus_scans[@]} -eq 0 ]]; then
    echo "No Nessus scan files found. Please ensure the files are in the MonthDir."
    return 1
  fi

  local this="$CMROOT/$CMYEAR/$CMMO.nessus_summary.txt"
  local last
  if [[ "$CMMO" == "01" ]]; then
    local last_mo="12"
    local last_yr=$(( CMYEAR - 1 ))
    last="$CMROOT/$last_yr/$last_mo.nessus_summary.txt"
  else
    local this_mo="${CMMO#0}"
    local last_mo
    printf -v last_mo "%02d" $(( this_mo - 1 ))
    last="$CMROOT/$CMYEAR/$last_mo.nessus_summary.txt"
  fi

  # Process all Nessus scans for the summary
  parse-nessus-xml.py -m 9 -s "${nessus_scans[@]}" |
    grep -Ev '(SUMMARY|CSV)' | grep -v '^33851,' |  # 33851 is unmanaged daemons
    grep -E '.' | sed 's/\t/../' > "$this"

  local work="$CMROOT/$CMYEAR/$CMMO.nessus_work.txt"
  {
    echo "LAST MONTH (fixed)"
    echo "  THIS MONTH (new)"
    echo "    BOTH  (persisting)"
    if [[ -f "$last" ]]; then
      comm -3 "$last" "$this"
    else
      echo "No previous month's summary available."
      cat "$this"
    fi
  } > "$work"
  set +x
  echo "$work ready"
}

prep_zap() {
  if [[ -z "$CMMO" ]]; then
    cmfail "CMMO is not set. Please run setup_dirs YYYY MM DD"
    return 1
  fi
  if [[ "$CMMO" == "01" ]]; then
    cmfail "Year rollover not yet implemented"
    return 1
  fi
  local this="$CMROOT/$CMYEAR/$CMMO.zap_summary.txt"
  local this_mo="${CMMO#0}"
  local last_mo
  printf -v last_mo "%02d" $(( this_mo - 1 ))
  local last="$CMROOT/$CMYEAR/$last_mo.zap_summary.txt"

  parse-owasp-zap-xml.py "$MonthDir"/*-ZAP-*.xml |
    sed 's/\t/../' | uniq > "$this"

  local work="$CMROOT/$CMYEAR/$CMMO.zap_work.txt"
  {
    echo "LAST MONTH (fixed)"
    echo "  THIS MONTH (new)"
    echo "    BOTH  (persisting)"
    if [[ -f "$last" ]]; then
      comm -3 "$last" "$this"
    else
      echo "No previous month's summary available."
      cat "$this"
    fi
  } > "$work"
  echo "$work ready"
}
