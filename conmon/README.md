# Welcome to monthly conmon

- You'll need Google File Stream working. If it's hung up, it's worked for me to:
  - Delete the cache in ~/Library/Application\ Support/Google/DriveFS
  - Reinstall GFS from GSA SelfService
- `git clone file:///Volumes/GoogleDrive/My Drive/cloud.gov/Security and Compliance/Compliance/conmon_project.git
- You'll need the parse-nessus and owasp python scripts.
- 
- Ensure the Google Drive has the appropriate and appropriately named Nessus and Zap scans.  The folder should be named YYYYMMDD-ZAP-Nessus and the Zap files therein YYYYMMDD-ZAP.(xml,html)
- Create the local directory stucture:
  - cd to this directory
  - `source conmon.sh`
  - `setup_dirs MM DD` where MM DD is the date the scans were run.
  - Review the output, then copy and paste to execute
- Populate the directories with `populate_dirs`
  - If you need to override a date, use `CMDY=29 populate_dirs` or such.
  - **This is fragile** -- better to use Google Filestream and Finder to Option-Drag the files over
- Generate the Nessus summary and comparision: `prep_nessus`
  - This gets really screwed up if new vulns with low ID numbers show up. Move them to the end (see 11 and 12, 2020)
  - Go through the `XX.nessus_work` and delete each line (Fixed, New, or Existing) as you account for them in the POAM tracker

TODO: Explore using Heimdall to track the Nessus and OWASP output each month.

BESURE TO INCLUDE ALL THE RDS STUFF

THIS GOES SO LATE I FORGET TO DOCUMENT ALL THE ZAP STUFF







# NESSUS vulnerabilities

``` sh
parse-nessus-xml.py 09/Production_Vulnerability_scan_wtt5ji.nessus | 
  awk '/SUMMARY/,/CSV/' | 
  grep -Ev '(SUMMARY|CSV)' | grep -v '^$' | gsed -e 's/\t/../' 
```

Now it looks like:

``` text
33851, Risk: Low, Plugin Name: Network daemons not managed by the package system, https://www.tenable.com/plugins/nessus/33851
..168 affected hosts found ...
133800, Risk: Medium, Plugin Name: Ubuntu 16.04 LTS / 18.04 LTS : linux, linux-aws, linux-aws-hwe, linux-azure, linux-gcp, linux-gke-4.15, (USN-4287-1), https://www.tenable.com/plugins/nessus/133800
..48 affected hosts found ...
```

The compare LAST month to THIS month:

``` sh
comm 07.nessus_summary 08.nessus_summary > 08.nessus_work
```

Add headers

``` text
LAST MONTH (fixed)
  THIS MONTH (new)
    BOTH  (persisting)
```

Commit the summary to Git, not the work file

# OWASP

``` sh
parse-owasp-zap-xml.py 09/20200921-ZAP.xml  | gsed 's/\t/../' > 09.zap_summary
````


# AWS Vendor Dependencies

Minor version:
```
aws-vault exec cg-govcloud -- aws rds describe-db-engine-versions --output=table --engine postgres --engine-version 9.6.1
```

E.g:

run `aws rds describe-db-engine-versions --output=table --engine postgres --engine-version 9.6.1`
get a description of all the 9.6.X pg versions, you’ll
see that 9.6.11 is the only one with “AutoUpgrade: true” - so only versions
below 9.6.11 are autoupgraded to 9.6.11.

# Send email to Marcus on monthly basis

```
Hi Marcus,

It seems we have 4 findings on our RDS compliance scans that are dependencies on you folks. Any word on addressing these issues?

Thanks, Peter


* SSL Medium Strength Cipher Suites Supported
  Medium Strength Ciphers (> 64-bit and < 112-bit key, or 3DES)

    Name                          Code             KEX           Auth     Encryption             MAC
    ----------------------        ----------       ---           ----     ---------------------  ---
    EDH-RSA-DES-CBC3-SHA          0x00, 0x16       DH            RSA      3DES-CBC(168)          SHA1
    ECDHE-RSA-DES-CBC3-SHA        0xC0, 0x12       ECDH          RSA      3DES-CBC(168)          SHA1
    DES-CBC3-SHA                  0x00, 0x0A       RSA           RSA      3DES-CBC(168)          SHA1


* SSL Certificate Chain Contains RSA Keys Less Than 2048 bits

The following certificates were part of the certificate chain
sent by the remote host, but contain RSA keys that are considered
to be weak :

|-Subject        : CN=... [redacted] ... OU=RDS/O=Amazon.com/L=Seattle/ST=Washington/C=US
|-RSA Key Length : 1024 bits

* TLS Version 1.0 Protocol Detection
- Any update on disabling TLS v1.0? v1.1 seems to be gone from our scans

* PostgreSQL 9.5.x < 9.5.23 / 9.6.x < 9.6.19 / 10.x < 10.14 / 11.x < 11.9 / 12.x < 12.4 Multiple Vulnerabilities
-- The current AMVU version is still pinned at 9.6.18. Please bump that to 9.6.19
```

# For UAA java versions

-- Check if it's patched at
https://github.com/cloudfoundry/uaa-release/blob/develop/config/blobs.yml or
open an issue in that repo.

* Shibboleth?
* 
## Git and Drive and this project

```
conmon-git-project on  master on ☁️  us-east-2
❯ git remote -v
origin	/Users/peterdburkholder/Documents/ConMon (fetch)
origin	/Users/peterdburkholder/Documents/ConMon (push)

conmon-git-project on  master [?] on ☁️  us-east-2
❯ p
~/Documents/ConMon /Volumes/GoogleDrive/My Drive/cloud.gov/Security and Compliance/Compliance/conmon-git-project

ConMon on  master on ☁️  us-east-2
```
