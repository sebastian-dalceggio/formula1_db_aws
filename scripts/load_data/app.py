from classes.load_data import LoadData
import json
import boto3
import os

s3 = boto3.resource("s3")

owd = os.getcwd()

def lambda_handler(event, context):

    with open("tables.json", "r") as f:
        tables = json.load(f)

    with open("config.json", "r") as f:
        config = json.load(f)
    
    if "TARGET_DB" in os.environ:
        target_db = os.environ["TARGET_DB"]
    elif "TARGET_DB" in config:
        target_db = config["TARGET_DB"]
    else:
        raise Exception("The target database was not found in either the environment variables or the config.json file.")

    if "BUCKET_NAME" in os.environ:
        bucket = os.environ["BUCKET_NAME"]
    elif "BUCKET_NAME" in config:
        bucket = config["BUCKET_NAME"]
    else:
        raise Exception("The bucket name was not found in either the environment variables or the config.json file.")

    if "OBJECT_KEY" in os.environ:
        key = os.environ["OBJECT_KEY"]
    elif "OBJECT_KEY" in config:
        key = config["OBJECT_KEY"]
    else:
        raise Exception("The object key was not found in either the environment variables or the config.json file.")

    s3.Bucket(bucket).download_file(key, "/tmp/" + key)

    origin_db = "sqlite:///" + key

    os.chdir("/tmp")

    loader = LoadData(target_db, origin_db)
    loader.load_data(tables)
    loader.dispose()

    os.chdir(owd)