from classes.decorators import retry
from sqlalchemy import create_engine, inspect
import pandas as pd

class Database():
    TRIES = 1
    TIME_SLEEP = 10
    def __init__(self, db, tries=100, time_sleep=2):
        self.db = db
        self.engine = self.create_engine_(self.db)
        self.inspector = self.create_inspector_(self.engine)

    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def create_engine_(self, db):
        return create_engine(db)
    
    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def create_inspector_(self, engine):
        return inspect(engine)
    
    def change_db(self, db):
        self.__init__(db)
    
    def dispose(self):
        self.engine.dispose()
    
    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def download_data(self, query):
        return pd.read_sql(query, self.engine)
    
    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def wait_table(self, table_name):
        if self.engine.has_table(table_name):
            return 0
        else:
            raise Exception("Waiting for table...")

    # @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def load_data(self, data, table_name, if_exists="append"):
        data.to_sql(table_name, self.engine, if_exists=if_exists, index=False)
    
    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def execute_sql(self, query):
        with self.engine.connect() as con:
            con = self.engine.connect()
            con.execute(query)
    
    @retry(tries=TRIES, time_sleep=TIME_SLEEP)
    def delete_rows(self, table_name):
        self.execute_sql(f"DELETE FROM {table_name};")