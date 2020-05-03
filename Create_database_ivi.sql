CREATE DATABASE IF NOT EXISTS ivi;

USE ivi;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
id SERIAL PRIMARY KEY,
email VARCHAR(150) UNIQUE NOT NULL,
phone VARCHAR(15) UNIQUE,
money DECIMAL(6,2) NOT NULL,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT NOW() ON UPDATE NOW());

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
id SERIAL PRIMARY KEY,
account_id BIGINT UNSIGNED NOT NULL,
name VARCHAR(100) NOT NULL,
for_childrens BOOLEAN NOT NULL,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT NOW() ON UPDATE NOW());

DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions(
account_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
start_date DATETIME,
end_date DATETIME)
COMMENT = 'Подписка';

DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications(
id SERIAL PRIMARY KEY,
profile_id BIGINT UNSIGNED NOT NULL,
header VARCHAR(200) NOT NULL, -- краткое описание уведомления
link VARCHAR(200),   -- ссылка на страницу с уведомлением
created_at DATETIME DEFAULT NOW())
COMMENT = 'Уведомления';

ALTER TABLE notifications
  ADD CONSTRAINT notifications_profile_id_fk
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
      ON DELETE CASCADE;

DROP TABLE IF EXISTS watched;
CREATE TABLE watched(
profile_id  BIGINT UNSIGNED NOT NULL,
media_id  BIGINT UNSIGNED NOT NULL,
PRIMARY KEY (profile_id, media_id))
COMMENT = 'таблица просмотров';

DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites(
profile_id  BIGINT UNSIGNED NOT NULL,
media_id  BIGINT UNSIGNED NOT NULL,
PRIMARY KEY (profile_id, media_id))
COMMENT = 'таблица "смотреть позже" или "избранное"';

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases(
account_id  BIGINT UNSIGNED NOT NULL,
media_id  BIGINT UNSIGNED NOT NULL,
PRIMARY KEY (account_id, media_id))
COMMENT = 'Покупки';

DROP TABLE IF EXISTS media;
CREATE TABLE media(
id SERIAL PRIMARY KEY,
name VARCHAR(150) NOT NULL,
description TEXT NOT NULL,
country_id TINYINT UNSIGNED NOT NULL,
media_type_id TINYINT UNSIGNED NOT NULL,
childrens_content BOOLEAN NOT NULL,
access_id TINYINT UNSIGNED NOT NULL,
file_path VARCHAR(255) NOT NULL,
year YEAR NOT NULL)
COMMENT = 'Фильмы, сериалы, мультфильмы';

DROP TABLE IF EXISTS countries;
CREATE TABLE countries(
id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
country VARCHAR(150) NOT NULL);

INSERT INTO countries (country) VALUES
('Australia'),
('Belgium'),
('Germany'),
('Ireland'),
('Canada'),
('Netherlands'),
('Russia'),
('Turkey'),
('France'),
('Argentina'),
('Brazil'),
('Hong Kong'),
('Spain'),
('China'),
('New Zealand'),
('USSR'),
('Uzbekistan'),
('Sweden'),
('Armenia'),
('United Kingdom'),
('Denmark'),
('Italy'),
('Colombia'),
('Norway'),
('USA'),
('Ukraine'),
('South Korea'),
('Belarus'),
('Hungary'),
('India'),
('Kazakhstan'),
('Mexico'),
('Poland'),
('Thailand'),
('Finland'),
('Japan');

DROP TABLE IF EXISTS access;
CREATE TABLE access(
id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL)
COMMENT = 'Доступ к контенту (бесплатный, платный, по подписке)';

INSERT INTO access (name)
VALUES 
  ('free'),
  ('purchase'),
  ('subscription');

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL);

INSERT INTO media_types (name) 
  VALUES 
    ('movies'),     -- фильм
    ('series'),     -- сериал
    ('animations'); -- мультфильм

DROP TABLE IF EXISTS genres;
CREATE TABLE genres(
id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL,
media_type_id TINYINT UNSIGNED NOT NULL)
COMMENT = 'Жанры';

INSERT INTO genres (name, media_type_id)
VALUES
  -- жанры фильмов
  ('adventures', 1), 
  ('arthouse', 1), 
  ('biography', 1), 
  ('boeviki', 1), 
  ('comedy', 1), 
  ('comics', 1), 
  ('crime', 1), 
  ('detective', 1), 
  ('detskiy', 1), 
  ('disaster', 1), 
  ('dlya_vsej_semi', 1), 
  ('documentary', 1), 
  ('drama', 1), 
  ('fantastika', 1), 
  ('fentezi', 1), 
  ('foreign', 1), 
  ('horror', 1), 
  ('istoricheskie', 1), 
  ('melodramy', 1), 
  ('misticheskie', 1), 
  ('music', 1), 
  ('rossijskie', 1), 
  ('sovetskoe_kino', 1), 
  ('sport', 1), 
  ('thriller', 1), 
  ('voennye', 1), 
  ('western', 1),
  -- жанры сериалов
  ('biography', 2), 
  ('boeviki', 2), 
  ('comedy', 2), 
  ('crime', 2), 
  ('detective', 2), 
  ('dlya_vsej_semi', 2), 
  ('documentary', 2), 
  ('dramy', 2), 
  ('fantasy', 2), 
  ('foreign', 2), 
  ('history', 2), 
  ('horror', 2), 
  ('medicine', 2),
  ('melodramyi', 2), 
  ('romanticheskie', 2), 
  ('rossijskie', 2),
  ('scifi', 2),
  ('thriller', 2), 
  ('voennye', 2),
  -- жанры мультфильмов
  ('anime', 3), 
  ('comedy', 3), 
  ('detective', 3),
  ('detskie', 3),
  ('dlya_vsej_semi', 3), 
  ('drama', 3),
  ('fantastic', 3),
  ('fantasy', 3), 
  ('foreign', 3), 
  ('militants', 3), 
  ('musical', 3), 
  ('polnometrazhnye', 3),
  ('razvivayuschie', 3), 
  ('rossijskie', 3), 
  ('serialy', 3),
  ('sovetskie', 3),
  ('sport', 3), 
  ('vzroslye', 3);
 
DROP TABLE IF EXISTS media_genres;
CREATE TABLE media_genres(
media_id BIGINT UNSIGNED NOT NULL,
genre_id TINYINT UNSIGNED NOT NULL,
PRIMARY KEY (media_id, genre_id));

DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(
from_profile_id BIGINT UNSIGNED,
to_media_id BIGINT UNSIGNED NOT NULL,
director TINYINT NOT NULL, -- режиссура
story TINYINT NOT NULL, -- сюжет
pretty TINYINT NOT NULL, -- зрелищность
actors TINYINT NOT NULL, -- игра актёров
total_rating FLOAT DEFAULT ((director + story + pretty + actors) / 4),
PRIMARY KEY(from_profile_id, to_media_id)) COMMENT = 'рейтинги';

DROP TABLE IF EXISTS persons;
CREATE TABLE persons(
id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
short_biography TEXT)
COMMENT = 'Таблица всех актеров и создателей фильмов';

DROP TABLE IF EXISTS persons_types;
CREATE TABLE persons_types(
id TINYINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
person_type VARCHAR(30) NOT NULL);

INSERT INTO persons_types (person_type) VALUES
  ('актер'),
  ('режиссёр'),
  ('оператор'),
  ('продюсер'),
  ('сценарист'),
  ('композитор'),
  ('монтаж');

DROP TABLE IF EXISTS media_persons;
CREATE TABLE media_persons(
id SERIAL PRIMARY KEY,
media_id BIGINT UNSIGNED NOT NULL,
person_id BIGINT UNSIGNED NOT NULL,
person_type_id TINYINT UNSIGNED NOT NULL)
COMMENT = 'актеры и создаьели фильма';

DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
id SERIAL PRIMARY KEY,
from_profile_id BIGINT UNSIGNED NOT NULL,
to_media_id BIGINT UNSIGNED NOT NULL,
comment TINYTEXT NOT NULL,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT NOW() ON UPDATE NOW())
COMMENT = 'отзывы/комментарии';

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
id SERIAL PRIMARY KEY,
from_profile_id BIGINT UNSIGNED NOT NULL,
to_media_id BIGINT UNSIGNED NOT NULL,
comment TEXT NOT NULL,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT NOW() ON UPDATE NOW())
COMMENT = 'рецензии';

ALTER TABLE comments
  ADD CONSTRAINT comments_from_profile_id_fk
    FOREIGN KEY (from_profile_id) REFERENCES profiles(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT comments_to_media_id_fk
    FOREIGN KEY (to_media_id) REFERENCES media(id)
      ON DELETE CASCADE;
     
ALTER TABLE favorites
  ADD CONSTRAINT favorites_profile_id_fk
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT favorites_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE CASCADE;

ALTER TABLE genres
  ADD CONSTRAINT genres_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE CASCADE;

ALTER TABLE media
  ADD CONSTRAINT media_country_id_fk
    FOREIGN KEY (country_id) REFERENCES countries(id),
  ADD CONSTRAINT media_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_access_id_fk
    FOREIGN KEY (access_id) REFERENCES access(id);
   
ALTER TABLE media_genres
  ADD CONSTRAINT media_genres_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT media_genre_genre_id_fk
    FOREIGN KEY (genre_id) REFERENCES genres(id)
      ON DELETE CASCADE;
     
ALTER TABLE media_persons
 ADD CONSTRAINT media_persons_media_id_fk
   FOREIGN KEY (media_id) REFERENCES media(id)
     ON DELETE CASCADE,
 ADD CONSTRAINT media_persons_person_id_fk
   FOREIGN KEY (person_id) REFERENCES persons(id)
     ON DELETE CASCADE,
 ADD CONSTRAINT media_persons_person_type_id_fk
   FOREIGN KEY (person_type_id) REFERENCES persons_types(id);
  
ALTER TABLE notifications
  ADD CONSTRAINT notifications_profile_id_fk
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
      ON DELETE CASCADE;
     
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_account_id_fk
    FOREIGN KEY (account_id) REFERENCES accounts(id)
     ON DELETE CASCADE;
    
ALTER TABLE purchases
  ADD CONSTRAINT purchases_account_id_fk
    FOREIGN KEY (account_id) REFERENCES accounts(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT purchases_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id);
     
ALTER TABLE ratings
  ADD CONSTRAINT ratings_from_profile_id_fk
    FOREIGN KEY (from_profile_id) REFERENCES profiles(id),
  ADD CONSTRAINT ratings_to_media_id_fk
    FOREIGN KEY (to_media_id) REFERENCES media(id)
      ON DELETE CASCADE;
     
ALTER TABLE reviews
  ADD CONSTRAINT reviews_from_profile_id_fk
    FOREIGN KEY (from_profile_id) REFERENCES profiles(id),
  ADD CONSTRAINT reviews_to_media_id_fk
    FOREIGN KEY (to_media_id) REFERENCES media(id)
      ON DELETE CASCADE;

ALTER TABLE subscriptions 
  ADD CONSTRAINT subscriptions_account_is_fk
    FOREIGN KEY (account_id) REFERENCES accounts(id)
      ON DELETE CASCADE;
      
ALTER TABLE watched
  ADD CONSTRAINT watched_profile_id_fk
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT watched_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE CASCADE;
      
CREATE INDEX media_year_idx
  ON media(year);
  
CREATE INDEX persons_first_name_last_name_idx
  ON persons(first_name, last_name);
  
CREATE INDEX ratings_total_rating_idx
  ON ratings(total_rating);
  
CREATE INDEX ratings_director_idx
  ON ratings(director);
  
CREATE INDEX ratings_story_idx
  ON ratings(story);
  
CREATE INDEX ratings_pretty_idx
  ON ratings(pretty);
  
CREATE INDEX ratings_actors_idx
  ON ratings(actors);
  
-- Представление: имя актера/создателя фильма и фильмы к которым он причастен.
 CREATE OR REPLACE VIEW pers AS
  SELECT 
    CONCAT(first_name, ' ', last_name) as name,
    GROUP_CONCAT((SELECT name FROM media WHERE media.id = media_persons.media_id) SEPARATOR ', ') as movies
  FROM persons
    JOIN media_persons 
      ON persons.id = media_persons.person_id
    GROUP BY name;
      
-- SELECT * FROM pers;

-- Представление: список медиаконтента для бесплатного просмотра

CREATE OR REPLACE VIEW media_free AS
  SELECT 
    name,
    (SELECT country FROM countries WHERE countries.id = media.country_id ) AS country,
    (SELECT name FROM media_types WHERE media_types.id = media.media_type_id) AS media_type,
    `year`,
    file_path
  FROM media
  WHERE access_id = (SELECT id FROM access WHERE access.name = 'free');
  
 -- SELECT * FROM media_free;