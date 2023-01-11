
GFSROOT=/Volumes/GoogleDrive/My\ Drive/18F_ISSO/FedRAMP\ JAB\ -\ cloud.gov\ -\ 3PAO\ Access
SCANROOT=${GFSROOT}/ZAP\ and\ Nessus\ results/
CMROOT=/Users/peterdburkholder/Documents/ConMon

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
  echo mkdir -p \""$ProdToolDir\""
  echo mkdir -p \""$RDSDir\""
  echo "export MonthDir=\""$MonthDir\"""
  echo "export ProdToolDir=\""$ProdToolDir\"""
  echo "export REMOTEROOT=\""$SCANROOT/${year}${mo}${dy}-ZAP-Nessus\"""
  echo "export CMYEAR=$year"
  echo "export CMMO=$mo"
  echo "export CMDY=$dy"
}

nessus_log4j() {
  parse-nessus-xml.py -l $nessus_scans
}

nessus_daemons() {
  parse-nessus-xml.py -d $nessus_scans
}

prep_nessus() {
  set -x
  [ -z "$CMMO" ] && cmfail "need to set CMMO"
  this=$CMROOT/$CMYEAR/$CMMO.nessus_summary
  if [ "$CMMO" == 01 ]; then
    last_mo=12
    last_yr=$(( $CMYEAR - 1 ))
    last=$CMROOT/$last_yr/$last_mo.nessus_summary
  else
    this_mo=$(echo $CMMO | sed 's/^0*//')
    last_mo=$(printf "%02d\n" $(( $this_mo - 1 ))) #
    last=$CMROOT/$CMYEAR/$last_mo.nessus_summary
  fi

  parse-nessus-xml.py -s $nessus_scans -m 1 |
      grep -Ev '(SUMMARY|CSV)' |  grep -v '^33851,' | # 33851 is unmanaged daemons
      grep -v '^$' | gsed -e 's/\t/../' > $this

  cat > $CMROOT/$CMYEAR/$CMMO.nessus_work <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm $last $this >> $CMROOT/$CMYEAR/$CMMO.nessus_work
  set +x
  echo "$CMMO.nessus_work ready"
}

prep_zap() {
  [ -z "$CMMO" ] && fail "need to set CMMO"
  [ "$CMMO" == 1 ] && fail "not set up for year rollover"
  this=$CMROOT/$CMYEAR/$CMMO.zap_summary
  this_mo=$(echo $CMMO | sed 's/^0*//')
  last_mo=$(printf "%02d\n" $(( $this_mo - 1 ))) 
  last=$CMROOT/$CMYEAR/$last_mo.zap_summary

  parse-owasp-zap-xml.py $MonthDir/*-ZAP-*.xml | 
    gsed 's/\t/../' > $this

  cat > $CMROOT/$CMYEAR/$CMMO.zap_work <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm $last $this >> $CMROOT/$CMYEAR/$CMMO.zap_work
  echo "$CMMO.zap_work ready"
}
