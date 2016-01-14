import json

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

    def get_associated_workspace_for(self, role):
       """ Returns the workspace for which the user have the stored role """
       endpoint = "/v2/users/{0}/{1}".format(self.guid, role)
       workspaces = self.client.api_request(endpoint=endpoint)
       return workspaces.json()

    def summary(self):
       """ Returns the workspace for which the user have the stored role """
       endpoint = "/v2/users/{0}/summary".format(self.guid)
       return self.client.api_request(endpoint=endpoint).json()
