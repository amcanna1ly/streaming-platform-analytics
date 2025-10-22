# Project Report

Goal. Analyze title availability and ratings across Netflix, Hulu, Prime Video, and Disney+ using a normalized relational model and Tableau dashboards.

Design. Staging table -> MERGE-driven ETL into TITLE/PLATFORM/AVAILABILITY/RATING tables. Genres supported via TITLE\_GENRE bridge. Ratings modeled by RATING\_SOURCE and RATING.

Analytics. Platform coverage, titles on all four platforms, exclusives, average RT critic by platform, decile distributions, top 10 per platform, best-by-year, and pairwise overlaps.

