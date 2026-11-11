-- 核對總銷售額與總利潤是否和 notebook 的結果一致（去重複後 9993 筆）
-- 預期值：sales = 2296919.4883, profit = 286409.0805
-- 允許 0.01 的誤差：浮點數加總的順序不同時，尾數可能有些微差異
select sum(sales) as sales, sum(profit) as profit
from {{ ref('fact_sales') }}
having abs(sum(sales)  - 2296919.4883) > 0.01
    or abs(sum(profit) - 286409.0805)  > 0.01
