'''
Creates a Data object to manipulate API calls
or output data in various formats.
'''

import json
from pathlib import Path
from typing import Callable


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
