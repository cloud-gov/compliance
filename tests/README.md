## Cloud.gov Tests
BBD style tests for verifying Cloud.gov's compliance with FedRAMP controls

## Usage

#### Install Dependencies  
`pip install -r requirements.txt`

Store the org, space, app, and app route in `ASG_ORG`, `ASG_SPACE`, `ASG_APP`, `ASG_APP_URL` to export as env variables.

#### Setup environment variables (optional for local deployment)
Existing Account
```bash
export CF_URL="Cloud Foundry API"`
export MASTER_USERNAME="Cloud Foundry Admin Account"
export MASTER_PASSWORD="Cloud Foundry Admin password"
```

Accounts that will be created
```bash
export ORG_MANAGER="Org Manager Account Name"
export ORG_MANAGER_PASSWORD="Org Manager Password"

export ORG_AUDITOR="Org Auditor Account Name"
export ORG_AUDITOR_PASSWORD="Org Auditor Account Password"

export SPACE_MANAGER="Space Manager Account Name"
export SPACE_MANAGER_PASSWORD="Space Manager Account Password"

export SPACE_DEVELOPER="Space Developer Account Name"
export SPACE_DEVELOPER_PASSWORD="Space Developer Account Password"

export SPACE_AUDITOR="Space Auditor Account Name"
export SPACE_AUDITOR_PASSWORD="Space Auditor Account Password"

export TEST_ORG="Test Org Name"
export TEST_ORG_2="Test Org 2 Name"
export TEST_ORG_UPDATE="Name Change for TEST_ORG"

export TEST_SPACE="Test Space Name"
export TEST_SPACE_2="Test Space 2 Name"
export TEST_SPACE_UPDATE="Name Change for TEST_SPACE"

export TEST_APP="Test App Name"
export TEST_APP_UPDATE="Name Change for TEST_APP_UPDATE"

export TEST_USER="Test User Name"
export TEST_USER_PASSWORD="Test Password Name"

export CLOSED_GROUP="The name of the closed security group"
export OPEN_GROUP="The name of the open security group"
```

#### Run tests
```
behave
```


### Self Documentation and Tagging components
These BDD tests have the ability to self document in the [components documentation](https://github.com/18F/cg-compliance/tree/master/data/components).

In order to create a self documenting a tag in the format below should be placed above a test scenario.
`@Component/"Name of the test"/"System Key"/"Component_Key"`
example:
```
Feature: Audit and Accountability

@Component/LOG_TESTS/CloudFoundry/CloudController
Scenario: Content of Audit Records
  Given I am using a master account
    when I look at the audit logs
    then audit logs have timestamp
    And audit logs have type of event
    And audit logs have actor
    And audit logs have actee
```

When the test scenario runs a new verification will appear in the component.
example:
```yaml
verifications:
  LOG_TESTS:
    last_run: 2016-01-22 13:55:03.305097
    name: Audit and Accountability Content of Audit Records
    path: 'Feature: Audit and Accountability Scenario: Content of Audit Records'
    type: TEST
```

These verification can be added to specific control to prove that the information system's control requirements are satisfied.
```yaml
satisfies:
  NIST-800-53:

  AU-3:
    implementation_status: null
    narrative: 'Cloud Foundry stores detailed events which can be accessed through
      the CF API. A list the events is available in the API documentation.
      '
    references:
    - verification: LOG_TESTS
```
