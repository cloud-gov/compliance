import os

from behave import given, when, then

from cloudfoundry import Client

# Givens
@given('I am using a master account')
def step_impl(context):
    context.user = Client(
        api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com') ,
        username=os.getenv('MASTER_USERNAME', 'admin'), 
        password=os.getenv('MASTER_PASSWORD', 'admin'),
        verify_ssl=False
    )

@given('I am using an Org Manager account')
def step_impl(context):
    pass

@given('I am using an Org Auditor account')
def step_impl(context):
    pass

@given('I am using a Space Manager account')
def step_impl(context):
    pass

@given('I am using a Space Developer account')
def step_impl(context):
    pass

@given('I am using a Space Auditor account')
def step_impl(context):
    pass

# Whens
@when('I create the accounts from the list below')
def step_impl(context):
    for row in context.table:
        username = row['user']
        context.user.create_user(username, os.getenv(username, username))

@when('I give the the user the role as listed')
def step_impl(context):
    for row in context.table:
        print(row['user'], row['role'])

@when('I remove the user from the role as listed')
def step_impl(context):
    for row in context.table:
        print(row['user'], row['role'])

@when('I delete the accounts from the list below')
def step_impl(context):
    for row in context.table:
        username = row['user']
        context.user.delete_user(username) 

@when('I try to create an org')
def step_impl(context):
    pass

@when('I try to view an org')
def step_impl(context):
    pass

@when('I try to update an org')
def step_impl(context):
    pass

@when('I try to delete an org')
def step_impl(context):
    pass

@when('I try to create a space')
def step_impl(context):
    pass

@when('I try to view a space')
def step_impl(context):
    pass

@when('I try to update a space')
def step_impl(context):
    pass

@when('I try to delete a space')
def step_impl(context):
    pass


@when('I try to create an app')
def step_impl(context):
    pass

@when('I try to view an app')
def step_impl(context):
    pass

@when('I try to update an app')
def step_impl(context):
    pass

@when('I try to delete an app')
def step_impl(context):
    pass

@when('I try to create an user')
def step_impl(context):
    pass

@when('I try to view an user')
def step_impl(context):
    pass

@when('I try to update an user')
def step_impl(context):
    pass

@when('I try to delete an user')
def step_impl(context):
    pass


# Thens
@then('all of the accounts from the list below exist')
def step_impl(context):
    for row in context.table:
        username = row['user']
        assert context.user.find_user(username)

@then('none of the accounts from the list below exist')
def step_impl(context):
    for row in context.table:
        username = row['user']
        assert not context.user.find_user(username)

@then('all the permission changes succeed')
def step_impl(context):
    pass

@then('the action should succeed')
def step_impl(context):
    pass

@then('the action should fail')
def step_impl(context):
    pass
