# README

## Continuous Monitoring Tooling - `conmon.sh`

The `conmon.sh` script is a versatile tool used for setting up directories and environment variables for continuous monitoring (ConMon) tasks, renaming files to replace spaces with underscores, and processing Nessus and ZAP scan results.

### Usage

To use the functions provided by `conmon.sh`, you need to source the script in your shell session. Here are the steps to do so:

1. **Source the Script**:
   ```bash
   source conmon.sh
   ```
2. **Call the Functions:**

- After sourcing the script, you can call the functions defined within it. Below are the available functions and their usage:

      - setup_dirs YYYY MM DD:

    - Sets up directories and environment variables based on the provided year, month, and day. 
        ```bash
        setup_dirs 2024 05 24
        ```

- spaces2underscore:
  - Replaces spaces with underscores in filenames within the current directory.

    ```bash
    spaces2underscore
    ```

- nessus_log4j:
  - Processes Nessus scan results specifically for Log4j vulnerabilities and prints a full report and summary.

    ```bash
    nessus_log4j
    ```

- nessus_daemons:
  - Processes Nessus scan results for daemon-related vulnerabilities.

    ```bash
    nessus_daemons
    ```

- nessus_csv:
  - Generates a CSV report from Nessus scan results.

    ```bash
    nessus_csv
    ```

- prep_nessus:
  - Prepares Nessus scan summaries and compares the results with the previous month.

    ```bash
    prep_nessus
    ```

- prep_zap:
  - Prepares ZAP scan summaries and compares the results with the previous month.

    ```bash
    prep_zap
    ```

## Example Workflow

Here is an example workflow that demonstrates how to use the script:

```bash
# Source the script
source conmon.sh

# Set up directories for May 24, 2024
setup_dirs 2024 05 24

# Replace spaces with underscores in filenames
spaces2underscore

# Process Nessus scan results for Log4j vulnerabilities
nessus_log4j

# Prepare Nessus scan summaries
prep_nessus

# Prepare ZAP scan summaries
prep_zap
```

By following these steps, you can efficiently manage your continuous monitoring tasks using the conmon.sh script.
