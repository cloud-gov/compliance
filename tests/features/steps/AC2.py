import os

from behave import given, when, then

from cloudfoundry import CloudFoundry

@given('A non-privileged account')
def step_impl(context):
    context.user = CloudFoundry(
        url=os.getenv('CF_DOMAIN'),
        username=os.getenv('CF_USER'),
        password=os.getenv('CF_PASSWORD'),
    )

@when('we try to view all user information')
def step_impl(context):
    context.response = context.user.make_request('/v2/users')

@then('we will receive an error')
def step_impl(context):
    assert 'error_code' in context.response
