## Cloud.gov Tests
BBD style tests for verifying Cloud.gov's compliance with FedRAMP controls

## Usage

#### Install Dependencies  
`pip install -r requirements.txt`

#### Deploy Application Security Group Testing app
`git clone https://github.com/18F/security-group-test-app.git`
`cd security-group-test-app`
`cf create-org ASG_ORG`
`cf create-space ASG_SPACE`
`cf target -o ASG_ORG -s ASG_SPACE`
`cf push`

Store the org, space, app, and app route in `ASG_ORG`, `ASG_SPACE`, `ASG_APP`, `ASG_APP_URL` to export as env variables.

#### Setup environment variables (optional for local deployment)
`export CF_URL=<<Cloud Foundry API>>`

Existing Account
`export MASTER_USERNAME=<<Cloud Foundry Admin Account>>`
`export MASTER_PASSWORD=<<Cloud Foundry Admin password>>`

Accounts that will be created
`export ORG_MANAGER=<<Org Manager Account Name>>`
`export ORG_MANAGER_PASSWORD=<<Org Manager Password>>`

`export ORG_AUDITOR=<<Org Auditor Account Name>>`
`export ORG_AUDITOR_PASSWORD=<<Org Auditor Account Password>>`

`export SPACE_MANAGER=<<Space Manager Account Name>>`
`export SPACE_MANAGER_PASSWORD=<<Space Manager Account Password>>`

`export SPACE_DEVELOPER=<<Space Developer Account Name>>`
`export SPACE_DEVELOPER_PASSWORD=<<Space Developer Account Password>>`

`export SPACE_AUDITOR=<<Space Auditor Account Name>>`
`export SPACE_AUDITOR_PASSWORD=<<Space Auditor Account Password>>`

`export TEST_ORG=<<Test Org Name>>`
`export TEST_ORG_2=<<Test Org 2 Name>>`
`export TEST_ORG_UPDATE=<<Name Change for TEST_ORG>>`

`export TEST_SPACE=<<Test Space Name>>`
`export TEST_SPACE_2=<<Test Space 2 Name>>`
`export TEST_SPACE_UPDATE=<<Name Change for TEST_SPACE>>`

`export TEST_APP=<<Test App Name>>`
`export TEST_APP_UPDATE=<<Name Change for TEST_APP_UPDATE>>`

`export TEST_USER=<<Test User Name>>`
`export TEST_USER_PASSWORD=<<Test Password Name>>`

`export ASG_ORG=<<The org that contains a special app for testing application security groups>>`
`export ASG_SPACE=<<The space that contains a special app for testing application security groups>>`
`export ASG_APP=<<The app for testing application security groups>>`
`export ASG_APP_URL=<<The url for testing application security groups>>`
`export CLOSED_SECURITY_GROUP=<<The name of the closed security group>>`
`export OPEN_SECURITY_GROUP=<<The name of the open security group>>`


#### Run tests
`behave`
