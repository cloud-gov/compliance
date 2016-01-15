import os
import datetime
import requests

from behave import given, when, then

from cloudfoundry import Client

ADMIN = Client(
    api_url=os.getenv('CF_URL', 'https://api.bosh-lite.com'),
    username=os.getenv('MASTER_USERNAME', 'admin'),
    password=os.getenv('MASTER_PASSWORD', 'admin'),
    verify_ssl=False
)

ORG = os.getenv("ASG_TEST_ORG", 'test')
SPACE = os.getenv("ASG_TEST_SPACE", 'test')
APP = os.getenv("ASG_TEST_SPACE", 'go-example')
CLOSED_GROUP = os.getenv("CLOSED_GROUP", "CLOSED_GROUP")
OPEN_GROUP = os.getenv("OPEN_GROUP", "OPEN_GROUP")

# Givens
@given('an application')
def step_impl(context):
    assert ADMIN.get_org(ORG).get_space(SPACE).get_app(APP)

@given('a security group that closes all outgoing tcp connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=CLOSED_GROUP)

@given('a security group that is open to all public outgoing connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=OPEN_GROUP)

@when('I try to view all the ASGs')
def step_impl(context):
    assert len(context.user.get_security_groups()) > 1


@when('I bind the application security group with open settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(ORG).get_space(SPACE)
    sg = ADMIN.get_security_group(name=OPEN_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(APP).restart()
    import time
    time.sleep(30)

@when('I bind the application security group with closed settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(ORG).get_space(SPACE)
    sg = ADMIN.get_security_group(name=CLOSED_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(APP).restart()
    import time
    time.sleep(30)

@then('I can view and print all the ASGs')
def step_impl(context):
    groups = context.user.get_security_groups()
    # TODO add export
    print(groups)

@then('the application can ping an external site')
def step_impl(context):
    space =  ADMIN.get_org(ORG).get_space(SPACE)
    app = space.get_app(APP)
    routes = app.get_routes()
    CR_URL = os.getenv('CF_URL', 'https://api.bosh-lite.com')
    CR_URL = CR_URL.replace('api', routes[0]['entity']['host']) + '/ping'
    result = requests.get(CR_URL, verify=False).text
    sg = ADMIN.get_security_group(name=OPEN_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Success' in result

@then('the application cannot ping an external site')
def step_impl(context):
    space =  ADMIN.get_org(ORG).get_space(SPACE)
    app = space.get_app(APP)
    routes = app.get_routes()
    CR_URL = os.getenv('CF_URL', 'https://api.bosh-lite.com')
    CR_URL = CR_URL.replace('api', routes[0]['entity']['host']) + '/ping'
    result = requests.get(CR_URL, verify=False).text
    sg = ADMIN.get_security_group(name=CLOSED_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Failed' in result
