with source as (
    select * from {{ source('raw', 'superstore') }}
),

renamed as (
    select
        cast("Row ID" as integer)                                          as row_id,
        "Order ID"                                                         as order_id,
        try_strptime(replace("Order Date", '-', '/'), '%m/%d/%Y')::date    as order_date,
        try_strptime(replace("Ship Date",  '-', '/'), '%m/%d/%Y')::date    as ship_date,
        "Ship Mode"                                                        as ship_mode,
        "Customer ID"                                                      as customer_id,
        "Segment"                                                          as segment,
        "Country"                                                          as country,
        "City"                                                             as city,
        "State"                                                            as state,
        "Region"                                                           as region,
        "Product ID"                                                       as product_id,
        "Category"                                                         as category,
        "Sub-Category"                                                     as sub_category,
        "Product Name"                                                     as product_name,
        cast("Sales" as double)                                            as sales,
        cast("Quantity" as integer)                                        as quantity,
        cast("Discount" as double)                                         as discount,
        cast("Profit" as double)                                           as profit
    from source
),

-- 排除 row_id 後完全相同的明細視為重複輸入，保留 row_id 最小的一筆
deduped as (
    select *,
        row_number() over (
            partition by order_id, order_date, ship_date, ship_mode, customer_id,
                         segment, country, city, state, region, product_id,
                         category, sub_category, product_name,
                         sales, quantity, discount, profit
            order by row_id
        ) as rn
    from renamed
)
-- row_number() 產生 rn：幫重複資料編號
-- where rn = 1：用 rn 刪掉重複的列
-- exclude (rn)：用完之後把 rn 拿掉
select
    * exclude (rn),
    -- 同一個 Product ID 可能對應多個名稱，所以商品用 ID + 名稱當單位
    md5(product_id || '|' || product_name)     as product_key,
    md5(city || '|' || state || '|' || region) as location_key
from deduped
where rn = 1