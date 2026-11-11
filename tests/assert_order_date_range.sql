select * from {{ ref('fact_sales') }}
where order_date < date '2014-01-01'
   or order_date > current_date