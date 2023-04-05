DROP TABLE IF EXISTS artists; 

-- Table Definition
CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name text,
    genre text
);

TRUNCATE TABLE artists RESTART IDENTITY;

INSERT INTO artists ("name", "genre") VALUES
('Pixies', 'Rock'),
('ABBA', 'Pop'),
('Taylor Swift', 'Pop'),
('Nina Simone', 'Pop');

-- psql -h 127.0.0.1 music_library_app < spec/seeds/albums_seeds.sql
-- psql -h 127.0.0.1 music_library_app < spec/seeds/artists_seeds.sql

-- psql -h 127.0.0.1 music_library_app_test < spec/seeds/albums_seeds.sql
-- psql -h 127.0.0.1 music_library_app_test < spec/seeds/artists_seeds.sql
-- psql -h 127.0.0.1 music_library < spec/seeds/albums_seeds.sql
-- psql -h 127.0.0.1 music_library < spec/seeds/artists_seeds.sql

-- psql -h 127.0.0.1 music_library_test < spec/seeds/albums_seeds.sql
-- psql -h 127.0.0.1 music_library_test < spec/seeds/artists_seeds.sql