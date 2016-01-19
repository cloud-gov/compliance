import config

import requests
import time

from behave import given, when, then

from cloudfoundry import Client

ADMIN = Client(
    api_url=config.API_URL,
    username=config.MASTER_USERNAME,
    password=config.MASTER_PASSWORD,
    verify_ssl=False
)


# Givens
@given('an application')
def step_impl(context):
    assert ADMIN.get_org(config.ASG_ORG).get_space(config.ASG_SPACE). \
        get_app(config.ASG_APP)


@given('a security group that closes all outgoing tcp connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=config.CLOSED_SECURITY_GROUP)


@given('a security group that is open to all public outgoing connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=config.OPEN_SECURITY_GROUP)


@when('I try to view all the ASGs')
def step_impl(context):
    assert len(context.user.get_security_groups()) > 1


@when('I bind the application security group with open settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(config.ASG_ORG).get_space(config.ASG_SPACE)
    sg = ADMIN.get_security_group(name=config.OPEN_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(config.ASG_APP).restart()
    time.sleep(30)


@when('I bind the application security group with closed settings to the running app')
def step_impl(context):
    space = ADMIN.get_org(config.ASG_ORG).get_space(config.ASG_SPACE)
    sg = ADMIN.get_security_group(name=config.CLOSED_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    space.get_app(config.ASG_APP).restart()
    time.sleep(30)


@then('I can view and print all the ASGs')
def step_impl(context):
    groups = context.user.get_security_groups()
    # TODO add export
    print(groups)


@then('the application can ping an external site')
def step_impl(context):
    space = ADMIN.get_org(config.ASG_ORG).get_space(config.ASG_SPACE)
    result = requests.get(config.ASG_APP_URL, verify=False).text
    sg = ADMIN.get_security_group(name=config.OPEN_SECURITY_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Success' in result


@then('the application cannot ping an external site')
def step_impl(context):
    space = ADMIN.get_org(config.ASG_ORG).get_space(config.ASG_SPACE)
    result = requests.get(config.ASG_APP_URL, verify=False).text
    sg = ADMIN.get_security_group(name=config.CLOSED_SECURITY_GROUP)
    sg.unset_space(space_guid=space.guid)
    print(result)
    assert 'Failed' in result
