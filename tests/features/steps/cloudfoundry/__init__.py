import time
import requests


class CloudFoundryClient:

    def __init__(self, url, username, password):
        self.url = url
        self.username = username
        self.password = password
        self._request_token()

    def _request_token(self):
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

    def _prepare_token(self):
        """ Check if token is expired and open access token """
        time_elapsed = time.time() - self.token['time_stamp']
        if time_elapsed > self.token['expires_in']:
            self.request_token()
        return self.token['access_token']

    def _request(self, endpoint, method='get', **kwargs):
        """ Make request to specific endpoint """
        token = self._prepare_token()
        url = 'https://api.{0}{1}'.format(self.url, endpoint)
        headers = {'authorization': 'bearer ' + token}
        params = kwargs.get('params')
        if method == 'get':
            req = requests.get(url=url, headers=headers, params=params)
        elif method == 'post':
            req = requests.post(url=url, headers=headers, data=kwargs['data'])
        elif method == 'put':
            req = requests.put(url=url, headers=headers, data=kwargs['data'])
        elif method == 'delete':
            req = requests.delete(url=url, headers=headers, params=params)
        return req.json()

    def yield_request(self, endpoint):
        """ Yield all of the request pages """
        while endpoint:
            req = self._request(endpoint=endpoint)
            endpoint = req.get('next_url')
            yield req
