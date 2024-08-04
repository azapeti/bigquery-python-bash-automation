SELECT
  DISTINCT(user_pseudo_id) AS user_id,
  MIN(device.category) AS device,
  MIN(geo.city) AS city,
  MIN(geo.country) AS country,
  MIN(geo.continent) AS continent,
  MIN(geo.region) AS region,
  MIN(geo.sub_continent) AS sub_countinent,
  MIN(geo.metro) AS metropolice,
  MIN(ecommerce.purchase_revenue) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  user_pseudo_id NOT IN (
    SELECT
      DISTINCT user_pseudo_id AS user_id
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE
      ecommerce.purchase_revenue IS NOT NULL)
GROUP BY user_id
;