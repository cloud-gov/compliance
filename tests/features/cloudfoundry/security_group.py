class SecurityGroup:

    def __init__(self, guid, client):
        self.guid = guid
        self.client = client

    def set_space(self, space_guid):
        endpoint = '/v2/security_groups/{0}/spaces/{1}'.format(self.guid, space_guid)
        return self.client.api_request(
            endpoint=endpoint,
            method='put'
        )

    def unset_space(self, space_guid):
        endpoint = '/v2/security_groups/{0}/spaces/{1}'.format(self.guid, space_guid)
        return self.client.api_request(
            endpoint=endpoint,
            method='delete'
        )



    def delete(self):
        return self.client.api_request(
            endpoint='/v2/security_groups/%s?' % self.guid,
            method='delete'
        )
