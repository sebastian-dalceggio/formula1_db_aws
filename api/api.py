import os
from fastapi import FastAPI
import json
from classes.database import Database
from mangum import Mangum

with open("config.json", "r") as f:
    config = json.load(f)

if "TARGET_DB" in os.environ:
    db = os.environ["TARGET_DB"]
elif "TARGET_DB" in config:
    db = config["TARGET_DB"]
else:
    raise Exception("The target database was not found in either the environment variables or the config.json file.")

database = Database(db)

app = FastAPI()
handler = Mangum(app)

@app.get("/get-table/{table}")
def get_table(table):
    f = os.path.join("queries_sql", table + ".sql")
    with open(f) as file:
        query = file.read()
        data = database.download_data(query)
    database.dispose()
    return {"data": data.to_json()}