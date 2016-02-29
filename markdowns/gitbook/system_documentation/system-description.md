# General System Description

## System Function or Purpose
Cloud.Gov is 18F’s product line for the tools, tech, and services 18F provides to help teams delivering federal digital services to operate efficiently at-scale in a cloud-hosted environment, while complying with federal regulatory requirements. It’s based on and built using the open source Cloud Foundry project, which is an open platform as a service, providing a choice of developer frameworks, and application services which makes it faster and easier to build, test, deploy, and scale applications.

## Information System Components and Boundaries
18F has created a specific set of VPCs (Live production and staging) for its Cloud.Gov implementation. All VPCs have subnets used to separate and control IP address space within each individual VPC. Subnets must be created in order to launch Availability Zone (AZ) specific services within a VPC. 18F has setup VPC Peering between the Staging VPC and the CF Live production VPC.

The Clould.Gov PaaS Information System is hosted within the AWS East Public Cloud in the Northern Virginia Region. AWS services utilized include ENI, EC2, EBS, VPC, RDS, S3, MFA, Route 53 and IAM. These are listed as leveraged hardware, network and server components.

Physical aspects of the Clous.Gov PasS information system are outside of the accreditation boundary due to all hardware being physically managed by Amazon AWS. While other services are reviewed and approved for use by the GSA OCISO as they were deemed to be ancillary support services that do not directly process/store data but rather provide general support services. These services include Cloudfront, Cloudtrail, Cloud Config and Trusted Advisor.

## Network Architecture
The following architectural diagram(s) provides a visual depiction of the system network components that constitute Cloud.Gov.

# System Environment
The following describes the Cloud.Gov Platform as a service (PaaS) as deployed in production based on the network diagram above. The Cloud Foundry platform as a service is implemented as hardened EC2 instances or virtual servers operating within Cloud Foundry Virtual Private Cloud (VPC).  The instances are deployed to grow and shrink based on demand.

To provide high availability, Cloud Foundry’s blob store is on AWS S3, the backend DB is on AWS Relational Database Service (RDS), which is hosted in two different geographically separate locations and the load is distributed amongst the instances (runners) running cloud foundry. The backups of the database are configured with a Retention Point Objective (RPO) within the last five minutes.

Cloud.Gov is a system with multiple components. Only "runner" instances have containers. Traffic goes from the ELB through the "router" to the "runner". When an application is deployed to Cloud Foundry, an image is created for it and stored internally. The image is then deployed to a Warden container to run in. For multiple instances, multiple images are started on multiple containers. Cloud Foundry's internal Controller leverages the underlying infrastructure to spin up virtual machines to run the Warden containers. When an application is terminated, all its VMs can be recycled for another application to use. If the application instance crashes, its container is killed and a new Warden container is started automatically. A container only ever runs one application ensuring isolation, security and resilience.

A load-balancing router sits at the front of Cloud Foundry to route incoming requests to the correct application - essentially to one of the containers where the application is running.  The only access points visible on a public network are a load balancer that maps to one or more Cloud Foundry routers and, optionally, a NAT VM and a Bastion Host (jump box). Because of the limited number of contact points with the public internet, the surface area for possible security vulnerabilities is minimized.

Applications deployed to Cloud Foundry access external resources via Services. Applications can also access any service that can be reached through the network (either public or private).  In  the Cloud Foundry PaaS environment, all external dependencies such as databases, messaging systems, and file systems are considered Services. When an application is pushed to Cloud Foundry, the services it should consumed also can be specified. Services have to be deployed to the platform first and then are available to any application using it. Users of the Open Source Cloud Foundry must make services available by writing and running BOSH scripts.

### 18F Virtual Private Cloud (VPC) environment

#### Public Subnet
The hosts within the Public subnet are only used for system maintenance and DNS purposes only.  Instances do not contain any GSA operational data.  The Public subnet allows only the necessary inbound and outbound access with the Internet defined by AWS Security Groups.  In the public subnet there exists a Cloud Foundry bastion host (jump box), A VM that acts as a single access point for the deployed instances as disabling direct access to the instances is a common security measure.  The bastion host (jump box) is used for the purpose of executing the BOSH commands within Cloud Foundry.

#### Private Subnet - Core Tier
The Core Tier is a production subnet where the Cloud Foundry PaaS instances reside.   Access to this subnet is restricted to only administrators.  All application development, maintenance and deployment are conducted within the Core Tier subnet.

#### Private Subnet - Services Tier
The Services Tier is a production subnet where applications deployed to Cloud Foundry within the Core Tier can access external resources via Services maintained in the Services Tier through the private network. In the CF PaaS environment, all external dependencies such as databases (i.e., Mongo DB, PostgreSQL) and messaging systems are within the Services Tier.

#### Private Subnet - Database Tier
The Database Tier hosts the Cloud Foundry configurations within a PostgreSQL database (i.e. users, orgs, and spaces). These are hosted in geographically separated, isolated by failure physical locations; in short the RDS database is in a Multi-AZ deployment.

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
