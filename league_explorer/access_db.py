

from io import StringIO

import pandas as pd
import psycopg2

try:
    from config import config, psycopg2_exception
except ImportError:
    from league_explorer.config import config, psycopg2_exception


def connect(data=None) -> None:
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

        if data is None:
            with conn:
                sql = 'SELECT * FROM yearly_stats;'
                df = pd.read_sql_query(sql, conn)
                # conn.close()
                return df

        else:
            with conn:
                buffer = StringIO()
                data.to_csv(buffer, header=False, index=True)
                buffer.seek(0)
                if data.columns[0] == 'season':
                    try:
                        cur.copy_from(buffer, 'yearly_stats', sep=",")
                        cur.execute('SELECT COUNT(*) FROM yearly_stats')
                        rows = cur.fetchone()
                        print("Data inserted into yearly_stats successfully")
                        print(f"Inserted {rows} rows")
                    except (Exception, psycopg2.DatabaseError) as err:
                        psycopg2_exception(err)
                elif data.columns[0] == 'team_id':
                    try:
                        cur.execute('drop table if exists team_standings')
                        sql = '''CREATE TABLE team_standings(
                            idx int,
                            team_id int,
                            name varchar(50),
                            rank int,
                            wins int,
                            losses int,
                            ties int);'''
                        cur.execute(sql)
                        cur.copy_from(buffer, 'team_standings', sep=",")
                        cur.execute('SELECT COUNT(*) FROM team_standings')
                        rows = cur.fetchone()
                        print("Data inserted into team_standings successfully")
                        print(f"Inserted {rows} rows")
                    except (Exception, psycopg2.DatabaseError) as err:
                        psycopg2_exception(err)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
