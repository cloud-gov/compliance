import os
from behave import given, when, then
from cloudfoundry import Client

# Before
def before_feature(context, feature):
    """ Creates a work space before Access Control feature is tested """
    admin_client = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('MASTER_USERNAME', 'admin'),
        password=os.getenv('MASTER_PASSWORD', 'admin'),
        verify_ssl=False
    )
    # Create and org
    org = admin_client.create_org(os.getenv("TEST_ORG", "TEST_ORG"))
    # Create a space
    space = org.create_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    # Create accounts that will be used and set permissions
    org_manager = admin_client.create_user(
        os.getenv("ORG_MANAGER", "ORG_MANAGER"),
        os.getenv("ORG_MANAGER_PASSWORD", "ORG_MANAGER_PASSWORD"),
    )
    org.set_user_role('manager', org_manager.guid)
    org_auditor = admin_client.create_user(
        os.getenv("ORG_AUDITOR", "ORG_AUDITOR"),
        os.getenv("ORG_AUDITOR_PASSWORD", "ORG_AUDITOR_PASSWORD"),
    )
    org.set_user_role('auditor', org_auditor.guid)
    space_manager = admin_client.create_user(
        os.getenv("SPACE_MANAGER", "SPACE_MANAGER"),
        os.getenv("SPACE_MANAGER_PASSWORD", "SPACE_MANAGER_PASSWORD"),
    )
    org.set_user_role('user', space_manager.guid)
    space.set_user_role('user', space_manager.guid)
    space.set_user_role('manager', space_manager.guid)
    space_developer = admin_client.create_user(
        os.getenv("SPACE_DEVELOPER", "SPACE_DEVELOPER"),
        os.getenv("SPACE_DEVELOPER_PASSWORD", "SPACE_DEVELOPER_PASSWORD"),
    )
    org.set_user_role('user', space_developer.guid)
    space.set_user_role('user', space_developer.guid)
    space.set_user_role('developer', space_developer.guid)
    space_auditor = admin_client.create_user(
        os.getenv("SPACE_AUDITOR", "SPACE_AUDITOR"),
        os.getenv("SPACE_AUDITOR_PASSWORD", "SPACE_AUDITOR_PASSWORD"),
    )
    org.set_user_role('user', space_auditor.guid)
    space.set_user_role('user', space_auditor.guid)
    space.set_user_role('auditor', space_auditor.guid)



# Afters
def after_feature(context, feature):
    """ Destroys a work space after Access Control feature is tested """
    admin_client = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('MASTER_USERNAME', 'admin'),
        password=os.getenv('MASTER_PASSWORD', 'admin'),
        verify_ssl=False
    )
    # Delete users
    admin_client.get_user(os.getenv("ORG_MANAGER", "ORG_MANAGER")).delete()
    admin_client.get_user(os.getenv("ORG_AUDITOR", "ORG_AUDITOR")).delete()
    admin_client.get_user(os.getenv("SPACE_MANAGER", "SPACE_MANAGER")).delete()
    admin_client.get_user(os.getenv("SPACE_DEVELOPER", "SPACE_DEVELOPER")).delete()
    admin_client.get_user(os.getenv("SPACE_AUDITOR", "SPACE_AUDITOR")).delete()
    # Delete org and space
    org = admin_client.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    space.delete()
    org.delete()
