# General System Description

## System Function or Purpose
Cloud.Gov is 18F’s product line for the tools, tech, and services 18F provides to help teams delivering federal digital services to operate efficiently at-scale in a cloud-hosted environment, while complying with federal regulatory requirements. It’s based on and built using the open source Cloud Foundry project, which is an open platform as a service, providing a choice of developer frameworks, and application services which makes it faster and easier to build, test, deploy, and scale applications.

## Information System Components and Boundaries
18F has created a specific set of VPCs (Live production and staging) for its Cloud.Gov implementation. All VPCs have subnets used to separate and control IP address space within each individual VPC. Subnets must be created in order to launch Availability Zone (AZ) specific services within a VPC. 18F has setup VPC Peering between the Staging VPC and the CF Live production VPC.

The Cloud.Gov PaaS Information System is hosted within the AWS East Public Cloud in the Northern Virginia Region. AWS services utilized include ENI, EC2, EBS, VPC, RDS, S3, MFA, Route 53 and IAM. These are listed as leveraged hardware, network and server components.

Physical aspects of the Cloud.Gov PasS information system are outside of the accreditation boundary due to all hardware being physically managed by the AWS. While other services are reviewed and approved for use by the GSA OCISO as they were deemed to be ancillary support services that do not directly process/store data but rather provide general support services. These services include Cloudwatch, Cloudtrail, AWS Config and Trusted Advisor.

## Network Architecture
The following architectural diagram(s) provides a visual depiction of the system network components that constitute Cloud.Gov.

## Security Tools Stack
### Identification and Authentication Control

18F utilizes multi-factor authentication for the following services IAM, GitHub, Trello and Slack. Access to these services requires multi-factor authentication using both the login and the MFA device.  When a user signs into the these services they are prompted for an authentication code from their MFA device.  Once the user has entered their username and password along with their authentication code they will then be granted access.

### Audit Logging, Monitoring and intrusion detection

Cloud.Gov utilizes the ELK Stack for centralized audit logging and monitoring of Cloud.Gov components, applications, and data APIs. The logs captured from the ELK stack can be used in forensic analysis to track down the time of intrusion, as well as the method used to penetrate into the network. It’s can used in a way to monitor attacker activities in the network and help determine the reason behind an attack.

The ELK stack includes Logstash, a centralized logging and parsing data pipeline that is used to process logs in different formats. Logstash uses different rules to format each log message into multiple fields, which are indexed by the Elasticsearch search engine used for deep searches and data analytics. Kibana is a web interface that provides an overview of the collected data, so 18F can easily view and analyze the collected logs. With the Grafana add on, 18F has a centralized dashboard for all events and metrics being monitored within its environment.

Suricata is a high performance Network IDS, IPS and Network Security Monitoring engine. It implements a complete signature language to match on known threats, policy violations and malicious behaviour. It detects many anomalies in the traffic it inspects  and is capable of using the specialized Emerging Threats Suricata ruleset and the VRT ruleset. It uses JSON events and alert output which allows for easy integration with Logstash.

Cloud.Gov utilizes AWS Cloudtrail, Cloudwatch and CloudCheckr for all audit and logging and monitoring of its virtual cloud Infrastructure and components.  

18F has implemented CloudTrail for its account monitoring. It provides visibility into user activity by recording API calls made on an AWS account. CloudTrail records important information about each API call, including the name of the API, the identity of the caller, the time of the API call, the request parameters, and the response elements returned by the AWS service. This information helps 18F track changes made to its AWS resources and to troubleshoot operational issues.  

18F has implemented CloudWatch for its resource monitoring. It allows 18F to monitor AWS resources in near real-time, including Amazon EC2 instances, Amazon EBS volumes, Elastic Load Balancers, and Amazon RDS DB instances. Metrics such as CPU utilization, latency, and request counts are provided automatically for these AWS resources. It allows 18F to supply logs or custom application and system metrics, such as memory usage, transaction volumes, or error rates.

### Vulnerability Scanning, Penetration testing

18F utilizes Nexpose for vulnerability scanning and asset management of its network environment. 18F conducts baseline configurations scans, compliance scans, virtual infrastructure and network scans using custom scan policies and templates. It runs both authenticated/unauthenticated scans against 18F assets and provides reporting and grouping functions of vulnerabilities with scanned assets. Nexpose allows 18F to track risk level changes based on remediation efforts and provides a variety of scan report outputs.

When used in combination with Metasploit Pro, Nexpose reports 18F assets vulnerable to common exploits and presents the option to automated penetration testing through Metasploit Pro using the metasploitable module. Metasploit is a penetration testing platform designed to exploit and validate vulnerabilities found within 18F’s Virtual private cloud and applications.
18F utilizes OWASP ZAP for internal web application scanning and penetration testing of internal information systems and components. It’s used to scan for the OWASP Top 10 vulnerabilities within applications and it can perform both automated and manual penetration testing functions.   

### Cloud Inventory and Asset Management

18F utilizes VisualOps Cloud management to provide a visual, real-time representation of 18F’s virtual cloud infrastructure. It also provides a global view of the 18F AWS account where all regions and services can be seen in one place.                    

CloudCheckr is used by 18F to facilitate asset management, along with other operations activities, on a real-time ongoing basis. Components deployed in the 18F AWS virtual Private Cloud and Cloud.Gov are accurately inventoried within Cloud Checkr. Cloud Checkr has the capability to filter only those components that are related to the Cloud.Gov system inventory.  

AWS Config can export a complete inventory of AWS resources with all configuration details, determine how a resource was configured at any point in time, and get notified via Amazon SNS when the configuration of a resource changes. AWS Config can provide configuration snapshots, which is a point-in-time capture of all 18F resources and their configurations. Configuration snapshots are generated on demand via the AWS CLI, or API, and delivered to an Amazon S3 bucket that is specified.

### Static and Dynamic Code Analysis

Code Analysis for Cloud.Gov is performed by Code Climate.  18F utilizes Code Climate as an automated static code analysis tool for its applications on Cloud.Gov. It Integrates directly into 18F's continuous integration (CI) workflow and provides notifications of actionable findings in GitHub, and Slack when an issue arises. 18F uses a variety of other analyzers based on the type of codebase used.

OWASP Zap is used as an dynamic code analysis tool. It has the capability to dynamically probe web applications looking for unknown vulnerabilities found in the source code of applications.  

### Incident Response Resolution and Communication

18F utilizes PagerDuty for Incident response and communication. It integrates with 18Fs entire monitoring and deployment stack which includes Slack, Cloudwatch, New Relic and ELK with real-time alerts and visibility into critical systems and applications. It allows the DevOps team to quickly detect, triage, and resolve incidents from development through production.

The SecOps team can view centralized alerts from ELK and CloudCheckr for 18F’s visibility of the entire application stack and virtual infrastructure which enables the team to prioritize, escalate and execute the incident response process.

### Configuration Management and Version Control

18F’s configuration management process consists of GitHub  and Concourse for Cloud.Gov. Baselines and configuration files are stored in Github repositories using version control. These files are then deployed using a pipeline yaml file within the Concourse continuous integration platform.  Concourse does not allow any configuration to enter the server that cannot be easily saved away in version control.  Builds run inside their own containers so that installing packages on the build machine doesn't pollute other builds.

AWS Config can export a complete inventory of AWS resources with all configuration details, determine how a resource was configured at any point in time, and get notified via Amazon SNS when the configuration of a resource changes. AWS Config can provide configuration snapshots, which is a point-in-time capture of all 18F resources and their configurations. Configuration snapshots are generated on demand via the AWS CLI, or API, and delivered to an S3 bucket that is specified.

# System Environment
The following describes the Cloud.Gov Platform as a service (PaaS) as deployed in production based on the network diagram above. The Cloud Foundry platform as a service is implemented as hardened EC2 instances or virtual servers operating within Cloud Foundry Virtual Private Cloud (VPC).  The instances are deployed to grow and shrink based on demand.

To provide high availability, Cloud.Gov's blob store is on AWS S3, the backend DB is on AWS Relational Database Service (RDS), which is hosted in two different geographically separate locations and the load is distributed amongst the instances (runners) running cloud foundry. The backups of the database are configured with a Retention Point Objective (RPO) within the last five minutes.

Cloud.Gov is a system with multiple components. Only "runner" instances have containers. Traffic goes from the eleastic load balancer (ELB) through the "router" to the "runner". When an application is deployed to Cloud.Gov, an image is created for it and stored internally. The image is then deployed to a Warden container to run in. For multiple instances, multiple images are started on multiple containers. Cloud Foundry's internal Controller leverages the underlying infrastructure to spin up virtual machines to run the Warden containers. When an application is terminated, all its VMs can be recycled for another application to use. If the application instance crashes, its container is killed and a new Warden container is started automatically. A container only ever runs one application ensuring isolation, security and resilience.

A load-balancing router sits at the front of Cloud.Gov to route incoming requests to the correct application - essentially to one of the containers where the application is running.  The only access points visible on a public network are a load balancer that maps to one or more Cloud.Gov routers and, optionally, a NAT VM and a Bastion Host (jump box). Because of the limited number of contact points with the public internet, the surface area for possible security vulnerabilities is minimized.

Applications deployed to Cloud.Gov access external resources via Services. Applications can also access any service that can be reached through the network (either public or private).  In the Cloud.Gov environment, all external dependencies such as databases, messaging systems, and file systems are considered Services. When an application is pushed to Cloud Foundry, the services it should consumed also can be specified. Services have to be deployed to the platform first and then are available to any application using it.

### 18F Virtual Private Cloud (VPC) environment

#### Public Subnet
The hosts within the Public subnet are only used for system maintenance and DNS purposes only.  Instances do not contain any GSA operational data.  The Public subnet allows only the necessary inbound and outbound access with the Internet defined by AWS Security Groups.  In the public subnet there exists a Cloud Foundry bastion host (jump box), A VM that acts as a single access point for the deployed instances as disabling direct access to the instances is a common security measure.  The bastion host (jump box) is used for the purpose of executing the BOSH commands within Cloud Foundry.

#### Private Subnet - Core Tier
The Core Tier is a production subnet where the Cloud.Gov instances reside.   Access to this subnet is restricted to only administrators.  All application development, maintenance and deployment are conducted within the Core Tier subnet.

#### Private Subnet - Services Tier
The Services Tier is a production subnet where applications deployed to Cloud Foundry within the Core Tier can access external resources via Services maintained in the Services Tier through the private network. In the Cloud.Gov environment, all external dependencies such as databases (i.e., Mongo DB, PostgreSQL) and messaging systems are within the Services Tier.

#### Private Subnet - Database Tier
The Database Tier hosts the Cloud.Gov configurations within a PostgreSQL database (i.e. users, orgs, and spaces). These are hosted in geographically separated, isolated by failure physical locations; in short the RDS database is in a Multi-AZ deployment.

#### Cloud.Gov PaaS internal system environment
Cloud Foundry has a flexible organizational structure representation defined through Organizations, Spaces, and Roles.

#### Organizations “Orgs”
At the top of the structural hierarchy are Organizations. They serve as the boundary for governance provided to all the users in that Organization along three different dimensions: quotas, service availability, and custom domains and routes. This allows a single instance of Cloud Foundry to host different Organizations representing different companies, departments, or even projects, and keep separate the resources associated with each of them. Organizations can be defined any way that you like.  An org contains at least one space and can have multiple spaces within it. All collaborators can access an org with user accounts.

#### Spaces
Within organizations are sets of spaces. Spaces define a more narrowed set of resources, scoped to a particular project, team, or environment. All application development and maintenance has to happen inside of a space. Spaces are where developers, QA, and operations usually are found.  A space gives access to a shared location for application development, deployment, and maintenance, and users will have specific space-related roles.

#### User Accounts
A user account represents an individual person within the context of a Cloud Foundry installation. A user can have different roles in different spaces within an org, governing what level and type of access they have within that space. The combination of these roles defines the user’s overall permissions in the org and within specific spaces in that org.  A list of standard cloud foundry user account types can be found in the table below.

## Types of Users
| Role            | Internal or External | Sensitivity Level | Authorized Privileges and Functions Performed                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|-----------------|----------------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Org Manager     | Internal             | High              | Add and manage users, View users and edit org roles, View the org quota, Create, view, edit, and delete spaces, Invite and manage users in spaces, View the status, number of instances, service bindings, and resource use of each application in every space in the org, Add domains                                                                                                                                                                                                      |
| Org Auditor     | Internal             | Low               | View users and org roles, View the org quota                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Space Manager   | Internal             | High              | Add and manage users in the space, View the status, number of instances, service bindings, and resource use of each application in the space                                                                                                                                                                                                                                                                                                                                                |
| Space Developer | Internal             | Moderate          |  Deploy an application,  Start or stop an application,  Rename an application, Delete an application, Create, view, edit, and delete services in a space, Bind or unbind a service to an application, Rename a space, View the status, number of instances, service bindings, and resource use of each application in the space, Change the number of instances, memory allocation, and disk limit of each application in the space, Associate an internal or external URL with an application |
| Space Auditor   | Internal             | Low               | View the status, number of instances, service bindings, and resource use of each application in the space                                                                                                                                                                                                                                                                                                                                                                                   |

## Hardware Inventory

None - Leveraged from AWS Infrastructure|
-|

## Software Inventory
| Hostname                              | Function                                                                                                                                                                                                                                             | Version   | Patch Level | Virtual (Yes / No) |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|-------------|--------------------|
| Cloud Controller (CC)                 | Primary API entry point for Cloud Foundry. It’s responsible for managing the lifecycle of applications. The Cloud Controller also maintains records of orgs, spaces, services, service instances, user roles, and more                               | Version 2 | 212         | Yes                |
| GOrouter                              | Central router that manages traffic to applications deployed on Cloud Foundry                                                                                                                                                                        | Version 2 | 212         | Yes                |
| Droplet execution agent (DEA)         | Performs staging and hosting applications                                                                                                                                                                                                            | Version 2 | 212         | Yes                |
| Health manager                        | monitors the state of the applications and ensures that started applications are indeed running, their versions and number of instances correct                                                                                                      | Version 2 | 212         | Yes                |
| User Account and Authentication (UAA) | identity management service for Cloud Foundry                                                                                                                                                                                                        | Version 2 | 212         | Yes                |
| Login Server                          | Handles authentication for Cloud Foundry and delegates all other identity management tasks to the UAA. Also provides OAuth2 endpoints issuing tokens to client apps for Cloud Foundry (the tokens come from the UAA and no data are stored locally). | Version 2 | 212         | Yes                |
| Collector                             | discover the various components on the message bus and query their /healthz and /varz interfaces                                                                                                                                                     | Version 2 | 212         | Yes                |
| Loggregator                           | user application logging subsystem for Cloud Foundry                                                                                                                                                                                                 | Version 2 | 212         | Yes                |
| Jump Box                              | Used to run BOSH commands                                                                                                                                                                                                                            | Version 2 | 212         | Yes                |
| BOSH                                  | open source tool chain for release engineering, deployment and lifecycle management of large scale distributed services                                                                                                                              | Version 2 | 152         | Yes                |
| ELK Logging                           | General logging system                                                                                                                                                                                                                               | Version 1 | 212         | Yes                |
| CF Deck                               | Graphical user interface for cloud.gov                                                                                                                                                                                                               | Version 2 | 212         | Yes                |
| CF CLI                                | Command line user interface for cloud.gov                                                                                                                                                                                                            | Version 2 | 212         | Yes                |

## Network Inventory
None - Leveraged from AWS Infrastructure|
-|

## Ports, Protocols and Services
| Ports (T or U) | Protocols | Services                                     | Purpose                                                                                                                                     | Used By                                |
|----------------|-----------|----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| 443 (T)        | HTTPS     | HTTPS                                        | CF ec2 web service                                                                                                                          | AWS, Cloud Foundry                     |
| 80 (T)         | HTTP      | HTTP                                         | CF ec2 web service                                                                                                                          | AWS, Cloud Foundry                     |
| 22 (T)         | SSH       | Secure Shell (SSH)                           | Secure command line interface                                                                                                               | AWS, Cloud Foundry Jumpbox             |
| 53 (U)         | DNS       | DNS Service                                  | Inbound DNS requests                                                                                                                        | AWS, Cloud Foundry                     |
| 4222 (T)       | TCP       | NATS bus messaging service                   | Provides publish-subscribe and distributed queueing messaging system internally between all CF components                                   | Cloud Foundry                          |
| 6868 (T)       | HTTP      | Bosh agent interface                         | The Agent executes tasks in response to messages it receives from the Director.                                                             | Cloud Foundry                          |
| 123 (T)        | NTP       | Network Time Protocol (NTP)                  | Sync time within the network                                                                                                                | Cloud Foundry, AWS CloudTrail, Syslogs |
| 17             | UDP       | QOTD                                         | Provide quote of the day                                                                                                                    |                                        |
| 1              | ICMP      | Internet Control Message                     | Information and diagnostics for network devices (Ping)                                                                                      | AWS, Cloud Foundry                     |
| 6 (T)          | TCP       | AWS Elastic Cache                            | Mem Cache                                                                                                                                   | AWS, Cloud Foundry                     |
| 2222 (T)       | SSH       | Secure Shell deamon (SSH)                    | External port for SSH access for apps                                                                                                       | CF SSH Jump box                        |
| 4443 (T)       | TCP       | WSS                                          | TCP /Websocket Traffic                                                                                                                      | Cloud Foundry                          |
| 5432           | TCP       | PostgreSQL                                   | Director bosh_db                                                                                                                            | CF BOSH                                |
| 8081 (T)       | TCP       | User account and authentication server (UAA) | Provide identity management and authorization services                                                                                      | CF UAA, Login Server                   |
| 25250 (T)      | TCP       | BOSH Blobstore                               | repository where BOSH stores release artifacts, logs, stemcells, and other content, at various times during the lifecycle of a BOSH release | Cloud Foundry Jumpbox                  |
| 25555 (T)      | HTTP      | BOSH Director                                | Coordinates the Agents and responds to user requests and system events.                                                                     | Cloud Foundry Jumpbox                  |
| 25777 (T)      | TCP       | BOSH                                         | BOSH Registry                                                                                                                               | Cloud Foundry Jumpbox                  |

## System Interconnections
None - Not Applicable|
-|
