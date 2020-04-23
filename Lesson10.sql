-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и 
--    добавить необходимые индексы.

CREATE INDEX friendship_user_id_friend_id_idx
  ON friendship(user_id, friend_id);
 
CREATE INDEX likes_target_id_idx
  ON likes(target_id);
 
CREATE INDEX messages_from_user_id_to_user_id_idx
  ON messages(from_user_id, to_user_id);
 
CREATE INDEX profiles_birthday_idx
  ON profiles(birthday);
 
CREATE INDEX profiles_city_idx
  ON profiles(city);
 
CREATE INDEX profiles_country_idx
  ON profiles(country);
 
CREATE INDEX users_first_name_last_name_idx
  ON users(first_name, last_name);
 
-- 2. Задание на оконные функции.
-- 	Провести аналитику в разрезе групп.
-- 	Построить запрос, который будет выводить следующие столбцы:
-- 	имя группы
-- 	среднее количество пользователей в группах
-- 	самый молодой пользователь в группе
-- 	самый пожилой пользователь в группе
-- 	количество пользователей в группе
-- 	всего пользователей в системе
-- 	отношение в процентах (количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT communities.name,
  COUNT(communities_users.user_id) OVER() / MAX(communities.id) OVER() AS average_count_users,
  FIRST_VALUE(CONCAT(first_name,' ',last_name)) OVER (PARTITION BY communities.name ORDER BY birthday DESC) AS youngest,
  FIRST_VALUE(CONCAT(first_name,' ',last_name)) OVER (PARTITION BY communities.name ORDER BY birthday) AS oldest,
  COUNT(communities_users.user_id) OVER (PARTITION BY communities.name) AS count_community_users,
  MAX(users.id) OVER() AS count_all_users,
  COUNT(communities_users.user_id) OVER (PARTITION BY communities.name) / MAX(users.id) OVER() * 100 AS "%"
FROM communities
  JOIN communities_users
    ON communities.id = communities_users.community_id
  JOIN profiles 
    ON communities_users.user_id = profiles.user_id
  RIGHT JOIN users 
    ON profiles.user_id = users.id
WHERE communities.name IS NOT NULL;