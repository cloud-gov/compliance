### BDD Verification Tests
These BDD were designed to verify compliance security requirements. When the test suite is run, the opencontrol documentation in the directory above is updated accordingly.

#### Install dependencies
```
pip install -r requirements.txt
```
#### Run tests
```
behave
```

#### Creating new link tags
In order to create a self documenting a link tag in the format below should be placed above a test scenario.
`@Verify-Name_of_Test-Component_Key`

Example:
```
Feature: Audit and Accountability

@Component-Log_Test-CloudController
Scenario: Content of Audit Records
  Given I am using a master account
    when I look at the audit logs
    then audit logs have timestamp
```


When the test scenario runs a new verification will appear in the component.
example:
```yaml
verifications:
    key: Log_Test
    last_run: 2016-01-22 13:55:03.305097
    name: Content of Audit Records
    path: 'BDD/CloudController.feature'
    description: |
      Given I am using a master account
      when I look at the audit logs
      then audit logs have timestamp
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
    - verification: Log_Test
```
