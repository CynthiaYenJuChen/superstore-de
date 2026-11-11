select distinct location_key, country, region, state, city
from {{ ref('stg_superstore') }}