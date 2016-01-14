import os
import datetime

from behave import given, when, then

from cloudfoundry import Client

TEST_START = datetime.datetime.utcnow().isoformat()
ADMIN = Client(
    api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
    username=os.getenv('MASTER_USERNAME', 'admin'),
    password=os.getenv('MASTER_PASSWORD', 'admin'),
    verify_ssl=False
)

# Givens
@given('I am using a master account')
def step_impl(context):
    context.user = ADMIN

@given('I am using an org manager account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('ORG_MANAGER', 'ORG_MANAGER'),
        password=os.getenv('ORG_MANAGER_PASSWORD', 'ORG_MANAGER_PASSWORD'),
        verify_ssl=False
    )
    
@given('I am using an org auditor account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('ORG_AUDITOR', 'ORG_AUDITOR'),
        password=os.getenv('ORG_AUDITOR_PASSWORD', 'ORG_AUDITOR_PASSWORD'),
        verify_ssl=False
    )

@given('I am using a space manager account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('SPACE_MANAGER', 'SPACE_MANAGER'),
        password=os.getenv('SPACE_MANAGER_PASSWORD', 'SPACE_MANAGER_PASSWORD'),
        verify_ssl=False
    )

@given('I am using a space developer account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('SPACE_DEVELOPER', 'SPACE_DEVELOPER'),
        password=os.getenv('SPACE_DEVELOPER_PASSWORD', 'SPACE_DEVELOPER_PASSWORD'),
        verify_ssl=False
    )

@given('I am using a space auditor account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('SPACE_AUDITOR', 'SPACE_AUDITOR'),
        password=os.getenv('SPACE_AUDITOR_PASSWORD', 'SPACE_AUDITOR_PASSWORD'),
        verify_ssl=False
    )

# Whens
@when('I try to create an org')
def step_impl(context):
    # Create an org
    context.user.create_org(os.getenv("TEST_ORG_2", "TEST_ORG_2"))

@when('I try to delete an org')
def step_impl(context):
    # Create or get an org
    org = ADMIN.create_org(os.getenv("TEST_ORG_2", "TEST_ORG_2"))
    # Destory the org using the user
    org.client = context.user
    org.delete()

@when('I try to update an org name')
def step_impl(context):
    # Get an org
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    # Try to update the org with user
    org.client = context.user
    org.update(name=os.getenv("TEST_ORG_UPDATE", "TEST_ORG_UPDATE"))

@when('I try to create a space')
def step_impl(context):
    # Get the org
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    # Create the space
    org.client = context.user
    org.create_space('TEST_SPACE_2')

@when('I try to delete a space')
def step_impl(context):
    # Get the space
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.create_space(os.getenv("TEST_SPACE_2", "TEST_SPACE_2"))
    # Destory the space
    space.client = context.user
    space.delete()

@when('I try to update a space name')
def step_impl(context):
    # Get an org
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    # Try to update the org with user
    space.client = context.user
    space.update(name=os.getenv("TEST_SPACE_UPDATE", "TEST_SPACE_UPDATE"))

@when('I try to create an app')
def step_impl(context):
    # Get the space
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    # Create the app
    space.client = context.user
    space.create_app(os.getenv("TEST_APP", "TEST_APP"))

@when('I try to delete an app')
def step_impl(context):
    # Get the app
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    app = space.create_app(os.getenv("TEST_APP", "TEST_APP"))
    # Destory the app
    app.client = context.user
    app.delete()

@when('I try to create a user')
def step_impl(context):
    context.user.create_user(
        os.getenv("TEST_USER", "TEST_USER"),
        os.getenv("TEST_USER", "TEST_USER_PASSWORD"),
    )

@when('I try to give a user access to a "{workspace}"')
def step_impl(context, workspace):
    # Get a user
    ADMIN.create_user(
        os.getenv("TEST_USER", "TEST_USER"),
        os.getenv("TEST_USER", "TEST_USER_PASSWORD"),
    )
    new_user = ADMIN.get_user(os.getenv("TEST_USER", "TEST_USER"))
    ws = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    context.workspace = 'audited_organizations'
    if workspace == 'audited_space':
        # Make user org user before making them space user
        ws.set_user_role('user', new_user.guid)
        ws.set_user_role('auditor', new_user.guid)        
        ws = ws.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
        context.workspace = 'spaces'
    # Try to update the org/space with user
    ws.client = context.user
    ws.set_user_role('user', new_user.guid)
    ws.set_user_role('auditor', new_user.guid)


@when('I try to delete a user')
def step_impl(context):
    user = ADMIN.create_user(
        os.getenv("TEST_USER", "TEST_USER"),
        os.getenv("TEST_USER", "TEST_USER_PASSWORD"),
    )
    user.client = context.user
    user.delete()


@when('I view my audit logs')
def step_impl(context):
    logs = context.user.events(filters={'q': 'timestamp>' + TEST_START})
    context.number_of_results = logs.get('total_results')


# Thens
@then('the org exists')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG_2", "TEST_ORG_2"))
    assert org
    org.client = ADMIN
    org.delete()

@then('the org does not exist')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG_2", "TEST_ORG_2"))
    assert not org

@then('the space exists')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE_2", "TEST_SPACE_2"))
    assert space
    space.delete()

@then('the space does not exist')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE_2", "TEST_SPACE_2"))
    assert not space

@then('the app exists')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    app = space.get_app(os.getenv("TEST_APP", "TEST_APP"))
    assert app
    app.delete()

@then('the app does not exist')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space = org.get_space(os.getenv("TEST_SPACE", "TEST_SPACE"))
    app = space.get_app(os.getenv("TEST_APP", "TEST_APP"))
    assert not app

@then('the user exists')
def step_impl(context):
    user = ADMIN.get_user(
        os.getenv("TEST_USER", "TEST_USER"),
    )
    assert user
    user.delete()

@then('the user does not exist')
def step_impl(context):
    user = ADMIN.get_user(
        os.getenv("TEST_USER", "TEST_USER"),
    )
    assert not user

@then('the org name changes')
def step_impl(context):
    # Check for updated name
    org_new_name = ADMIN.get_org(os.getenv("TEST_ORG_UPDATE", "TEST_ORG_UPDATE"))
    assert org_new_name
    # Return to old name
    org_new_name.update(name=os.getenv("TEST_ORG", "TEST_ORG"))

@then('the org name stays the same')
def step_impl(context):
    org_new_name = ADMIN.get_org(os.getenv("TEST_ORG_UPDATE", "TEST_ORG_UPDATE"))
    assert not org_new_name

@then('the space name changes')
def step_impl(context):
    # Check for updated name
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space_new_name = org.get_space(os.getenv("TEST_SPACE_UPDATE", "TEST_SPACE_UPDATE"))
    assert space_new_name
    # Return to old name
    space_new_name.update(name=os.getenv("TEST_SPACE", "TEST_SPACE"))

@then('the space name stays the same')
def step_impl(context):
    org = ADMIN.get_org(os.getenv("TEST_ORG", "TEST_ORG"))
    space_new_name = org.get_space(os.getenv("TEST_SPACE_UPDATE", "TEST_SPACE_UPDATE"))
    assert not space_new_name

@then('the user does not have access')
def step_impl(context):
    user = ADMIN.get_user(os.getenv("TEST_USER", "TEST_USER"))
    summary = user.summary()
    user.delete()    
    assert len(summary['entity'].get(context.workspace)) == 0

@then('the user has access')
def step_impl(context):
    user = ADMIN.get_user(os.getenv("TEST_USER", "TEST_USER"))
    summary = user.summary()
    user.delete()
    print(summary)
    assert len(summary['entity'].get(context.workspace)) == 1

@then('I find "{number}" events')
def step_impl(context, number):
    print(context.number_of_results)
    assert int(number) == context.number_of_results
