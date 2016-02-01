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
@given('a space')
def step_impl(context):
    org = ADMIN.get_org(config.TEST_ORG)
    assert org.get_space(config.TEST_SPACE)


@given('a security group that closes all outgoing tcp connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=config.CLOSED_SECURITY_GROUP)


@given('a security group that is open to all public outgoing connections')
def step_impl(context):
    assert ADMIN.get_security_group(name=config.OPEN_SECURITY_GROUP)


@when('I try to view all the ASGs')
def step_impl(context):
    assert len(context.user.get_security_groups()) > 1


@when('I try to bind the application security group with open settings to the space')
def step_impl(context):
    space = ADMIN.get_org(config.TEST_ORG).get_space(config.TEST_SPACE)
    sg = ADMIN.get_security_group(name=config.OPEN_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    context.security_group = sg


@when('I try to bind the application security group with closed settings to the space')
def step_impl(context):
    space = ADMIN.get_org(config.TEST_ORG).get_space(config.TEST_SPACE)
    sg = ADMIN.get_security_group(name=config.CLOSED_SECURITY_GROUP)
    sg.set_space(space_guid=space.guid)
    context.security_group = sg


@then('I can view and print all the ASGs')
def step_impl(context):
    groups = context.user.get_security_groups()
    # TODO add export
    print(groups)


@then('the security group is bound')
def step_impl(context):
    spaces = context.security_group.associated_spaces().get('resources')
    assert len(spaces) == 1
