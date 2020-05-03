-- Доработка данных полученных на filldb

INSERT INTO profiles (account_id, name, for_childrens)
  VALUES 
    (7, 'Alex', 0),
    (27, 'Bill', 0),
    (31, 'Alex', 0),
    (43, 'Ken', 0),
    (50, 'Alex', 0),
    (64, 'Otilia', 0),
    (74, 'Grace', 0),
    (79, 'Mariannex', 0),
    (82, 'Moises', 0),
    (87, 'Lila', 0),
    (90, 'Colin', 0);
    
UPDATE profiles SET updated_at = NOW() WHERE created_at > updated_at;
 
UPDATE accounts SET updated_at = NOW() WHERE created_at > updated_at;

UPDATE comments SET updated_at = NOW() WHERE created_at > updated_at;

UPDATE reviews SET updated_at = NOW() WHERE created_at > updated_at;

UPDATE subscriptions SET end_date = NOW() WHERE start_date > end_date;

-- Выборки
-- 1. Полная информация о фильме с id = 5. Название, год выпуска, страна производства, список жанров, создатели фильма и описание.

SELECT 
  media.name, 
  media.year,
  (SELECT country FROM countries WHERE countries.id = media.country_id) as country,
  GROUP_CONCAT(DISTINCT (SELECT genres.name FROM genres WHERE genres.id = media_genres.genre_id) SEPARATOR ', ') as genres,
  GROUP_CONCAT(DISTINCT (SELECT CONCAT(persons.first_name,' ', persons.last_name) FROM persons WHERE persons.id = media_persons.person_id) SEPARATOR ', ') as filmmakers,
  media.description
FROM media
  JOIN media_genres ON media.id = media_genres.media_id
  JOIN media_persons ON media.id = media_persons.media_id
WHERE media.id = 5;

-- 2. Список фильмов комедий вышедших за последние 20 лет.

SELECT @movies_id := id FROM media_types WHERE name = 'movies';

SELECT name, year 
FROM media 
  JOIN media_genres 
    ON media.id = media_genres.media_id 
      AND media_genres.genre_id = (SELECT id FROM genres WHERE name = 'comedy' AND genres.media_type_id = @movies_id)
WHERE year >= YEAR(NOW()) - 20 
  AND media_type_id = @movies_id
ORDER BY year;
 
-- 3. 10 самых популярных мультфильмов (с наибольших количеством просмотров).

SELECT 
  name, 
  COUNT(*) as number_of_views
FROM media
  JOIN watched ON media.id = watched.media_id
  WHERE media.media_type_id = (SELECT id FROM media_types WHERE media_types.name = 'animations')
  GROUP BY name
ORDER BY number_of_views DESC
LIMIT 10;

-- 4. 10 сериалов с самым высоким рейтингом.

SELECT 
  media.name,
  ratings.total_rating
FROM media
  JOIN ratings ON media.id = ratings.to_media_id
  WHERE media.media_type_id = (SELECT id FROM media_types WHERE media_types.name = 'series')
ORDER BY total_rating DESC
LIMIT 10;

-- Хранимые функции
/* Функция в качестве параметра принимает id одного из профилей (т.е. id из таблицы profiles).
Результатом работы функции является id актера или создателя фильма (id из таблицы persons) наиболее часто встречающегося среди 
просмотренного или добавленного в избранное медиаконтента.
С помошью этого id формируем список рекомендуемого контента, т.е. список контента в создании которого этот id принимал участие.*/

DELIMITER -

DROP FUNCTION IF EXISTS rec_media-
CREATE FUNCTION rec_media (prof_id INT)
RETURNS BIGINT READS SQL DATA
BEGIN
  DECLARE like_pers BIGINT;

  SELECT person_id
  INTO like_pers
  FROM
    (SELECT 
      person_id
    FROM watched
      JOIN media_persons ON watched.media_id = media_persons.media_id 
    WHERE profile_id = prof_id
      UNION ALL
    SELECT
      person_id
    FROM favorites
      JOIN media_persons ON favorites.media_id = media_persons.media_id
    WHERE profile_id = prof_id) AS like_pers
  GROUP BY person_id
  ORDER BY COUNT(*) DESC
  LIMIT 1;

  RETURN like_pers;
	
END-

-- С помощью функции rec_media() получаем список рекомендуемого медиаконтента для профиля с id = 13
SELECT
  (SELECT name FROM media WHERE media.id = media_id) AS recommendations
FROM media_persons
WHERE media_persons.person_id = rec_media(13)
  AND media_persons.media_id NOT IN (SELECT media_id FROM watched WHERE watched.profile_id = 13)
  AND media_persons.media_id NOT IN (SELECT media_id FROM favorites WHERE favorites.profile_id = 13);

-- Триггеры
DELIMITER -

CREATE TRIGGER validate_name_media_update BEFORE UPDATE ON media
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL 
    AND NEW.description IS NULL
    AND NEW.country_id IS NULL
    AND NEW.media_type_id IS NULL
    AND NEW.childrens_content IS NULL
    AND NEW.access_id IS NULL
    AND NEW.file_path IS NULL
    AND NEW.year IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  END IF;
END-

CREATE TRIGGER validate_name_media_insert BEFORE INSERT ON media
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL 
    AND NEW.description IS NULL
    AND NEW.country_id IS NULL
    AND NEW.media_type_id IS NULL
    AND NEW.childrens_content IS NULL
    AND NEW.access_id IS NULL
    AND NEW.file_path IS NULL
    AND NEW.year IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END-

CREATE TRIGGER validate_name_profiles_update BEFORE UPDATE ON profiles
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  END IF;
END-

CREATE TRIGGER validate_name_profiles_insert BEFORE INSERT ON profiles
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END-

CREATE TRIGGER validate_name_accounts_update BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
  IF (NEW.email IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  END IF;
END-

CREATE TRIGGER validate_name_accounts_insert BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
  IF (NEW.email IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END-