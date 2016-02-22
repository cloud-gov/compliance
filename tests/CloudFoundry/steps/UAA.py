import datetime
import config

from behave import given, when, then

from cloudfoundry import Client


ADMIN = Client(
    api_url=config.API_URL,
    username=config.MASTER_USERNAME,
    password=config.MASTER_PASSWORD,
    verify_ssl=False
)


@when('I look at the audit logs')
def step_impl(context):
    context.sample_log = context.user.events()['resources'][0]


@then('audit logs have timestamp')
def step_impl(context):
    assert 'created_at' in context.sample_log['metadata']


@then('audit logs have type of event')
def step_impl(context):
    print(context.sample_log)
    assert 'type' in context.sample_log['entity']


@then('audit logs have actor')
def step_impl(context):
    print(context.sample_log)
    assert 'actor' in context.sample_log['entity']


@then('audit logs have actee')
def step_impl(context):
    print(context.sample_log)
    assert 'actee' in context.sample_log['entity']


@then('I am locked out')
def step_impl(context):
    # Attempt to correctly login
    user = Client(
        api_url=config.API_URL,
        username=config.TEST_USER,
        password=config.TEST_USER_PASSWORD,
        verify_ssl=False
    )
    assert not user.is_logged_in()
    ADMIN.get_user(config.TEST_USER).delete()


@then('I am not locked out')
def step_impl(context):
    # Attempt to correctly login
    user = Client(
        api_url=config.API_URL,
        username=config.TEST_USER,
        password=config.TEST_USER_PASSWORD,
        verify_ssl=False
    )
    assert user.is_logged_in()
    ADMIN.get_user(config.TEST_USER).delete()
