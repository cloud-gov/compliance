import os
import datetime
import requests
import time

from behave import given, when, then

from cloudfoundry import Client

ADMIN = Client(
    api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com'),
    username=os.getenv('MASTER_USERNAME', 'admin'),
    password=os.getenv('MASTER_PASSWORD', 'admin'),
    verify_ssl=False
)

ASG_ORG = os.getenv("ASG_ORG", 'ASG_ORG')
ASG_SPACE = os.getenv("ASG_SPACE", 'ASG_SPACE')
ASG_APP = os.getenv("ASG_APP", 'security-group-test')
ASG_APP_URL = os.getenv('ASG_APP_URL', 'http://security-group-test.bosh-lite.com')

CLOSED_SECURITY_GROUP = os.getenv("CLOSED_GROUP", "CLOSED_GROUP")
OPEN_SECURITY_GROUP = os.getenv("OPEN_GROUP", "OPEN_GROUP")

# Givens
@given('an application')
def step_impl(context):
    assert ADMIN.get_org(ASG_ORG).get_space(ASG_SPACE).get_app(ASG_APP)

@given('a security group that closes all outgoing tcp connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=CLOSED_SECURITY_GROUP)

@given('a security group that is open to all public outgoing connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=OPEN_SECURITY_GROUP)

@when('I try to view all the ASGs')
def step_impl(context):
    assert len(context.user.get_security_groups()) > 1


@when('I bind the application security group with open settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(ASG_ORG).get_space(ASG_SPACE)
    sg = ADMIN.get_security_group(name=OPEN_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(ASG_APP).restart()
    time.sleep(30)

@when('I bind the application security group with closed settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(ASG_ORG).get_space(ASG_SPACE)
    sg = ADMIN.get_security_group(name=CLOSED_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(ASG_APP).restart()
    time.sleep(30)

@then('I can view and print all the ASGs')
def step_impl(context):
    groups = context.user.get_security_groups()
    # TODO add export
    print(groups)

@then('the application can ping an external site')
def step_impl(context):
    space =  ADMIN.get_org(ASG_ORG).get_space(ASG_SPACE)
    app = space.get_app(ASG_APP)
    routes = app.get_routes()
    result = requests.get(ASG_APP_URL, verify=False).text
    sg = ADMIN.get_security_group(name=OPEN_SECURITY_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Success' in result

@then('the application cannot ping an external site')
def step_impl(context):
    space =  ADMIN.get_org(ASG_ORG).get_space(ASG_SPACE)
    app = space.get_app(ASG_APP)
    routes = app.get_routes()
    result = requests.get(ASG_APP_URL, verify=False).text
    sg = ADMIN.get_security_group(name=CLOSED_SECURITY_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Failed' in result
