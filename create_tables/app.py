from classes.database import Database
import json
import os

owd = os.getcwd()

def lambda_handler(event, context):

    with open("create_tables.sql", "r") as query_file:
        query = query_file.read()

    with open("config.json", "r") as f:
        config = json.load(f)
    
    if "TARGET_DB" in os.environ:
        target_db = os.environ["TARGET_DB"]
    elif "TARGET_DB" in config:
        target_db = config["TARGET_DB"]
    else:
        raise Exception("The target database was not found in either the environment variables or the config.json file.")

    os.chdir("/tmp")

    db = Database(target_db)
    db.execute_sql(query)
    db.dispose()

    os.chdir(owd)