#!/usr/bin/env python3

# TODO: Update
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

from io import StringIO

import psycopg2

from config import config, psycopg2_exception
from update_league_data import yearly_stats


def connect():
    conn = None
    try:
        params = config()

        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        with conn:
            cur = conn.cursor()

            cur.execute("DROP TABLE IF EXISTS yearly_stats;")
            sql = '''CREATE TABLE yearly_stats(
                id serial,
                season integer not null,
                week integer not null,
                n_days integer not null,
                team_id integer not null,
                matchup varchar (50) not null,
                matchup_id varchar (50) not null,
                category varchar (50),
                value numeric,
                won_category varchar (50),
                won_week varchar (50)
                )'''
            cur.execute(sql)

        with conn:
            print('PostgreSQL database:')
            cur.execute('SELECT version()')
            db_version = cur.fetchone()
            print(db_version)

        with conn:
            buffer = StringIO()
            yearly_stats.to_csv(buffer, header=False, index=True)
            buffer.seek(0)
            try:
                cur.copy_from(buffer, 'yearly_stats', sep=",")
                cur.execute('SELECT COUNT(*) FROM yearly_stats')
                rows = cur.fetchone()
                print("Data inserted into yearly_stats successfully")
                print(f"Inserted {rows} rows")
            # conn.commit()
            except (Exception, psycopg2.DatabaseError) as err:
                psycopg2_exception(err)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')


if __name__ == '__main__':
    connect()
