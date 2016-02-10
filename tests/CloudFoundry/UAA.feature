Feature: UAA Features

  Scenario: Account Lockout (AC-7)
    Given I am a user that can login
      when I attempt to login 6 times and fail
      then I am locked out
