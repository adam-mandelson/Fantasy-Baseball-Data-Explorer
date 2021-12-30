#!/usr/bin/env python3

'''
Sets up OAuth to get an authorized session
'''

import json
import os

from requests_oauthlib import OAuth2Session


class YahooClient(object):

    token_url = 'https://api.login.yahoo.com/oauth2/get_token'

    def __init__(self, client_id, client_secret, league_directory):
        self.league_directory = league_directory
        self.client_id = client_id
        self.client_secret = client_secret

        self.token_location = os.path.join(
            self.league_directory,
            "yahoo_token.json"
        )

        self.load_token()

        self.session = OAuth2Session(
            client_id=self.client_id,
            token=self.token,
            redirect_uri='oob',
        )
        
        self.refresh_token()
    
    def load_token(self):
        with open(self.token_location, 'r') as f:
            self.token = json.load(f)
    
    def refresh_token(self):
        self.token = self.session.refresh_token(
            self.token_url,
            client_id=self.client_id,
            client_secret=self.client_secret
        )

        with open(self.token_location, 'w') as f:
            json.dump(self.token, f)
