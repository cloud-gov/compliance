import config

from behave import when, then

from cloudfoundry import Client

ADMIN = Client(
    api_url=config.API_URL,
    username=config.MASTER_USERNAME,
    password=config.MASTER_PASSWORD,
    verify_ssl=False
)


@when('I attempt to login {times:d} times and fail')
def step_impl(context, times):
    for _ in range(times):
        user = Client(
            api_url=config.API_URL,
            username=config.TEST_USER,
            password=config.TEST_USER_PASSWORD + 'wrong',
            verify_ssl=False
        )
        assert not user.is_logged_in()


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
