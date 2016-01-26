@Component-ASG_OPEN_AND_CLOSED-CloudFoundry-ApplicationSecurityGroups
Feature: Access Control Flow

  Background:
    Given a space
      And a security group that is open to all public outgoing connections
      And a security group that closes all outgoing tcp connections

  @Component-ASG_LIST-CloudFoundry-ApplicationSecurityGroups
  Scenario: View Application Security Groups
    Given I am using a master account
      then I can view and print all the ASGs

  Scenario: Close Application Security Group
    Given I am using a master account
    when I try to bind the application security group with closed settings to the space
    then the security group is bound
 
  Scenario: Open Application Security Group
    Given I am using a master account
    when I try to bind the application security group with open settings to the space
    then the security group is bound
