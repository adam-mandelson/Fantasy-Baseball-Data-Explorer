'''
Creates an object and a session to access data.
'''

import json
from pathlib import Path
from requests_oauthlib import OAuth2Session
import xmltodict
import pandas as pd


class LeagueQuery(object):

    def __init__(self, auth_dir: Path, data_obj) -> None:
        self._auth_dir = auth_dir
        self._authenticate()
        self._check_response()
        self._data_obj = data_obj

    def _authenticate(self) -> None:
        '''
        Swap refresh token for access token
        '''
        refresh_token_path = self._auth_dir / "yahoo_data.json"
        access_token_path = self._auth_dir / "yahoo_token.json"
        self._session = OAuth2Session()

        with open(refresh_token_path, 'r') as refresh_token:
            _auth_info = json.load(refresh_token)
            self._token_url = _auth_info['token_url']
            self._test_url = _auth_info['test_url']
            self._client_id = _auth_info['params']['client_id']
            self._client_secret = _auth_info['params']['client_secret']
            # Current season
            self._sport_id = _auth_info['sport_id']['2022']
            self._league_id = _auth_info['league_id']['2022']
            self._league_categories = _auth_info['league_categories']

        with open(access_token_path, 'r') as access_token:
            self._access_token = json.load(access_token)

        self._session.client_id = self._client_id
        self._session.token = self._access_token
        self._session.redirect_uri = 'oob'

        self.token = self._session.refresh_token(
            self._token_url,
            client_id=self._client_id,
            client_secret=self._client_secret
        )

        with open(access_token_path, 'w') as f:
            json.dump(self.token, f)

    def _check_response(self) -> None:
        '''
        Check that the API call worked.
        '''
        test_response = self._session.get(
            url=self._test_url,
        )
        if test_response.status_code != 200:
            print('There was an authentication problem')

    def get_response(self, url: str):
        response = self._session.get(
            url
        )

        status_code = response.status_code
        if status_code in [400, 401]:
            self._authenticate()
        return response

    def query(self, url: str, response_data_type):
        response = self.get_response(url)
        if response_data_type in ['scoreboard', 'standings']:
            response_dict = xmltodict.parse(response.content)['fantasy_content']['league']
        response_json = json.dumps(response_dict)
        raw_response_data = {'dict': response_dict,
                             'json': response_json}
        return raw_response_data

    def get_league_data(self, league_data_type):
        url = "https://fantasysports.yahooapis.com/fantasy/v2/league/{sport_id}.l.{league_id}/{data_type}"
        response = self.query(
            url.format(
                sport_id=self._sport_id,
                league_id=self._league_id,
                data_type=league_data_type
            ),
            response_data_type=league_data_type
        )
        return response['dict']

    def get_scores(self, season=None, selected_week=None):
        '''
        Gets scores for 2022 up until the current week
        '''
        yearly_stats = pd.DataFrame()
        league_data = self.get_league_data(league_data_type='scoreboard')
        current_week = int(league_data['current_week'])

        url = "https://fantasysports.yahooapis.com/fantasy/v2/league/{sport_id}.l.{league_id}/scoreboard;week={week}"
        if selected_week is None:
            for week in range(1, current_week):
                response = self.query(
                    url.format(
                        sport_id=self._sport_id,
                        league_id=self._league_id,
                        week=week
                    ),
                    response_data_type='scoreboard'
                )
                if response['dict']['start_week'] == '2' and week == 1:
                    print()
                    pass
                else:
                    weekly_stats = response['dict']['scoreboard']['matchups']['matchup']
                    weekly_stats = self._data_obj.get_stats(
                        data_dict=weekly_stats,
                        categories=self._league_categories
                    )
                    yearly_stats = pd.concat([yearly_stats, weekly_stats])
        else:
            response = self.query(
                url.format(
                    sport_id=self._sport_id,
                    league_id=self._league_id,
                    week=selected_week
                ),
                response_data_type='scoreboard'
            )
            weekly_stats = response['dict']['scoreboard']['matchups']['matchup']
            weekly_stats = self._data_obj.get_stats(
                data_dict=weekly_stats,
                categories=self._league_categories
            )
            yearly_stats = pd.concat([yearly_stats, weekly_stats])

        return yearly_stats

    def get_standings(self, season=None, selected_week=None):
        '''
        Gets standings for 2022 up until the current week
        '''
        df_standings = pd.DataFrame()
        league_data = self.get_league_data(
            league_data_type='standings')['standings']['teams']['team']
        for team in league_data:
            team_stats = self._data_obj.get_standings(data_dict=team)
            df_standings = pd.concat([df_standings, team_stats])
        return df_standings
