

from query import LeagueQuery
from utils import auth_dir
from data import LeagueData
from update_db import connect


class LeagueUpdate(object):

    def __init__(self, query_obj, week=None):
        self._query_obj = query_obj
        self._week = week

    def get_season_scores(self):
        return self._query_obj.get_scores(selected_week=self._week)

    def update_database(self) -> None:
        yearly_data = self.get_season_scores()
        connect(data=yearly_data)


if __name__ == '__main__':
    query_obj = LeagueQuery(auth_dir=auth_dir(), data_obj=LeagueData())
    LeagueUpdate(query_obj=query_obj).update_database()
