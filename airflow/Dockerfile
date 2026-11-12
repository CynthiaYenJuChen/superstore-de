FROM apache/airflow:3.4.0

# dbt 裝在獨立的 venv，避免跟 Airflow 的套件版本衝突
RUN python -m venv /opt/airflow/dbt_venv && \
    /opt/airflow/dbt_venv/bin/pip install --no-cache-dir \
        dbt-core==1.12.6 \
        dbt-duckdb==1.11.1 \
        duckdb==2.0.0