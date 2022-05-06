'''
Creates a Data object to manipulate API calls
or output data in various formats.
'''

import json
from pathlib import Path
from typing import Callable, Dict
import pandas as pd


class LeagueData(object):

    def __init__(self) -> None:
        '''
        Instantiate the data object.
        '''

    @staticmethod
    def get(yahoo_query: Callable, params: str = None) -> None:
        if params:
            return yahoo_query(**params)
        else:
            return yahoo_query

    @staticmethod
    def get_stats(data_dict: Dict, categories: Dict):

        # A list of weekly stats
        # Each entry is a matchup
        weekly_stats = []

        # Look up each matchup
        for i, matchup_data in enumerate(data_dict):
            if matchup_data['is_playoffs'] == '0':
                week = matchup_data['week'].zfill(2)
                season = matchup_data['week_start'][:4]
                matchup_id = str(i).zfill(2)

                matchup_id = season + '_' + week + '_' + matchup_id

                # If the week is tied, set winning_team to None,
                # otherwise apply the winning team's key
                if matchup_data['is_tied'] == '1':
                    winning_team = None
                else:
                    winning_team = matchup_data['winner_team_key'].split('.')[-1]

                if week == '1':
                    n_days = 14
                else:
                    n_days = 7

                winners = {}

                for stat_winner in matchup_data['stat_winners']['stat_winner']:
                    try:
                        if 'is_tied' not in stat_winner:
                            winners[categories[stat_winner['stat_id']]] = stat_winner['winner_team_key'].split('.')[-1]
                        else:
                            winners[categories[stat_winner['stat_id']]] = None
                    except KeyError as err:
                        print(f'{err}\n')
                        pass

                for i, team in enumerate(matchup_data['teams']['team']):
                    team_id = team['team_id']

                    if i == 0:
                        i = 'H'
                    else:
                        i = 'A'

                    for stat in team['team_stats']['stats']['stat']:
                        try:
                            category = categories[stat['stat_id']]

                            stat_data = {
                                'season': season,
                                'week': week,
                                'n_days': n_days,
                                'team_id': team_id,
                                'matchup': matchup_id,
                                'matchup_id': i
                            }

                            if category == 'b_H/AB':
                                stat_data['category'] = 'b_AB'
                                stat_data['value'] = stat['value'].split('/')[-1]
                            elif category == 'p_IP':
                                stat_data['category'] = 'p_IP'
                                ip, outs = stat['value'].split('.')
                                stat_data['value'] = float(ip) + float(outs) / 3
                            else:
                                stat_data['category'] = category
                                stat_data['value'] = stat['value']

                            if category in winners:
                                stat_data['won_category'] = (winners[category] == team_id)
                            else:
                                stat_data['won_category'] = None

                            stat_data['won_week'] = (winning_team == team_id)

                            weekly_stats.append(stat_data)
                        except KeyError as err:
                            print(f'{err}\n')
                            pass

        # Create a DataFrame of the weekly statistics
        matchups = pd.DataFrame(weekly_stats)
        # there are ties, so we want a int column that contains nulls
        if matchups.size != 0:
            matchups['won_category'] = (matchups[
                'won_category'] * 1).astype('Int64').fillna(0)
            return matchups
