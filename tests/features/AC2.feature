Feature: The system assigns account managers for information system accounts (b)
  Scenario: Only Cloud.gov managers have access to all user information
    Given A non-privileged account
      when we try to view all user information
      then we will receive an error
