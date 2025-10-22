
-- 05_demo_queries.sql
-- Demo analytics for Streaming Platform Analytics (Oracle)
-- Assumes schema is populated via 01_schema.sql + 04_transform_from_stage.sql

SET PAGESIZE 200
SET LINESIZE 200
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';

--------------------------------------------------------------------------
-- 0) Handy helper: RT_Critic source_id (used by some queries)
--------------------------------------------------------------------------
-- SELECT source_id FROM rating_source WHERE name = 'RT_Critic';

--------------------------------------------------------------------------
-- 1) High-level counts
--------------------------------------------------------------------------
SELECT COUNT(*) AS titles        FROM title;
SELECT COUNT(*) AS ratings       FROM rating;
SELECT COUNT(*) AS availability  FROM availability;
SELECT COUNT(*) AS platforms     FROM platform;

--------------------------------------------------------------------------
-- 2) Platform coverage (# titles per platform)
--------------------------------------------------------------------------
SELECT p.name AS platform, COUNT(*) AS titles_on_platform
FROM availability a
JOIN platform p ON p.platform_id = a.platform_id
GROUP BY p.name
ORDER BY titles_on_platform DESC;

--------------------------------------------------------------------------
-- 3) Titles available on ALL FOUR platforms
--------------------------------------------------------------------------
SELECT t.name, t.release_year
FROM title t
JOIN availability a ON a.title_id = t.title_id
GROUP BY t.title_id, t.name, t.release_year
HAVING COUNT(DISTINCT a.platform_id) = 4
ORDER BY t.name;

--------------------------------------------------------------------------
-- 4) Titles EXCLUSIVE to a single platform (list top 20 by platform)
--------------------------------------------------------------------------
WITH platforms_by_title AS (
  SELECT t.title_id, t.name, t.release_year,
         LISTAGG(p.name, ', ') WITHIN GROUP (ORDER BY p.name) AS platforms,
         COUNT(DISTINCT a.platform_id) AS plat_count
  FROM title t
  JOIN availability a ON a.title_id = t.title_id
  JOIN platform p ON p.platform_id = a.platform_id
  GROUP BY t.title_id, t.name, t.release_year
)
SELECT *
FROM (
  SELECT pbt.*, SUBSTR(pbt.platforms, 1, 40) AS platforms_short
  FROM platforms_by_title pbt
  WHERE pbt.plat_count = 1
  ORDER BY pbt.name
)
FETCH FIRST 20 ROWS ONLY;

--------------------------------------------------------------------------
-- 5) Average RT Critic rating by platform
--------------------------------------------------------------------------
SELECT p.name AS platform, ROUND(AVG(r.rating_value), 2) AS avg_rt_critic, COUNT(*) AS n_titles
FROM rating r
JOIN rating_source s ON s.source_id = r.source_id AND s.name = 'RT_Critic'
JOIN availability a ON a.title_id = r.title_id
JOIN platform p ON p.platform_id = a.platform_id
GROUP BY p.name
ORDER BY avg_rt_critic DESC;

--------------------------------------------------------------------------
-- 6) Rating distribution (bins of 10) by platform
--------------------------------------------------------------------------
SELECT p.name AS platform,
       FLOOR(r.rating_value/10)*10 AS bin_start,
       COUNT(*) AS titles
FROM rating r
JOIN rating_source s ON s.source_id = r.source_id AND s.name = 'RT_Critic'
JOIN availability a ON a.title_id = r.title_id
JOIN platform p ON p.platform_id = a.platform_id
GROUP BY p.name, FLOOR(r.rating_value/10)*10
ORDER BY p.name, bin_start;

--------------------------------------------------------------------------
-- 7) Top 10 highest RT Critic per platform
--------------------------------------------------------------------------
SELECT platform, title, release_year, rating_value
FROM (
  SELECT p.name AS platform, t.name AS title, t.release_year, r.rating_value,
         ROW_NUMBER() OVER (PARTITION BY p.name ORDER BY r.rating_value DESC, t.name) rn
  FROM rating r
  JOIN rating_source s ON s.source_id = r.source_id AND s.name = 'RT_Critic'
  JOIN title t ON t.title_id = r.title_id
  JOIN availability a ON a.title_id = t.title_id
  JOIN platform p ON p.platform_id = a.platform_id
)
WHERE rn <= 10
ORDER BY platform, rn;

--------------------------------------------------------------------------
-- 8) Highest rated title per year per platform (ties broken by name)
--------------------------------------------------------------------------
SELECT platform, release_year, title, rating_value
FROM (
  SELECT p.name AS platform, t.release_year, t.name AS title, r.rating_value,
         ROW_NUMBER() OVER (
           PARTITION BY p.name, t.release_year
           ORDER BY r.rating_value DESC, t.name
         ) rn
  FROM rating r
  JOIN rating_source s ON s.source_id = r.source_id AND s.name = 'RT_Critic'
  JOIN title t ON t.title_id = r.title_id
  JOIN availability a ON a.title_id = t.title_id
  JOIN platform p ON p.platform_id = a.platform_id
)
WHERE rn = 1
ORDER BY platform, release_year;

--------------------------------------------------------------------------
-- 9) Pairwise overlap between platforms (# titles in common)
--------------------------------------------------------------------------
WITH ap AS (
  SELECT a.title_id, p.name AS platform
  FROM availability a
  JOIN platform p ON p.platform_id = a.platform_id
),
pairs AS (
  SELECT a1.platform AS platform_a, a2.platform AS platform_b, a1.title_id
  FROM ap a1
  JOIN ap a2 ON a1.title_id = a2.title_id AND a1.platform < a2.platform
)
SELECT platform_a, platform_b, COUNT(*) AS titles_in_common
FROM pairs
GROUP BY platform_a, platform_b
ORDER BY titles_in_common DESC;

--------------------------------------------------------------------------
-- 10) Titles present on a platform but MISSING a rating
--------------------------------------------------------------------------
SELECT p.name AS platform, COUNT(*) AS titles_without_rt_rating
FROM availability a
JOIN platform p ON p.platform_id = a.platform_id
LEFT JOIN rating r
  ON r.title_id = a.title_id
 AND r.source_id = (SELECT source_id FROM rating_source WHERE name = 'RT_Critic')
WHERE r.rating_id IS NULL
GROUP BY p.name
ORDER BY titles_without_rt_rating DESC;

-- End of 05_demo_queries.sql
