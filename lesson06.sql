-- 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки 
--    и/или улучшения (JOIN пока не применять). Создать таблицы лайков и постов.

-- Создаем таблицы лайков и постов из файла examples.sql к 6 уроку
-- Таблицу постов заполняем с помощью сайта filldb.info

-- Далее добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT posts_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL;
     
ALTER TABLE media 
  ADD CONSTRAINT media_media_types_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
ALTER TABLE likes 
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);
   
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_frind_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
   
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
-- 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT user_id FROM profiles WHERE birthday >= 
(SELECT birthday FROM profiles ORDER BY birthday DESC LIMIT 1 OFFSET 9); -- id 10-ти самых молодых

SELECT 
  COUNT(*) AS count_of_likes
FROM 
  likes 
WHERE 
  target_type_id = 2 AND 
  target_id IN (SELECT user_id FROM profiles WHERE birthday >= (SELECT birthday FROM profiles ORDER BY birthday DESC LIMIT 1 OFFSET 9));

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT 
  IF((user_id IN (SELECT user_id FROM profiles WHERE gender = 'm')),'Men','Women') as Gender, 
  COUNT(*) as number_of_likes  
FROM likes 
GROUP BY Gender;

-- 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- За активность пользователя примем сумму количества лайков, постов и сообщений.
-- Объединяем таблицы likes, posts и messages. И подсчитываем, с помощью COUNT(*), сколько раз встречается каждый пользователь.
SELECT user_id, COUNT(*) - 1 AS user_activity
FROM 
  (SELECT user_id FROM likes
   UNION ALL
   SELECT user_id FROM posts
   UNION ALL
   SELECT from_user_id FROM messages
   UNION ALL
   SELECT id FROM users)t -- необходимо чтобы учесть пользователей с нулевой активностью. Поэтому делаем корретировку "COUNT(*) - 1".
GROUP BY user_id
ORDER BY user_activity LIMIT 10;
