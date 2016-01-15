import json

class App:

    def __init__(self, guid, client):
        self.guid = guid
        self.client = client

    def get_routes(self):
        api_routes_endpoint = '/v2/apps/%s/routes' % self.guid
        routes = self.client.api_request(
            endpoint=api_routes_endpoint,
        ).json()
        return routes['resources']

    def change_state(self, state):
        app_endpoint = '/v2/apps/%s' % self.guid
        return self.client.api_request(
            endpoint=app_endpoint,
            method='put',
            data=json.dumps({'state': state}),
            # params={'async': 'true'}
        ).json()

    def start(self):
        return self.change_state('STARTED')

    def stop(self):
        return self.change_state('STOPPED')

    def restart(self):
        self.stop()
        self.start()

    def restage(self):
        app_endpoint = '/v2/apps/%s/restage' % self.guid
        return self.client.api_request(
            endpoint=app_endpoint,
            method='post',
        ).json()

    def delete(self):
        api_delete_endpoint = '/v2/apps/%s' % self.guid
        return self.client.api_request(endpoint=api_delete_endpoint, method='delete')
