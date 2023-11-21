# SSP control cross check

This document compares cloud.gov's controls to those of other
FedRAMP-authorized providers. I have taken care to ensure the 
controls are not linked to particular provider, nor that the
cloud.gov controls reveal anything that is not obvious, nor already
open-source

The controls reviewed are in order of their "protection value", 
per [FedRAMP®/Mitre
analysis](https://www.fedramp.gov/2022-02-15-threat-based-methodology-update/):

The top-scoring protection value controls are:

| Control Number |	Control Name	| Protection Value |
| -------- | -------------------------------------------------------- | ------ |
| CM-6     | CONFIGURATION SETTINGS                                   | 208.86 |
| AU-6     | AUDIT RECORD REVIEW, ANALYSIS, AND REPORTING             | 206.65 |
| AU-6(1)  | AUTOMATED PROCESS INTEGRATION                            | 206.65 |
| AU-6(3)  | CORRELATE AUDIT RECORD REPOSITORIES                      | 206.65 |
| AU-6(4)  | CENTRAL REVIEW AND ANALYSIS                              | 206.65 |
| AU-6(5)  | INTEGRATED ANALYSIS OF AUDIT RECORDS                     | 206.65 |
| AU-6(6)  | CORRELATION WITH PHYSICAL MONITORING                     | 206.65 |
| CM-6(1)  | AUTOMATED MANAGEMENT, APPLICATION, AND VERIFICATION      | 178.09 |
| CM-6(2)  | RESPOND TO UNAUTHORIZED CHANGES                          | 178.09 |
| IA-2     | IDENTIFICATION AND AUTHENTICATION (ORGANIZATIONAL USERS) | 147.85 |
| IA-2(1)  | MULTI-FACTOR AUTHENTICATION TO PRIVILEGED ACCOUNTS       | 147.85 |
| IA-2(12) | ACCEPTANCE OF PIV CREDENTIALS                            | 147.85 |
| IA-2(2)  | MULTI-FACTOR AUTHENTICATION TO NON-PRIVILEGED ACCOUNTS   | 147.85 |
| IA-2(5)  | INDIVIDUAL AUTHENTICATION WITH GROUP AUTHENTICATION      | 147.85 |
| IA-2(6)  | ACCESS TO ACCOUNTS — SEPARATE DEVICE                     | 147.85 |
| IA-2(8)  | ACCESS TO ACCOUNTS — REPLAY RESISTANT                    | 147.85 |
| SI-3     | MALICIOUS CODE PROTECTION                                | 147.59 |
| CM-7     | LEAST FUNCTIONALITY                                      | 146.57 |
| CM-7(1)  | PERIODIC REVIEW                                          | 146.57 |
| CM-7(2)  | PREVENT PROGRAM EXECUTION                                | 146.57 |
| SI-4(23) | HOST-BASED DEVICES                                       | 134.91 |
| AC-2(11) | USAGE CONDITIONS                                         | 125.02 |
| SC-7(5)  | DENY BY DEFAULT — ALLOW BY EXCEPTION                     | 120.44 |
| SI-4(1)  | SYSTEM-WIDE INTRUSION DETECTION SYSTEM                   | 111.73 |
| SI-4(16) | CORRELATE MONITORING INFORMATION                         | 111.73 |
| SI-4(2)  | AUTOMATED TOOLS AND MECHANISMS FOR REAL-TIME ANALYSIS    | 111.73 |
| SI-7     | SOFTWARE, FIRMWARE, AND INFORMATION INTEGRITY            | 104.29 |
| SI-7(1)  | INTEGRITY CHECKS                                         | 104.29 |


## CM-6

### cloud.gov

Part a:

Follow AWS security best practices, esp wrt to IAM, and AWS security pubs

Use CIS L1 for Ubuntu, use our fisma-ready GitHub project. When no applicable
benchmark, use "most restrictive". See cg-provision.

Part b:

See cg-provision and our CM guide. We use buildpacks and official Docker
images (Pages). 

Part c:

We don't allow exceptions, changes go through CM process.  When CM is not in
line with FR, we document ORs

Part d: 

We use our PR process and changes are limited to GitHub hashed changes. 



