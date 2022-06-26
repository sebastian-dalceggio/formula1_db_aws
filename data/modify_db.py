from sqlalchemy import create_engine
import pandas as pd

engine = create_engine("sqlite:///data/formula1_incomplete.sqlite")
df = pd.read_sql("SELECT * FROM seasons;", engine)
print(df.head())
with engine.connect() as con:
    con = engine.connect()
    con.execute("DELETE FROM seasons;")
df = pd.read_sql("SELECT * FROM seasons;", engine)
print(df.head())