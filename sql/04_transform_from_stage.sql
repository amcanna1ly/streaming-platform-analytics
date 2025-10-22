
-- 04_transform_from_stage.sql
-- Load data from STAGE_MOVIES into the relational schema (Oracle)
-- This script is idempotent: safe to re-run.

SET DEFINE OFF;

------------------------------------------------------------------------
-- 0) Optional: sanity checks (uncomment to run)
-- SELECT COUNT(*) AS stage_rows FROM STAGE_MOVIES;
-- SELECT COUNT(*) AS titles FROM TITLE;
-- SELECT COUNT(*) AS ratings FROM RATING;
-- SELECT COUNT(*) AS availability FROM AVAILABILITY;
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1) Ensure RT_Critic exists (seed if missing)
------------------------------------------------------------------------
MERGE INTO RATING_SOURCE d
USING (SELECT 'RT_Critic' AS name, 100.0 AS scale_max, 'Y' AS has_votes FROM dual) s
ON (d.name = s.name)
WHEN NOT MATCHED THEN
  INSERT (name, scale_max, has_votes) VALUES (s.name, s.scale_max, s.has_votes);
COMMIT;

------------------------------------------------------------------------
-- 2) TITLE: Upsert distinct titles from STAGE_MOVIES
--    Keys for match: (name, release_year, age_rating, content_type)
------------------------------------------------------------------------
MERGE INTO TITLE t
USING (
  SELECT s.TITLE, s.YEAR, TRIM(s.AGE) AS AGE,
         CASE NVL(s.TYPE_FLAG,0) WHEN 1 THEN 'Series' ELSE 'Movie' END AS CONTENT_TYPE
  FROM STAGE_MOVIES s
  GROUP BY s.TITLE, s.YEAR, TRIM(s.AGE), CASE NVL(s.TYPE_FLAG,0) WHEN 1 THEN 'Series' ELSE 'Movie' END
) src
ON (    t.NAME = src.TITLE
    AND NVL(t.RELEASE_YEAR,-1) = NVL(src.YEAR,-1)
    AND NVL(t.AGE_RATING,'~') = NVL(src.AGE,'~')
    AND t.CONTENT_TYPE = src.CONTENT_TYPE)
WHEN NOT MATCHED THEN
  INSERT (NAME, RELEASE_YEAR, RUNTIME_MIN, AGE_RATING, CONTENT_TYPE)
  VALUES (src.TITLE, src.YEAR, NULL, src.AGE, src.CONTENT_TYPE);
COMMIT;

------------------------------------------------------------------------
-- 3) RATING: Upsert Rotten Tomatoes critic score (parse '98/100' -> 98)
------------------------------------------------------------------------
MERGE INTO RATING r
USING (
  SELECT
    t.TITLE_ID AS TITLE_ID,
    (SELECT SOURCE_ID FROM RATING_SOURCE WHERE NAME = 'RT_Critic') AS SOURCE_ID,
    TO_NUMBER(REGEXP_SUBSTR(s.ROTTEN_TOMATOES, '^\d+')) AS RATING_VALUE
  FROM STAGE_MOVIES s
  JOIN TITLE t
    ON t.NAME = s.TITLE
   AND NVL(t.RELEASE_YEAR,-1) = NVL(s.YEAR,-1)
   AND NVL(TRIM(t.AGE_RATING),'~') = NVL(TRIM(s.AGE),'~')
   AND t.CONTENT_TYPE = CASE NVL(s.TYPE_FLAG,0) WHEN 1 THEN 'Series' ELSE 'Movie' END
  WHERE s.ROTTEN_TOMATOES IS NOT NULL
    AND REGEXP_LIKE(s.ROTTEN_TOMATOES, '^\d+/\d+')
) src
ON (r.TITLE_ID = src.TITLE_ID AND r.SOURCE_ID = src.SOURCE_ID)
WHEN NOT MATCHED THEN
  INSERT (TITLE_ID, SOURCE_ID, METRIC_TYPE, RATING_VALUE, RATING_COUNT, RATING_DATE)
  VALUES (src.TITLE_ID, src.SOURCE_ID, 'overall', src.RATING_VALUE, NULL, NULL);
COMMIT;

------------------------------------------------------------------------
-- 4) AVAILABILITY: Upsert via UNION ALL (robust)   working version
------------------------------------------------------------------------
MERGE INTO AVAILABILITY a
USING (
  WITH norm AS (
    SELECT TITLE, YEAR, NVL(TYPE_FLAG,0) AS TYPE_FLAG,
           NVL(NETFLIX,0) NETFLIX, NVL(HULU,0) HULU,
           NVL(PRIME_VIDEO,0) PRIME_VIDEO, NVL(DISNEY_PLUS,0) DISNEY_PLUS
    FROM STAGE_MOVIES
  ),
  u AS (
    SELECT TITLE, YEAR, TYPE_FLAG, 'Netflix'     PLAT_NAME, NETFLIX     FLAG FROM norm UNION ALL
    SELECT TITLE, YEAR, TYPE_FLAG, 'Hulu'        PLAT_NAME, HULU        FLAG FROM norm UNION ALL
    SELECT TITLE, YEAR, TYPE_FLAG, 'Prime Video' PLAT_NAME, PRIME_VIDEO FLAG FROM norm UNION ALL
    SELECT TITLE, YEAR, TYPE_FLAG, 'Disney+'     PLAT_NAME, DISNEY_PLUS FLAG FROM norm
  ),
  src AS (
    SELECT
      t.TITLE_ID,
      p.PLATFORM_ID
    FROM u
    JOIN TITLE t
      ON UPPER(t.NAME) = UPPER(u.TITLE)
     AND NVL(t.RELEASE_YEAR,-1) = NVL(u.YEAR,-1)
     AND t.CONTENT_TYPE = CASE u.TYPE_FLAG WHEN 1 THEN 'Series' ELSE 'Movie' END
    JOIN PLATFORM p
      ON UPPER(p.NAME) = UPPER(u.PLAT_NAME)
    WHERE NVL(u.FLAG,0) = 1
  )
  SELECT DISTINCT TITLE_ID, PLATFORM_ID FROM src
) s
ON (a.TITLE_ID = s.TITLE_ID AND a.PLATFORM_ID = s.PLATFORM_ID)
WHEN NOT MATCHED THEN
  INSERT (TITLE_ID, PLATFORM_ID, START_DATE, END_DATE)
  VALUES (s.TITLE_ID, s.PLATFORM_ID, NULL, NULL);
COMMIT;

------------------------------------------------------------------------
-- 5) Optional: post-load stats
-- SELECT COUNT(*) AS titles FROM TITLE;
-- SELECT COUNT(*) AS ratings FROM RATING;
-- SELECT COUNT(*) AS availability FROM AVAILABILITY;
------------------------------------------------------------------------
