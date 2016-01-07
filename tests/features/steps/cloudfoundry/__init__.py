import time
import requests
import json

from cloudfoundry.user import User


class Client:

    def __init__(self, api_url, username, password, verify_ssl=True):
        # Set ssl verification option for local development
        self.verify_ssl = verify_ssl

        # Get Urls
        self.api_url = api_url
        self.info = requests.get(
            api_url + '/v2/info', verify=self.verify_ssl
        ).json()

        # Store username and password
        self.__username = username
        self.__password = password
        
        # Init token
        self.__request_token()

    def __request_token(self):
        """ Request a token from service """
        headers = {
            'accept': 'application/json',
            'authorization': 'Basic Y2Y6',

        }
        params = {
            'username': self.__username,
            'password': self.__password,
            'grant_type': 'password'
        }
        r = requests.post(
            url=self.info['token_endpoint'] + '/oauth/token', 
            headers=headers,
            params=params,
            verify=self.verify_ssl
        )
        self.__token = r.json()
        self.__token['time_stamp'] = time.time()

    def __prepare_token(self):
        """ Check if token is expired and open access token """
        time_elapsed = time.time() - self.__token['time_stamp']
        if time_elapsed > self.__token['expires_in']:
            self.request_token()
        return self.__token['access_token']

    def __request(self, url, method, **kwargs):
        """ Make request to specific endpoint """
        headers = {'authorization': 'bearer ' + self.__prepare_token()}
        headers.update(kwargs.get('headers', {}))
        params = kwargs.get('params')
        data = kwargs.get('data')
        if method == 'get':
            res = requests.get(
                url=url, headers=headers, params=params, verify=self.verify_ssl
            )
        elif method == 'post':
            res = requests.post(
                url=url, headers=headers, data=data, verify=self.verify_ssl
            )
        elif method == 'put':
            res = requests.put(
                url=url, headers=headers, data=data, verify=self.verify_ssl
            )
        elif method == 'delete':
            res = requests.delete(
                url=url, headers=headers, params=params, verify=self.verify_ssl
            )
        return res

    def api_request(self, endpoint, method='get', **kwargs):
        url = self.api_url + endpoint
        return self.__request(url=url, method=method, **kwargs)

    def uaa_request(self, endpoint, method='get', **kwargs):
        url = self.info['token_endpoint'] + endpoint
        return self.__request(url=url, method=method, **kwargs)

    def get_user(self, username):
        """ Find a CF user """
        params = {
                'attributes': 'id,userName',
                'filter': "userName eq '%s'" % username
        }
        uaa_user_res = self.uaa_request(endpoint='/Users', params=params).json()
        if len(uaa_user_res.get('resources', [])) > 0:
            return User(guid=uaa_user_res['resources'][0]['id'], client=self)
        return {}

    def create_user(self, username, password):
        """ Create a Cloud Foundry user """
        # Create user with UAA
        user_data = {
            "userName": username,
            "emails": [
                {"value": username}
            ],
            "password": password,
            "name": {
                "givenName": username,
                "familyName": username,
            }
        }
        headers = {'content-type': 'application/json'}
        uaa_user_res = self.uaa_request(
            endpoint='/Users', method='post', headers=headers, data=json.dumps(user_data)
        ).json()
        # Create user in Cloud Controller
        user_id_data = {
            'guid': uaa_user_res.get('id', uaa_user_res.get('user_id'))
        }
        cf_user_res = self.api_request(endpoint='/v2/users', method='post', data=json.dumps(user_id_data))
        return User(guid=user_id_data['guid'], client=self)

