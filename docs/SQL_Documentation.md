# SQL Script Documentation

01\_schema.sql — Creates the normalized schema: TITLE, GENRE, TITLE\_GENRE, PLATFORM, AVAILABILITY, RATING\_SOURCE, RATING, with keys, FKs, and helpful indexes.

02\_seed.sql — Seeds four streaming platforms and Rotten Tomatoes/Metacritic rating sources.

03\_full\_load\_from\_values.sql — Prototype pipeline that loads sample rows into STAGE\_MOVIES and demonstrates a direct insert approach.

04\_transform\_from\_stage.sql — Idempotent MERGE workflow to upsert TITLES, extract RT critic ratings, and unpivot availability flags into AVAILABILITY.

