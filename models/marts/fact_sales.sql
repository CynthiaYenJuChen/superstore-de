select
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_key,
    location_key,
    sales,
    quantity,
    discount,
    profit,
    case
        when discount = 0  then '無折扣'
        when discount < 0.3 then '1-20%'
        else '30% 以上'
    end as discount_group,
    case
        when discount = 0  then 1
        when discount < 0.3 then 2
        else 3
    end as discount_group_order
from {{ ref('stg_superstore') }}