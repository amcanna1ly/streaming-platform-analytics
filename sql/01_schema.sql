
-- 01_schema.sql
-- Streaming Platform Analytics - Oracle DDL

-- Drop statements
BEGIN EXECUTE IMMEDIATE 'DROP TABLE rating CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE rating_source CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE availability CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE platform CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE title_genre CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE genre CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE title CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
-- ===============================================

CREATE TABLE title (
  title_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name          VARCHAR2(300)    NOT NULL,
  release_year  NUMBER(4),
  runtime_min   NUMBER(5),
  age_rating    VARCHAR2(20),
  content_type  VARCHAR2(10)     DEFAULT 'Movie' NOT NULL,
  CONSTRAINT ck_title_content_type CHECK (content_type IN ('Movie','Series'))
);

CREATE TABLE genre (
  genre_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name      VARCHAR2(80) NOT NULL,
  CONSTRAINT uq_genre_name UNIQUE (name)
);

CREATE TABLE title_genre (
  title_id  NUMBER NOT NULL,
  genre_id  NUMBER NOT NULL,
  CONSTRAINT pk_title_genre PRIMARY KEY (title_id, genre_id),
  CONSTRAINT fk_tg_title  FOREIGN KEY (title_id) REFERENCES title(title_id),
  CONSTRAINT fk_tg_genre  FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

CREATE TABLE platform (
  platform_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name               VARCHAR2(120) NOT NULL,
  launch_year        NUMBER(4),
  monthly_price_usd  NUMBER(6,2),
  CONSTRAINT uq_platform_name UNIQUE (name)
);

CREATE TABLE availability (
  availability_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title_id         NUMBER NOT NULL,
  platform_id      NUMBER NOT NULL,
  start_date       DATE,
  end_date         DATE,
  CONSTRAINT fk_av_title    FOREIGN KEY (title_id)    REFERENCES title(title_id),
  CONSTRAINT fk_av_platform FOREIGN KEY (platform_id) REFERENCES platform(platform_id),
  CONSTRAINT ck_av_dates    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

CREATE TABLE rating_source (
  source_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name       VARCHAR2(40) NOT NULL,
  scale_max  NUMBER(4,1)  NOT NULL,
  has_votes  CHAR(1)      DEFAULT 'Y' NOT NULL,
  CONSTRAINT uq_source_name UNIQUE (name),
  CONSTRAINT ck_source_votes CHECK (has_votes IN ('Y','N'))
);

CREATE TABLE rating (
  rating_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title_id      NUMBER      NOT NULL,
  source_id     NUMBER      NOT NULL,
  metric_type   VARCHAR2(40) DEFAULT 'overall' NOT NULL,
  rating_value  NUMBER(4,1) NOT NULL,
  rating_count  NUMBER,
  rating_date   DATE,
  CONSTRAINT fk_rating_title  FOREIGN KEY (title_id)  REFERENCES title(title_id),
  CONSTRAINT fk_rating_source FOREIGN KEY (source_id) REFERENCES rating_source(source_id)
);

-- Helpful indexes
CREATE INDEX ix_tg_title     ON title_genre(title_id);
CREATE INDEX ix_tg_genre     ON title_genre(genre_id);
CREATE INDEX ix_av_title     ON availability(title_id);
CREATE INDEX ix_av_platform  ON availability(platform_id);
CREATE INDEX ix_rating_title ON rating(title_id);
CREATE INDEX ix_rating_src   ON rating(source_id);
