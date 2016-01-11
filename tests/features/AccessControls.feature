Feature: Access Controls

  Scenario Outline: Creating Organizations
     Given I am using <account> account
       when I try to create an org
       then the org <status>

   Examples: Action-Results for creating orgs
     | account          |  status         |
     | a master         |  exists         |
     | an org manager   |  does not exist |
     | an org auditor   |  does not exist |
     | a space manager  |  does not exist |
     | a space developer|  does not exist |
     | a space auditor  |  does not exist |

   Scenario Outline: Destroying Organizations
      Given I am using <account> account
        when I try to delete an org
        then the org <status>

    Examples: Action-Results for deleting orgs
      | account          |  status	   |
      | a master         |  does not exist |
      | an org manager   |  exists         |
      | an org auditor   |  exists         |
      | a space manager  |  exists         |
      | a space developer|  exists         |
      | a space auditor  |  exists         |


  Scenario Outline: Creating Spaces
     Given I am using <account> account
       when I try to create a space
       then the space <status>

   Examples: Action-Results for creating spaces
     | account          |  status	        |
     | a master         |  exists         |
     | an org manager   |  exists         |
     | an org auditor   |  does not exist |
     | a space manager  |  does not exist |
     | a space developer|  does not exist |
     | a space auditor  |  does not exist |

   Scenario Outline: Destroying Spaces
      Given I am using <account> account
        when I try to delete a space
        then the space <status>

    Examples: Action-Results for deleting spaces
      | account          |  status    	   |
      | a master         |  does not exist |
      | an org manager   |  does not exist |
      | an org auditor   |  exists         |
      | a space manager  |  exists         |
      | a space developer|  exists         |
      | a space auditor  |  exists         |


  Scenario Outline: Creating Apps
     Given I am using <account> account
       when I try to create an app
       then the app <status>

   Examples: Action-Results for creating apps
     | account          |  status         |
     | a master         |  exists         |
     | an org manager   |  does not exist |
     | an org auditor   |  does not exist |
     | a space manager  |  does not exist |
     | a space developer|  exists         |
     | a space auditor  |  does not exist |

   Scenario Outline: Destroying Apps
      Given I am using <account> account
        when I try to delete an app
        then the app <status>

    Examples: Action-Results for deleting apps
      | account          |  status 	       |
      | a master         |  does not exist |
      | an org manager   |  exists         |
      | an org auditor   |  exists         |
      | a space manager  |  exists         |
      | a space developer|  does not exist |
      | a space auditor  |  exists         |
