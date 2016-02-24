# Confidential Survey

This System Security plan provides an overview of the security requirements for Confidential Survey, a hosted service for securely conducting surveys for sensitive topics without recording personally identifiable information (PII) about the survey participants. The Survey tool is implemented as a Ruby on Rails application running on the Cloud.gov platform. This document describes the system system and TK information for the condidential survey application.

The security safeguards implemented for the Confidential Survey system meet the policy and control requirements set forth in this System Security Plan.  All systems are subject to monitoring consistent with applicable laws, regulations, agency policies, procedures and practices.

Unique Identifier | Information System Name | Information System Abbreviation
--- | --- | ---
Confidential Survey | 18F Confidential Survey tool | Survey

# System Categorization
The overall information system sensitivity categorization is noted in the table that follows.

Low | Moderate | High
--- | --- | ---
X | |

# Security Objectives Categorization
Security Objective | Open Data
--- | --- | ---
Confidentiality | N/A
Integrity | Low
Availability | Low

Using this categorization, in conjunction with the risk assessment and any unique security requirements, we have established the security controls for this system, as detailed in this SSP.

# General System Description

## System Function or Purpose

### Information System Components and Boundaries

## Types of Users

#### Administrator
Internal, Low sensitivity

Creates and uploads new surveys to the production server

#### Survey User
Public, Low survey

Fills out surveys when provided with a link to the form

## Network Architecture

The following diagram provides an overview of the survey application's network architecture

![Survey System Architecture](/system_documentation/confidential-survey-system-architecture.png)

## Hardware Inventory
Leveraged from AWS - None

## Software Inventory

### Survey Application
Ruby on Rails

Postgres SQL server

## Network Inventory
Leveraged from AWS - None

## Ports, Protocols and Services
Ports (TCP/UDP) |	Protocols |	Services |	Purpose |	Used By
--- | --- | --- | ---
443/TCP |	HTTPS |	HTTPS Web Service |	Survey Application running on Cloud.gov	 |

## User Data Flow

![Survey System Architecture](/system_documentation/confidential-survey-data-flow.png)

### Taking a Survey
To take a survey, a user must first enter some basic HTTP Authentication credentials (these are shared across all users and would not identify a single user). The credentials are just there to limit access to 18F employees and/or potential hires. The user would also need to know the exact URL of the survey they are invited to take (there is no root-level directory of surveys).

Once the user submits a survey, the complete response is used only to increment counters for various fields and a full record of the survey is not retained. The user is redirected to a screen thanking them for their participation.

### Survey Creation
Surveys are implemented as YAML configuration files within the `config/surveys` directory of the application (here is [a sample survey included in the repo](https://github.com/18F/confidential-survey/blob/develop/config/surveys/sample-survey.yml)). Surveys do not need to be – and probably *should not* be – checked into the repo.

1. To make a new survey live, the app (with survey file in its `config/surveys`) must be deployed to production. This limits the ability to create/edit surveys on the system only to the lead developer or anybody else with deploy access to the specific space. If the survey is named `SURVEY_NAME.yml`, the new survey form is accessible at `/surveys/SURVEY_NAME`
2. To mark a live survey as `inactive` – meaning that it no longer accepts responses – the developer has to edit a field in the survey's YAML configuration to be `active: false` and redeploy the survey.
3. To delete the survey form entirely, the developer can delete the survey's YAML file and redeploy. This will not remove the counts recorded for the survey from the database.

### JSON Data
To allow admin users to retrieve the count, the system also supports a JSON endpoint for each survey at `/surveys/SURVEY_NAME.json`. This is secured with a different HTTP Authentication password than the one used by survey takers that should only be used by personnel and scripts authorized to download the JSON.

While it is the goal to eventually make the JSON for each survey public, this should not be done by copying the JSON to a static file (perhaps on S3) rather than serving it directly from the application
