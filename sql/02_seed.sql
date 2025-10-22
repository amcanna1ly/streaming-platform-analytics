
-- 02_seed.sql
-- Seed lookups: Platforms and Rating Sources

INSERT INTO platform (name, launch_year, monthly_price_usd) VALUES ('Netflix',     2007, NULL);
INSERT INTO platform (name, launch_year, monthly_price_usd) VALUES ('Hulu',        2007, NULL);
INSERT INTO platform (name, launch_year, monthly_price_usd) VALUES ('Prime Video', 2006, NULL);
INSERT INTO platform (name, launch_year, monthly_price_usd) VALUES ('Disney+',     2019, NULL);

INSERT INTO rating_source (name, scale_max, has_votes) VALUES ('RT_Critic',   100.0, 'Y');
INSERT INTO rating_source (name, scale_max, has_votes) VALUES ('RT_Audience', 100.0, 'Y');
INSERT INTO rating_source (name, scale_max, has_votes) VALUES ('Metacritic',  100.0, 'Y');
-- Add later if integrating IMDb:
-- INSERT INTO rating_source (name, scale_max, has_votes) VALUES ('IMDb',        10.0, 'Y');

COMMIT;
