import os
import json

from cloudfoundry.app import App

class Space:

    def __init__(self, guid, client):
        self.guid = guid
        self.client = client

    def delete(self):
        api_delete_endpoint = '/v2/spaces/%s' % self.guid
        api_user_del_res = self.client.api_request(endpoint=api_delete_endpoint, method='delete')

    def get_app(self, name):
        """ Get an app """
        params = {
            'q': 'name:%s' % name
        }
        endpoint = '/v2/spaces/%s/apps' % self.guid
        cf_app_res = self.client.api_request(endpoint, params=params).json()
        resources = cf_app_res.get('resources', [])
        if len(resources) == 1:
            return App(guid=resources[0]['metadata']['guid'], client=self.client)

    def create_app(self, name):
        data = {'space_guid': self.guid, 'name': name}
        cf_app_res = self.client.api_request(
            endpoint='/v2/apps', method='post', data=json.dumps(data)
        ).json()
        if 'error_code' not in cf_app_res:
            return App(guid=cf_app_res['metadata']['guid'], client=self.client)

    def set_user_role(self, role, user_guid):
        """ Give a user a specific role """
        endpoint = '/v2/spaces/{0}/{1}/{2}'.format(self.guid, role + 's', user_guid)
        api_user_res = self.client.api_request(endpoint=endpoint, method='put')

    def unset_user_role(self, role, user_guid):
        endpoint = '/v2/spaces/{0}/{1}/{2}'.format(self.guid, role + 's', user_guid)
        api_user_res = self.client.api_request(endpoint=endpoint, method='delete')

    def update(self, **kwargs):
        """ Update a space """
        endpoint = '/v2/spaces/%s' % self.guid
        self.client.api_request(
            endpoint=endpoint,
            method='put',
            data=json.dumps(kwargs)
        )
