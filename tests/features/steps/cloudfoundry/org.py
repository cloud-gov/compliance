import json

from cloudfoundry.space import Space


class Org:
    
    def __init__(self, guid, client):
        self.guid = guid
        self.client = client

    def get_space(self, name):
        """ Get an space """
        params = {
            'q': 'name:%s' % name
        }
        endpoint = '/v2/organizations/%s/spaces' % self.guid
        cf_space_res = self.client.api_request(endpoint, params=params).json()
        resources = cf_space_res.get('resources', [])
        if len(resources) == 1:
            return Space(guid=resources[0]['metadata']['guid'], client=self.client)


    def create_space(self, name):
        """ Create a space within this org """
        data = {
            "name": name,
            "organization_guid": self.guid
        }
        cf_space_res = self.client.api_request(
            endpoint='/v2/spaces', method='post', data=json.dumps(data)
        ).json()
        return Space(guid=cf_space_res['metadata']['guid'], client=self.client)


    def delete(self):
        api_delete_endpoint = '/v2/organizations/%s' % self.guid
        api_user_del_res = self.client.api_request(endpoint=api_delete_endpoint, method='delete') 
