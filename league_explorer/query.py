'''
Creates an object and a session to access data.
'''

import json
from pathlib import Path
from requests import Response, Session

class LeagueQuery(object):

    def __init__(self, auth_dir: Path) -> None:
        self._auth_dir = auth_dir
        self._authenticate()
        self._check_response()

    def _authenticate(self) -> None:
        