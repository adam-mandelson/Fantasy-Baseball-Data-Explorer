#!/usr/bin/env python3

# TODO: Update
'''
Calls yahoo_client.py to access yahoo fantasy sports api and get league data.
More info on the yahoo fantasy sports api is available at
    https://developer.yahoo.com/fantasysports/guide/.
This is a helpful app for figuring out what to query:
    https://yahoo-fantasy-node-docs.vercel.app/.
'''

from io import StringIO

import psycopg2

from config import config, psycopg2_exception


def connect(data) -> None:
    conn = None
    try:
        params = config()

        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        with conn:
            cur = conn.cursor()

        with conn:
            print('PostgreSQL database:')
            cur.execute('SELECT version()')

        with conn:
            buffer = StringIO()
            data.to_csv(buffer, header=False, index=True)
            buffer.seek(0)
            try:
                cur.copy_from(buffer, 'yearly_stats', sep=",")
                cur.execute('SELECT COUNT(*) FROM yearly_stats')
                rows = cur.fetchone()
                print("Data inserted into yearly_stats successfully")
                print(f"Inserted {rows} rows")
            except (Exception, psycopg2.DatabaseError) as err:
                psycopg2_exception(err)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
