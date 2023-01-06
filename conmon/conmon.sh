
GFSROOT=/Volumes/GoogleDrive/My\ Drive/18F_ISSO/FedRAMP\ JAB\ -\ cloud.gov\ -\ 3PAO\ Access
SCANROOT=${GFSROOT}/ZAP\ and\ Nessus\ results/
CMROOT=/Users/peterdburkholder/Documents/ConMon

cmfail() {
  echo "FAIL: $*"
  return 1
}

setup_dirs() {
  year=$(date +%Y)
  mo=$1
  [ -z "$mo" ] && cmfail "Call 'setup_dirs MM DD'"
  dy=$2
  [ -z "$dy" ] && cmfail "Call 'setup_dirs MM DD'"
  MonthDir="$CMROOT/$year/$mo"
  ProdToolDir=$MonthDir/Production-and-Tooling-Vulnerability-and-Compliance-scans_$year-$mo-$dy
  RDSDir=$MonthDir/RDS_Compliance_Scans_$year-$mo-$dy
  echo mkdir -p \""$ProdToolDir\""
  echo mkdir -p \""$RDSDir\""
  echo "export MonthDir=\""$MonthDir\"""
  echo "export ProdToolDir=\""$ProdToolDir\"""
  echo "export REMOTEROOT=\""$SCANROOT/${year}${mo}${dy}-ZAP-Nessus\"""
  echo "export CMYEAR=$year"
  echo "export CMMO=$mo"
  echo "export CMDY=$dy"
}

populate_dirs() {
  [ -z "$ProdToolDir" ] && cmfail "Run 'setup_dirs' first and export vars"
  [ -d "$REMOTEROOT" ] && echo OK
  set -x
  cp "$REMOTEROOT/${CMYEAR}${CMMO}${CMDY}-??ternal.html" "$MonthDir" || return
  cp "$REMOTEROOT/${CMYEAR}${CMMO}${CMDY}-??ternal.xml" "$MonthDir" || return
  cp "${REMOTEROOT}"/Prod*nessus "$ProdToolDir/" || return
  cp "${REMOTEROOT}"/Tool*nessus "$ProdToolDir/" || return
  cp "${REMOTEROOT}"/RDS*nessus "$RDSDir/" || return
  set +x
}


prep_nessus() {
  set -x
  [ -z "$CMMO" ] && fail "need to set CMMO"
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

  #parse-nessus-xml.py $ProdToolDir/Production_Vulnerability_?can*.nessus |
  #$ProdToolDir/Production_Vulnerability_?can*.nessus |
  parse-nessus-xml.py $ProdToolDir/Production_Vulnerability_?can*.nessus $ProdToolDir/Tooling_Vulnerability_?can*.nessus |
      awk '/SUMMARY/,/CSV/' | grep -Ev '(SUMMARY|CSV)' |
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

# once the work file is down to only the new findings...
emit_nessus_csv() {
  parse-nessus-xml.py $ProdToolDir/Production_Vulnerability_scan*.nessus |
      awk '/CSV/,0' | grep -Ev '(SUMMARY|CSV)' 
}

prep_zap() {
  [ -z "$CMMO" ] && fail "need to set CMMO"
  [ "$CMMO" == 1 ] && fail "not set up for year rollover"
  this=$CMROOT/$CMYEAR/$CMMO.zap_summary
  this_mo=$(echo $CMMO | sed 's/^0*//')
  last_mo=$(printf "%02d\n" $(( $this_mo - 1 ))) 
  last=$CMROOT/$CMYEAR/$last_mo.zap_summary

  parse-owasp-zap-xml.py $MonthDir/$CMYEAR$CMMO$CMDY-ZAP-*.xml | 
    gsed 's/\t/../' > $this

  cat > $CMROOT/$CMYEAR/$CMMO.zap_work <<END
LAST MONTH (fixed)
	THIS MONTH (new)
		BOTH  (persisting)
END
  comm $last $this >> $CMROOT/$CMYEAR/$CMMO.zap_work
  echo "$CMMO.zap_work ready"
}

prep_upload() {
  [ -r ~/Downloads/"FedRAMP-Inventory-cloud.gov - Inventory.xlsx" ] || fail Download Inventory
  [ -r ~/Downloads/"FedRAMP-POAM-cloud.gov - ConMon POAM.xlsx" ] || fail Download Inventory
  today=$(date +%Y-%m-%d)
  then="2020-12-23"
  MonthDir="$HOME/Documents/ConMon/2020/12"

  CMYEAR=2020
  CMMO=12
  CMDY=23
  poam_name="FedRAMP-POAM-cloud.gov - ConMon POAM ${today}.xlsx"
  inventory_name="FedRAMP-Inventory-cloud.gov - Inventory ${then}.xlsx"
  set -x
  mv "$HOME/Downloads/FedRAMP-Inventory-cloud.gov - Inventory.xlsx" "$MonthDir/$inventory_name"
  mv "$HOME/Downloads/FedRAMP-POAM-cloud.gov - ConMon POAM.xlsx" "$MonthDir/$poam_name"
  zip -r $MonthDir/Production-and-Tooling-Vulnerability-and-Compliance-scans_$then.zip $ProdToolDir
  cp $MonthDir/*ZAP.xml $MonthDir/cloud.gov_OWASP_ZAP_Scan_2020-12-28.xml
  return
  set +x
  pushd $MonthDir
  echo; echo;
  ls *POAM*
  ls *Inventory*
  ls *zip
  echo -n \"
  ls -1 RDS*nessus
  echo -n \"; echo

  ls cloud*xml

  echo; echo
  popd


}

data() {
FedRAMP-POAM-cloud.gov - ConMon POAM 2020-11-02.xlsx
FedRAMP-Inventory-cloud.gov - Inventory 2020-10-25.xlsx
Production and Tooling Vulnerability and Compliance Scans - 2020-10-25.zip
"RDS_Compliance_Scan_Bosh_Prod_cpczu5.nessus
RDS_Compliance_Scan_CF_Prod_buyfv1.nessus"
cloud.gov_OWASP_ZAP_Scan-2020-10-25
}
