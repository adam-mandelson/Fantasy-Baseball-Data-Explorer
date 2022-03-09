#!/usr/bin/env python3

'''
Calls yahoo_client.py to access yahoo fantasy sports api and get league data.
More info on the yahoo fantasy sports api is available at
    https://developer.yahoo.com/fantasysports/guide/.
This is a helpful app for figuring out what to query:
    https://yahoo-fantasy-node-docs.vercel.app/.
This script prompts for
    - Updating existing data.
    - Getting new data.
    - Adding data to the full data csv.
'''

# Imports
import json
import os
import pandas as pd
# Import etree to parse the yahoo api json
from lxml import etree
from yahoo_client import YahooClient

config_dir = 'config'

# Config files for yahoo_client and stat categories (and maybe more)
# League directory
with open(os.path.join(config_dir, "yahoo_ids.json"), 'r') as f:
    config = json.load(f)
with open(os.path.join(config_dir, "league_stats.json"), "r") as f:
    league_categories = json.load(f)['league_categories']

# Yahoo client id and client secret
client_id = config['client_id']
client_secret = config['client_secret']


# Get weekly scoreboard
def get_scores(week):
    url = "https://fantasysports.yahooapis.com/fantasy/v2/league/{sport_id}.l.{league_id}/scoreboard;week={week}"
    r = league_client.session.get(url.format(
            sport_id=sport_id,
            league_id=league_id,
            week=week
        ))
    root = etree.fromstring(r.content)
    return root


# Parse stats by week
def get_stats(response):
    weekly_stats = []
    for i, matchup_xml in enumerate(response.xpath("//f:matchup",
                                    namespaces=ns)):
        playoffs = matchup_xml.findtext("f:is_playoffs",
                                        namespaces=ns)
        if playoffs == '0':
            # Return the week
            week = matchup_xml.findtext("f:week", namespaces=ns).zfill(2)
            # Enumerate the matchup
            matchup = str(i).zfill(2)
            # Create a matchup id
            matchup = season + '_' + week + '_' + matchup

            # If the week is tied, set winning_team to None,
            # otherwise apply the winning team's key
            if matchup_xml.findtext("f:is_tied", namespaces=ns) == '1':
                winning_team = None
            else:
                winning_team = matchup_xml.findtext("f:winner_team_key",
                                                    namespaces=ns
                                                    ).split('.')[-1]

            # Week 1 is 11 days
            if week == '1':
                n_days = 11
            else:
                n_days = 7

            winners = {}

            for stat_winner_xml in matchup_xml.xpath(
                "f:stat_winners/f:stat_winner", namespaces=ns
                    ):
                stat_winner = {}
                for child in stat_winner_xml:
                    stat_winner[etree.QName(child.tag).localname] = child.text

                    # if not stat_winner['stat_id'] in ['8', '16', '23', '38',
                    # '87', '48', '53', '85', '86', '10', '32', '57', '84',
                    #  '55','82', '46', '56', '30']:
                try:
                    if 'is_tied' not in stat_winner:
                        winners[league_categories[
                            stat_winner['stat_id']]] = stat_winner[
                                'winner_team_key'].split('.')[-1]
                    else:
                        winners[league_categories[
                                stat_winner['stat_id']]] = None
                except KeyError as err:
                    pass
                # else:
                    # Stat_id = '23' is Total bases, removed after 2015
                    # Stat_id = '87' is Double plays turned, removed after 2013
                    # pass

            for i, team_xml in enumerate(matchup_xml.xpath("f:teams/f:team",
                                                           namespaces=ns)):
                team_id = team_xml.findtext("f:team_id", namespaces=ns)

                if i == 0:
                    i = 'H'
                else:
                    i = 'A'

                for stat_xml in team_xml.xpath("f:team_stats/f:stats/f:stat",
                                               namespaces=ns):
                    try:
                        category = league_categories[stat_xml.findtext(
                            "f:stat_id", namespaces=ns)]

                        stat = {
                            'season': season,
                            'week': week,
                            'n_days': n_days,
                            'team_id': team_id,
                            'matchup': matchup,
                            'matchup_id': i
                        }

                        if category == 'b_H/AB':
                            stat['category'] = 'b_AB'
                            stat['value'] = stat_xml.findtext(
                                "f:value", namespaces=ns).split('/')[-1]
                        elif category == 'p_IP':
                            stat['category'] = 'p_IP'
                            ip, outs = stat_xml.findtext("f:value",
                                                         namespaces=ns
                                                         ).split('.')
                            stat['value'] = float(ip) + float(outs) / 3
                        else:
                            stat['category'] = category
                            stat['value'] = stat_xml.findtext("f:value",
                                                              namespaces=ns)

                        if category in winners:
                            stat['won_category'] = (winners[
                                category] == team_id)
                        else:
                            stat['won_category'] = None

                        stat['won_week'] = (winning_team == team_id)

                        weekly_stats.append(stat)
                    except KeyError as err:
                        pass

    matchups = pd.DataFrame(weekly_stats)
    # there are ties, so we want a int column that contains nulls
    if matchups.size != 0:
        matchups['won_category'] = (matchups[
            'won_category'] * 1).astype('Int64').fillna(0)
        return matchups


# Create a blank DataFrame for yearly_stats
yearly_stats = pd.DataFrame()

# Get the start and end weeks
league_client = YahooClient(client_id, client_secret, config_dir)
ns = {'f': 'http://fantasysports.yahooapis.com/fantasy/v2/base.rng'}
seasons = ["2014", "2015", "2016", "2017", "2018", "2019", "2021"]
week = "2"
for season in seasons:
    sport_id = config['sport_id'][season]
    league_id = config["league_id"][season]

    response = get_scores(week)
    start_week = response.xpath("//f:league",
                                namespaces=ns)[0].findtext(
                                "f:start_week", namespaces=ns)
    end_week = response.xpath("//f:league",
                              namespaces=ns)[0].findtext(
                                "f:end_week", namespaces=ns)
    current_week = response.xpath("//f:league",
                                  namespaces=ns)[0].findtext(
                                    "f:current_week", namespaces=ns)
    # Update the yearly stats DataFrame with stats from each week
    for week_num in range(int(start_week), int(end_week)+1):
        response = get_scores(week_num)
        weekly_stats = get_stats(response)
        yearly_stats = pd.concat([yearly_stats, weekly_stats])
