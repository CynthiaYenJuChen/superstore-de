from pathlib import Path
import duckdb

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "exports"
OUT.mkdir(exist_ok=True)

con = duckdb.connect(str(ROOT / "warehouse" / "superstore.duckdb"), read_only=True)
for t in ["fact_sales", "dim_customer", "dim_product", "dim_location", "dim_date"]:
    con.execute(f"copy main_marts.{t} to '{OUT / (t + '.csv')}' (header)")
    print("exported", t)