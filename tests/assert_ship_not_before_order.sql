select * from {{ ref('fact_sales') }}
where ship_date < order_date