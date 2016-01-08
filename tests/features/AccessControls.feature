Feature: Access Controls

  Scenario: Demonstrate Master Account Creating Users
    Given I am using a master account
      when I create the accounts from the list below
        | user                  |
        | org_manager_user      |
        | org_auditor_user      |
        | space_manager_user    |
        | space_developer_user  |
        | space_auditor_user    |
      then all of the accounts from the list below exist
        | user                  |
        | org_manager_user      |
        | org_auditor_user      |
        | space_manager_user    |
        | space_developer_user  |
	| space_auditor_user    |

  Scenario: Demonstrate Master Account Creating Workspaces
    Given I am using a master account
     when I create an org and a space
     then the action should succeed

   Scenario: Demonstrate Master Account Deleting Workspaces
    Given I am using a master account
     when I delete an org and a space
     then the action should succeed

  Scenario: Demonstrate Master Account Giving Permissions
    Given I am using a master account
      when I give the the user the role as listed
        | user                  | role                    |
        | org_manager_user      | org manager role        |
        | org_auditor_user      | org auditor role        |
        | space_manager_user    | space manager role      |
        | space_developer_user  | a space developer role  |
        | space_auditor_user    | space auditor role      |
      then all the permission changes succeed

  Scenario Outline: Master Permissions
     Given I am using a master account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Master Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |


  Scenario Outline: org Manager Permissions
     Given I am using an org Manager account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for org Manager Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |


  Scenario Outline: org Auditor Permissions
     Given I am using an org Auditor account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for org Auditor Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |

  Scenario Outline: Space Manager Permissions
     Given I am using a space Manager account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Manager Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |


  Scenario Outline: Space Developer Permissions
     Given I am using a space Developer account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Developer Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |


  Scenario Outline: Space Auditor Permissions
     Given I am using a space Auditor account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Auditor Account
    | action          |  result		|
    | create an org   |  succeed        |
    | create a space  |  succeed        |
    | create an app   |  succeed        |
    | create a user   |  succeed        |
    | view an org     |  succeed        |
    | view a space    |  succeed        |
    | view an app     |  succeed        |
    | view a user     |  succeed        |
    | update an org   |  succeed        |
    | update a space  |  succeed        |
    | update an app   |  succeed        |
    | update a user   |  succeed        |
    | delete a user   |  succeed        |
    | delete an app   |  succeed        |
    | delete a space  |  succeed        |
    | delete an org   |  succeed        |

  Scenario: Demonstrate Master Account Removing Permissions
    Given I am using a master account
      when I remove the user from the role as listed
        | user                  | role                    |
        | org_manager_user      | org manager role        |
        | org_auditor_user      | org auditor role        |
        | space_manager_user    | space manager role      |
        | space_developer_user  | a space developer role  |
        | space_auditor_user    | space auditor role      |
      then all the permission changes succeed

  Scenario: Demonstrate Master Account Deleting Users
    Given I am using a master account
      when I delete the accounts from the list below
        | user                  |
        | org_manager_user      |
        | org_auditor_user      |
        | space_manager_user    |
        | space_developer_user  |
        | space_auditor_user    |
      then none of the accounts from the list below exist
        | user                  |
        | org_manager_user      |
        | org_auditor_user      |
        | space_manager_user    |
        | space_developer_user  |
        | space_auditor_user    |
