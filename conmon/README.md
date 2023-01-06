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


## For UAA java versions

-- Check if it's patched at
https://github.com/cloudfoundry/uaa-release/blob/develop/config/blobs.yml or
open an issue in that repo.

* Shibboleth?
 
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
