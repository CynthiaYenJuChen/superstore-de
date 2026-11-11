select distinct customer_id, segment
from {{ ref('stg_superstore') }}