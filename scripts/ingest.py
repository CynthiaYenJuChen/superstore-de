from pathlib import Path
import duckdb

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "data" / "raw" / "Sample_Superstore.csv"
DB = ROOT / "warehouse" / "superstore.duckdb"

DB.parent.mkdir(exist_ok=True)
con = duckdb.connect(str(DB))
con.execute("create schema if not exists raw")
con.execute(f"""
    create or replace table raw.superstore as
    select *,
           current_timestamp as _loaded_at,
           '{SOURCE.name}'   as _source_file
    from read_csv('{SOURCE}', header = true, all_varchar = true)
""")
n = con.execute("select count(*) from raw.superstore").fetchone()[0]
print(f"loaded {n} rows into raw.superstore")   # 應該是 9994
con.close()