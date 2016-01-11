
class App:

    def __init__(self, guid, client):
        self.guid = guid
        self.client = client

    def delete(self):
        api_delete_endpoint = '/v2/apps/%s' % self.guid
        api_user_del_res = self.client.api_request(endpoint=api_delete_endpoint, method='delete')
