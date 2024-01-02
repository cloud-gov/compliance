
GFSROOT=/Volumes/GoogleDrive/My\ Drive/18F_ISSO/FedRAMP\ JAB\ -\ cloud.gov\ -\ 3PAO\ Access
SCANROOT=${GFSROOT}/ZAP\ and\ Nessus\ results/
CMROOT=/Users/$(whoami)/Documents/ConMon

cmfail() {
  echo "FAIL: $*"
  return 1
}

setup_dirs() {
  year=$1
  [ -z "$year" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  mo=$2
  [ -z "$mo" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  dy=$3
  [ -z "$dy" ] && cmfail "Call 'setup_dirs YYYY MM DD'"
  MonthDir="$CMROOT/$year/$mo"
  ProdToolDir=$MonthDir/Production-and-Tooling-Vulnerability-and-Compliance-scans_$year-$mo-$dy
  RDSDir=$MonthDir/RDS_Compliance_Scans_$year-$mo-$dy
  nessus_scans="$ProdToolDir/Production_Vulnerability_?can*.nessus $ProdToolDir/Tooling_Vulnerability_?can*.nessus"
  echo "Setting up directories and env vars"
  set -x
  mkdir -p "$ProdToolDir"
  mkdir -p "$RDSDir"
  export MonthDir="$MonthDir"
  export ProdToolDir="$ProdToolDir"
  export REMOTEROOT="$SCANROOT/${year}${mo}${dy}-ZAP-Nessus"
  export CMYEAR=$year
  export CMMO=$mo
  export CMDY=$dy
  set +x
}

spaces2underscore () {
    for i in *\ *;
    do
        new=$(echo $i | sed -e 's/ /_/g');
        mv "$i" $new;
    done
}

nessus_log4j() {
  parse-nessus-xml.py -l $nessus_scans
}

nessus_daemons() {
  parse-nessus-xml.py -d $nessus_scans
}

nessus_csv() {
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  this=$CMROOT/$CMYEAR/$CMMO.nessus.csv
  parse-nessus-xml.py -m 9 -c $nessus_scans 2>/dev/null | tail +3 > $this
  echo "$this ready"
}

prep_nessus() {
  set -x
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  this=$CMROOT/$CMYEAR/$CMMO.nessus_summary.txt
  if [ "$CMMO" == 01 ]; then
    last_mo=12
    last_yr=$(( $CMYEAR - 1 ))
    last=$CMROOT/$last_yr/$last_mo.nessus_summary.txt
  else
    this_mo=$(echo $CMMO | sed 's/^0*//')
    last_mo=$(printf "%02d\n" $(( $this_mo - 1 ))) #
    last=$CMROOT/$CMYEAR/$last_mo.nessus_summary.txt
  fi

  parse-nessus-xml.py -m 9 -s $nessus_scans |
      grep -Ev '(SUMMARY|CSV)' |  grep -v '^33851,' | # 33851 is unmanaged daemons
      grep -v '^$' | gsed -e 's/\t/../' > $this

  work="$CMROOT/$CMYEAR/$CMMO.nessus_work.txt"
  cat > $work <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm $last $this >> $work
  set +x
  echo "$work ready"
}

prep_zap() {
  [ -z "$CMMO" ] && fail "need to set CMMO"
  [ "$CMMO" == 1 ] && fail "not set up for year rollover"
  this=$CMROOT/$CMYEAR/$CMMO.zap_summary.txt
  this_mo=$(echo $CMMO | sed 's/^0*//')
  last_mo=$(printf "%02d\n" $(( $this_mo - 1 ))) 
  last=$CMROOT/$CMYEAR/$last_mo.zap_summary.txt

  parse-owasp-zap-xml.py $MonthDir/*-ZAP-*.xml | 
    gsed 's/\t/../' | uniq > $this

  work="$CMROOT/$CMYEAR/$CMMO.zap_work.txt"
  cat > $work <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm $last $this >> $work
  echo "$work ready"
}
