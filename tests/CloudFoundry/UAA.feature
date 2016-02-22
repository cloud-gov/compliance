@Component-Account_Lockout_Tests-CloudFoundry-UAA
Feature: CloudFoundry User Account and Authentication (UAA) Server Features

  Scenario: Accounts are not logged out after 3 failed attempts to login
    Given I am a user that can login
      when I attempt to login 3 times and fail
      then I am not locked out

  Scenario: Accounts are logged out after 6 failed attempts to login
    Given I am a user that can login
      when I attempt to login 6 times and fail
      then I am locked out

