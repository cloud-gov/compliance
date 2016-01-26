import datetime
import config

from behave import given, when, then

from cloudfoundry import Client

TEST_START = datetime.datetime.utcnow().isoformat()


ADMIN = Client(
    api_url=config.API_URL,
    username=config.MASTER_USERNAME,
    password=config.MASTER_PASSWORD,
    verify_ssl=False
)


# Givens
@given('I am user a master account')
def step_impl(context):
    context.user = ADMIN

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
