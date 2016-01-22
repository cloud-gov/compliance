Feature: Audit and Accountability


Scenario: Content of Audit Records
  Given I am using a master account
    when I look at the audit logs
    then audit logs have timestamp
    And audit logs have type of event
    And audit logs have actor
    And audit logs have actee
