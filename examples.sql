CLUSTER users;
VACUUM ANALYZE users;

EXPLAIN ANALYSE
SELECT COUNT(*) FROM users;

-- gist
EXPLAIN ANALYZE VERBOSE
SELECT
  first_name || ' ' || last_name full_name,
  ST_AsText(current_location)
FROM
  users
WHERE
  ST_DWithin(current_location::geography, ST_SetSRID(ST_MakePoint(40.7128, -74.0060), 4326)::geography, 400 * 1000);

-- gin
EXPLAIN ANALYZE VERBOSE
SELECT
  id,
  about
FROM users
WHERE
  about @@ to_tsquery('dolor & corporis')
LIMIT 10;

-- hash
EXPLAIN ANALYSE VERBOSE
SELECT
  id,
  insurance_number
FROM
  users
WHERE
  insurance_number = '7nt37jv14kmn5y5a8qmpgozfwlucosw9r6344ojdkehh36ke7fszweowp3d0jj2x';

EXPLAIN ANALYSE VERBOSE
SELECT
  id,
  insurance_number
FROM
  users
WHERE
  insurance_number LIKE '7nt37jv14kmn5y5a8qmpgozfwlucosw9r6344ojdkehh36ke7fszweowp3d0jj2%';

-- brin
EXPLAIN ANALYSE VERBOSE
SELECT
  id,
  registered_from
FROM
  users
WHERE
  registered_from = '98.28.214.92';

-- functional index
EXPLAIN ANALYSE VERBOSE
SELECT
  id,
  first_name || ' ' || last_name
FROM
  users
WHERE
  (first_name || ' ' || last_name) = 'Loura Wisocky';

-- index size
SELECT
  nspname AS schema_name,
  relname AS index_name,
  pg_relation_size(indexrelid)::FLOAT / pg_relation_size(indrelid)::FLOAT AS index_ratio,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
  pg_size_pretty(pg_relation_size(indrelid)) AS table_size
FROM
  pg_index I

  LEFT JOIN
  pg_class C

    ON
      (C.oid = I.indexrelid)

  LEFT JOIN
  pg_namespace N

    ON
      (N.oid = C.relnamespace)

WHERE
  C.relkind = 'i' AND
  pg_relation_size(indrelid) > 0 AND
  relname LIKE '%users%'
ORDER BY
  pg_relation_size(indexrelid) DESC, index_ratio DESC;
