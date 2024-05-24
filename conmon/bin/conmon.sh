#!/bin/bash

# Set the root directories for Google Drive, scan results, and ConMon
GFSROOT="/Volumes/GoogleDrive/My Drive/18F_ISSO/FedRAMP JAB - cloud.gov - 3PAO Access"
SCANROOT="${GFSROOT}/ZAP and Nessus results/"
CMROOT="/Users/$(whoami)/Documents/ConMon"

# Function to print a failure message and return 1
cmfail() {
  echo "FAIL: $*"
  return 1
}

# Function to set up directories and environment variables
setup_dirs() {
  # Assign input parameters to variables
  year=$1
  [ -z "$year" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  mo=$2
  [ -z "$mo" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  dy=$3
  [ -z "$dy" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  
  # Define directory paths based on the input date
  MonthDir="$CMROOT/$year/$mo"
  ProdToolDir="$MonthDir/Production-and-Tooling-Vulnerability-and-Compliance-scans_$year-$mo-$dy"
  RDSDir="$MonthDir/RDS_Compliance_Scans_$year-$mo-$dy"
  nessus_scans="$ProdToolDir/Production Vulnerability ?can*.nessus $ProdToolDir/Tooling Vulnerability ?can*.nessus"
  
  echo "Setting up directories and environment variables"
  set -x
  # Create the necessary directories
  mkdir -p "$ProdToolDir"
  mkdir -p "$RDSDir"
  # Export environment variables
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
  for i in *\ *; do
    new=$(echo "$i" | sed -e 's/ /_/g')
    mv "$i" "$new"
  done
}

# Function to print the full Nessus report and summary
nessus_log4j() {
  printf "======\nFULL REPORT\n=====\n"
  eval parse-nessus-xml.py -l "$nessus_scans"
  printf "\n\n======\nSUMMARY FOR CONMON\n=====\n"
  eval parse-nessus-xml.py -l "$nessus_scans" | grep -E '(UNSAFE|plugin)'
}

# Function to parse Nessus daemon scans
nessus_daemons() {
  eval parse-nessus-xml.py -d "$nessus_scans"
}

# Function to generate a Nessus CSV report
nessus_csv() {
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  this="$CMROOT/$CMYEAR/$CMMO.nessus.csv"
  parse-nessus-xml.py -m 9 -c "$nessus_scans" 2>/dev/null | tail +3 > "$this"
  echo "$this ready"
}

# Function to prepare Nessus summary for the current month
prep_nessus() {
  set -x
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  this="$CMROOT/$CMYEAR/$CMMO.nessus_summary.txt"
  
  # Handle year rollover for January
  if [ "$CMMO" = "01" ]; then
    last_mo=12
    last_yr=$((CMYEAR - 1))
    last="$CMROOT/$last_yr/$last_mo.nessus_summary.txt"
  else
    # Calculate the previous month
    this_mo=$(echo "$CMMO" | sed 's/^0*//')
    last_mo=$(printf "%02d\n" $((this_mo - 1)))
    last="$CMROOT/$CMYEAR/$last_mo.nessus_summary.txt"
  fi

  # Parse the Nessus XML and generate the summary
  eval parse-nessus-xml.py -m 9 -s "$nessus_scans" |
    grep -Ev '(SUMMARY|CSV)' | grep -v '^33851,' | # 33851 is unmanaged daemons
    grep -v '^$' | gsed -e 's/\t/../' > "$this"

  # Prepare the work file with the current and previous month's data
  work="$CMROOT/$CMYEAR/$CMMO.nessus_work.txt"
  cat > "$work" <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm "$last" "$this" >> "$work"
  set +x
  echo "$work ready"
}

# Function to prepare ZAP summary for the current month
prep_zap() {
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  [ "$CMMO" = "1" ] && cmfail "not set up for year rollover"
  this="$CMROOT/$CMYEAR/$CMMO.zap_summary.txt"
  this_mo=$(echo "$CMMO" | sed 's/^0*//')
  last_mo=$(printf "%02d\n" $((this_mo - 1)))
  last="$CMROOT/$CMYEAR/$last_mo.zap_summary.txt"

  # Parse the ZAP XML and generate the summary
  parse-owasp-zap-xml.py "$MonthDir"/*-ZAP-*.xml |
    gsed 's/\t/../' | uniq > "$this"

  # Prepare the work file with the current and previous month's data
  work="$CMROOT/$CMYEAR/$CMMO.zap_work.txt"
  cat > "$work" <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm "$last" "$this" >> "$work"
  echo "$work ready"
}
