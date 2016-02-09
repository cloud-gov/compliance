from behave import given, then
from urllib import request

import datetime
import time

@given('the github link - {url}')
def step_impl(context, url):
    context.url = url


@then('the policy has been updated within the last {days} days')
def step_impl(context, days):
    res = request.urlopen(context.url)
    last_modified = datetime.datetime.strptime(res.getheader(name='Last-Modified'), "%a, %d %b %Y %H:%M:%S %Z")
    x_days_ago = datetime.datetime.now() - datetime.timedelta(days=int(days))
    assert last_modified > x_days_ago     
    
