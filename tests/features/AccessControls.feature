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

  Scenario: Demonstrate Master Account Giving Permissions
    Given I am using a master account
      when I give the the user the role as listed
        | user                  | role                    |
        | org_manager_user      | org manager role        |
        | org_auditor_user      | org auditor role        |
        | space_manager_user    | space manager role      |
        | space_developer_user  | a space developer role |
        | space_auditor_user    | space auditor role      |
      then all the permission changes succeed

  Scenario Outline: Master Permissions
     Given I am using a master account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Master Account
    | action          |  result         |
    | create an Org   |  succeed        |
    | view an Org     |  succeed        |
    | update an Org   |  succeed        |
    | delete an Org   |  succeed        |
    | create a space  |  succeed        |
    | view a space    |  succeed        |
    | update a space  |  succeed        |
    | delete a space  |  succeed        |
    | create an app   |  succeed        |
    | view an app     |  succeed        |
    | update an app   |  succeed        |
    | delete an app   |  succeed        |
    | create an user  |  succeed        |
    | view an user    |  succeed        |
    | update an user  |  succeed        |
    | delete an user  |  succeed        |



  Scenario Outline: Org Manager Permissions
     Given I am using an Org Manager account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Org Manager Account
    | action          |  result         |
    | create an Org   |  fail           |
    | view an Org     |  succeed        |
    | update an Org   |  succeed        |
    | delete an Org   |  fail           |
    | create a space  |  succeed        |
    | view a space    |  succeed        |
    | update a space  |  succeed        |
    | delete a space  |  succeed        |
    | create an app   |  succeed        |
    | view an app     |  succeed        |
    | update an app   |  succeed        |
    | delete an app   |  succeed        |
    | create an user  |  fail           |
    | view an user    |  fail           |
    | update an user  |  fail           |
    | delete an user  |  fail           |


  Scenario Outline: Org Auditor Permissions
     Given I am using an Org Auditor account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Org Auditor Account
    | action          |  result         |
    | create an Org   |  fail           |
    | view an Org     |  succeed        |
    | update an Org   |  fail           |
    | delete an Org   |  fail           |
    | create a space  |  fail           |
    | view a space    |  fail           |
    | update a space  |  fail           |
    | delete a space  |  fail           |
    | create an app   |  fail           |
    | view an app     |  fail           |
    | update an app   |  fail           |
    | delete an app   |  fail           |
    | create an user  |  fail           |
    | view an user    |  fail           |
    | update an user  |  fail           |
    | delete an user  |  fail           |

  Scenario Outline: Space Manager Permissions
     Given I am using a space Manager account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Manager Account
    | action          |  result         |
    | create an Org   |  fail           |
    | view an Org     |  fail           |
    | update an Org   |  fail           |
    | delete an Org   |  fail           |
    | create a space  |  fail           |
    | view a space    |  succeed        |
    | update a space  |  succeed        |
    | delete a space  |  fail           |
    | create an app   |  succeed        |
    | view an app     |  succeed        |
    | update an app   |  succeed        |
    | delete an app   |  succeed        |
    | create an user  |  fail           |
    | view an user    |  fail           |
    | update an user  |  fail           |
    | delete an user  |  fail           |


  Scenario Outline: Space Developer Permissions
     Given I am using a space Developer account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Developer Account
    | action          |  result         |
    | create an Org   |  fail           |
    | view an Org     |  fail           |
    | update an Org   |  fail           |
    | delete an Org   |  fail           |
    | create a space  |  fail           |
    | view a space    |  succeed        |
    | update a space  |  fail           |
    | delete a space  |  fail           |
    | create an app   |  succeed        |
    | view an app     |  succeed        |
    | update an app   |  succeed        |
    | delete an app   |  succeed        |
    | create an user  |  fail           |
    | view an user    |  fail           |
    | update an user  |  fail           |
    | delete an user  |  fail           |


  Scenario Outline: Space Auditor Permissions
     Given I am using a space Auditor account
      when I try to <action>
      then the action should <result>

   Examples: Action-Results for Space Auditor Account
    | action          |  result         |
    | create an Org   |  fail           |
    | view an Org     |  fail           |
    | update an Org   |  fail           |
    | delete an Org   |  fail           |
    | create a space  |  fail           |
    | view a space    |  succeed        |
    | update a space  |  fail           |
    | delete a space  |  fail           |
    | create an app   |  fail           |
    | view an app     |  succeed        |
    | update an app   |  fail           |
    | delete an app   |  fail           |
    | create an user  |  fail           |
    | view an user    |  fail           |
    | update an user  |  fail           |
    | delete an user  |  fail           |

  Scenario: Demonstrate Master Account Giving Permissions
    Given I am using a master account
      when I remove the user from the role as listed
        | user                  | role                    |
        | org_manager_user      | org manager role        |
        | org_auditor_user      | org auditor role        |
        | space_manager_user    | space manager role      |
        | space_developer_user  | a space developer role |
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
