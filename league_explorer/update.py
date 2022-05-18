

try:
    from query import LeagueQuery
    from utils import auth_dir
    from data import LeagueData
    from access_db import connect
except ModuleNotFoundError:
    from league_explorer.query import LeagueQuery
    from league_explorer.utils import auth_dir
    from league_explorer.data import LeagueData
    from league_explorer.access_db import connect


class LeagueUpdate(object):

    def __init__(self, query_obj, week=None):
        self._query_obj = query_obj
        self._week = week

    def get_season_scores(self):
        return self._query_obj.get_scores(selected_week=self._week)

    def get_season_standings(self):
        return self._query_obj.get_standings()

    def update_database(self) -> None:
        yearly_data = self.get_season_scores()
        team_standings = self.get_season_standings()
        connect(data=yearly_data)
        connect(data=team_standings)


if __name__ == '__main__':
    query_obj = LeagueQuery(auth_dir=auth_dir(), data_obj=LeagueData())
    LeagueUpdate(query_obj=query_obj, week=5).update_database()
