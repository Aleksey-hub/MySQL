-- 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
SELECT SUM(count_likes) FROM
  (SELECT
    COUNT(target_id) as count_likes
  FROM profiles
    LEFT JOIN likes
      ON profiles.user_id = target_id AND target_type_id = 2
      GROUP BY profiles.user_id
      ORDER BY birthday DESC 
      LIMIT 10) as user_likes;

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT gender, COUNT(*) as number_of_likes
FROM profiles
  JOIN likes
    ON profiles.user_id = likes.user_id
    GROUP BY gender;

-- 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- За активность пользователя примем сумму количества лайков, постов и сообщений.
SELECT users.id, COUNT(likes.user_id) + COUNT(posts.user_id) + COUNT(messages.from_user_id) AS user_activity
FROM users
  LEFT JOIN likes
    ON users.id = likes.user_id
  LEFT JOIN posts
    ON users.id = posts.user_id
  LEFT JOIN messages
    ON users.id = from_user_id
    GROUP BY users.id
    ORDER BY user_activity
    LIMIT 10;

