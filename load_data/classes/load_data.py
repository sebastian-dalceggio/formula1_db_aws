import pandas as pd
from classes.database import Database

class LoadData():
    def __init__(self, destination_string, origin_string, retries=100, time_sleep=2):
        self.destination = Database(destination_string)
        self.origin = Database(origin_string)
        self.retries = retries
        self.time_sleep = time_sleep

    def change_origin(self, db):
        self.origin.change_db(db)

    def change_destination(self, db):
        self.destination.change_db(db)

    def dispose(self):
        self.destination.dispose()
        self.origin.dispose()

    def load_data(self, tables):
        for table in tables:
            table_name = table["name"]
            data = self.origin.download_data(f"SELECT * FROM {table_name};")

            # All tables in postgresql are lower case
            data.columns = [x.lower() for x in data.columns]

            if "time_columns" in table:
                for column in table["time_columns"]:
                    data[column] = pd.to_datetime(data[column], errors='coerce').dt.time

            if "date_columns" in table:
                for column in table["date_columns"]:
                    data[column] = pd.to_datetime(data[column], dayfirst=True)

            if "drop_columns" in table:
                for column in table["drop_columns"]:
                    data.drop([column], axis=1, inplace=True)

            if "delete_record" in table:
                for record in table["delete_record"]:
                    data.loc[data[record["column_search"]] == record["value"], record["column_to_delete"]] = None
                    
            data.replace("", None, inplace=True)
            self.destination.wait_table(table_name)
            self.destination.delete_rows(table_name)
            self.destination.load_data(data, table_name)
    
    def execute_sql(self, query):
        self.destination.execute_sql(query)