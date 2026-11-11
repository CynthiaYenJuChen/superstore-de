select count(*) as n from {{ ref('fact_sales') }}
having count(*) != 9993