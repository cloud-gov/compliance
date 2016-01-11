
class User:

    def __init__(self, guid, client):
        self.guid = guid
        self.client = client
    
    def delete(self):
        """ Delete this Cloud Foundry user """
        # Delete from Cloud Controller        
        api_delete_endpoint = '/v2/users/%s' % self.guid
        api_user_del_res = self.client.api_request(endpoint=api_delete_endpoint, method='delete')
        # Delete from UAA
        uaa_delete_endpoint = '/Users/%s' % self.guid
        uaa_user_del_res = self.client.uaa_request(endpoint=uaa_delete_endpoint, method='delete')
        
