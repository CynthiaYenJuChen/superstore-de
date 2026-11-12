from datetime import datetime

from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import dag

PROJECT = "/opt/project"
PY = "/opt/airflow/dbt_venv/bin/python"
DBT = "/opt/airflow/dbt_venv/bin/dbt"
# dbt 的暫存檔寫到容器內，不跟本機的 target/、logs/ 互相覆蓋
DBT_ARGS = "--target-path /tmp/dbt/target --log-path /tmp/dbt/logs"


@dag(
    schedule="@daily",
    start_date=datetime(2026, 11, 1),
    catchup=False,
    tags=["superstore"],
)
def superstore_pipeline():
    ingest = BashOperator(
        task_id="ingest_raw",
        bash_command=f"cd {PROJECT} && {PY} scripts/ingest.py",
    )
    build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {PROJECT} && {DBT} build {DBT_ARGS}",
    )
    export = BashOperator(
        task_id="export_for_powerbi",
        bash_command=f"cd {PROJECT} && {PY} scripts/export.py",
    )

    ingest >> build >> export


superstore_pipeline()