with bounds as (
    select min(order_date) as d0, max(ship_date) as d1
    from {{ ref('stg_superstore') }}
),
days as (
    select unnest(generate_series(d0, d1, interval 1 day))::date as date_day
    from bounds
)
select
    date_day,
    year(date_day)                       as year,
    quarter(date_day)                    as quarter,
    month(date_day)                      as month,
    date_trunc('month', date_day)::date  as month_start,   -- 取代 Power BI 的 Order Month
    dayname(date_day)                    as day_name
from days