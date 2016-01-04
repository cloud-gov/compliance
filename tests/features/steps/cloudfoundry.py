import time
import requests


class CloudFoundry:

    """ Script for connecting to a Clound Foundry url and requesting data """

    def __init__(self, url, username, password):

        self.url = url
        self.username = username
        self.password = password
        self.request_token()

    def request_token(self):
        """ Request a token from service """
        token_url = 'https://uaa.%s/oauth/token' % self.url
        headers = {
            'accept': 'application/json',
            'authorization': 'Basic Y2Y6'
        }
        params = {
            'username': self.username,
            'password': self.password,
            'grant_type': 'password'
        }
        r = requests.post(url=token_url, headers=headers, params=params)
        self.token = r.json()
        self.token['time_stamp'] = time.time()

    def prepare_token(self):
        """ Check if token is expired and open access token """
        time_elapsed = time.time() - self.token['time_stamp']
        if time_elapsed > self.token['expires_in']:
            self.request_token()
        return self.token['access_token']

    def make_request(self, endpoint):
        """ Make request to specific endpoint """
        token = self.prepare_token()
        url = 'https://api.{0}{1}'.format(self.url, endpoint)
        headers = {'authorization': 'bearer ' + token}
        req = requests.get(url=url, headers=headers)
        return req.json()

    def yield_request(self, endpoint):
        """ Yield all of the request pages """
        while endpoint:
            req = self.make_request(endpoint=endpoint)
            endpoint = req.get('next_url')
            yield req

    def get_user_guid(self):
        """ Get the guid of the user """
        data = self.make_request('/v2/info')
        return data.get('user')
