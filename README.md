# cloud.gov Compliance

Compliance documentation and automation.

## Continuous Monitoring Tooling

Some shortcuts/tools for our monthly ConMon (Continuous Monitoring) are in the `./ConMon` directory. These tools help automate various tasks related to compliance and vulnerability scanning.

### Scripts Overview

#### `conmon.sh`

This script is used for setting up directories and environment variables for continuous monitoring (ConMon) tasks, renaming files to replace spaces with underscores, and processing Nessus and ZAP scan results.

**Functions:**

- `setup_dirs YYYY MM DD`: Sets up directories and environment variables based on the provided year, month, and day.
- `spaces2underscore`: Replaces spaces with underscores in filenames within the current directory.
- `nessus_log4j`: Processes Nessus scan results specifically for Log4j vulnerabilities and prints a full report and summary.
- `nessus_daemons`: Processes Nessus scan results for daemon-related vulnerabilities.
- `nessus_csv`: Generates a CSV report from Nessus scan results.
- `prep_nessus`: Prepares Nessus scan summaries and compares the results with the previous month.
- `prep_zap`: Prepares ZAP scan summaries and compares the results with the previous month.

To use the functions, source the script and call the functions as needed:

```bash
source conmon.sh
setup_dirs 2024 05 24
spaces2underscore
nessus_log4j
# etc.
```

## usn2cve.sh

This script fetches CVE details for a given USN (Ubuntu Security Notice). It retrieves the CVEs from the USN page on the Ubuntu website and then fetches detailed information for each CVE from the NVD (National Vulnerability Database) API.

Usage:

```bash
./usn2cve.sh USN-XXXX-XX
```

The script will log the process and any errors, and it will print the CVE details for each CVE found in the specified USN.

Example Usage
To process a USN and fetch CVE details:

```bash
source usn2cve.sh
./usn2cve.sh USN-1234-1
```

## Audit

See the Audit directory README for guidance on running automated audits.
