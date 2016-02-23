@Component-Security_Group_Tests-CloudFoundry-ApplicationSecurityGroups
Feature: Application Security Groups

  Background:
    Given a space
      And a security group that is open to all public outgoing connections
      And a security group that closes all outgoing tcp connections

  Scenario: Admins can view Application Security Groups
    Given I am using an admin account
      then I can view and print all the ASGs

  Scenario: Admins can define closed application security groups
    Given I am using an admin account
    when I try to bind the application security group with closed settings to the space
    then the security group is bound

  Scenario: Admins can define open application security groups
    Given I am using an admin account
    when I try to bind the application security group with open settings to the space
    then the security group is bound
