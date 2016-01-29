# General System Description

## System Function or Purpose
Cloud.Gov is 18F’s product line for the tools, tech, and services 18F provides to help teams delivering federal digital services to operate efficiently at-scale in a cloud-hosted environment, while complying with federal regulatory requirements. It’s based on and built using the open source Cloud Foundry project, which is an open platform as a service, providing a choice of developer frameworks, and application services which makes it faster and easier to build, test, deploy, and scale applications.

## Information System Components and Boundaries


## Types of Users
#### Org Manager
Internal, Low	sensitivity
Add and manage users
View users and edit org roles
View the org quota
Create, view, edit, and delete spaces
Invite and manage users in spaces
View the status, number of instances, service bindings, and resource use of each application in every space in the org
Add domains

#### Org Auditor
Internal, Low Sensitivity
View users and org roles
View the org quota

#### Space Manager
Internal, Low Sensitivity
Add and manage users in the space
View the status, number of instances, service bindings, and resource use of each application in the space

#### Space Developer
Internal, Moderate Sensitivity
Deploy an application
Start or stop an application
Rename an application
Delete an application
Create, view, edit, and delete services in a space
Bind or unbind a service to an application
Rename a space
View the status, number of instances, service bindings, and resource use of each application in the space
Change the number of instances, memory allocation, and disk limit of each application in the space
Associate an internal or external URL with an application

#### Space Auditor
Internal, Low Sensitivity
View the status, number of instances, service bindings, and resource use of each application in the space

## Network Architecture
The following architectural diagram(s) provides a visual depiction of the system network components that constitute Cloud.Gov.

# System Environment

## Hardware Inventory
Leveraged from AWS - None

## Software Inventory
#### Cloud Controller (CC)
Version 2, Virtual
Primary API entry point for Cloud Foundry. It’s responsible for managing the lifecycle of applications. The Cloud Controller also maintains records of orgs, spaces, services, service instances, user roles, and more

#### GO router
Version 2, Virtual
Central router that manages traffic to applications deployed on Cloud Foundry

#### Droplet execution agent (DEA)
Version 2, Virtual
Performs staging and hosting applications

#### Health manager
Version 2, Virtual
Monitors the state of the applications and ensures that started applications are indeed running, their versions and number of instances correct

#### User Account and Authentication (UAA)
Version 2, Virtual
Identity management service for Cloud Foundry

#### Login Server
Version 2, Virtual
Handles authentication for Cloud Foundry and delegates all other identity management tasks to the UAA. Also provides OAuth2 endpoints issuing tokens to client apps for Cloud Foundry (the tokens come from the UAA and no data are stored locally).

#### Collector
Version 2, Virtual
Discovers the various components on the message bus and query their /healthz and /varz interfaces

#### Loggregator
Version 2, Virtual
User application logging subsystem for Cloud Foundry

#### Jump Box
Version 2, Virtual
Used to run BOSH commands

#### BOSH
Version 2 (230), Virtual
Open source tool chain for release engineering, deployment and lifecycle management of large scale distributed services

#### ELK
Version 2, Virtual
General logging system

#### CF Deck
Version 2, Virtual
Graphical user interface for Cloud.gov

## Network Inventory
Leveraged from AWS - None

## Ports, Protocols and Services
Ports (TCP/UDP) |	Protocols |	Services |	Purpose |	Used By 
--- | --- | --- | ---
80/TCP |	HTTP |	HTTP Web service |	Cloud.Gov EC2 Web service |	Tomcat
443/TCP |	HTTPS |	HTTPS Web Service |	Cloud.Gov EC2 Web service	 |
22/SSH |	SSH |	Secure Shell |	CF and BOSH command line interface |
53/UDP |	DNS |	DNS Service |	Inbound DNS requests	|
4222/TCP | TCP |	NATS Bus Messaging Service |	Publish- subscribe messaging service between Cloud.Gov components |
6868/TCP |	HTTP |	BOSH agent interface |	Executes tasks it receives from the BOSH Director	|
123/TCP |	NTP |	Network Time Protocol	| |
17/UDP |	QOTD |		Provide Quote of the day	| |
1/ICMP	| | | |
6/TCP	 | | |	|		
2222/TCP |	SSH	 | Secure Shell Deamon |	External port for SSH access to Apps	|
4443/TCP	 |  | | |			
5432/TCP 	 |  | | |
8081/TCP   |  | | |			
25250/TCP	 |  | | |			
25555/TCP  |  | | |			
25777/TCP	 |  | | |			

## System Interconnections
None
