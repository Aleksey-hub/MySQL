-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT DISTINCT name FROM users JOIN orders ON users.id = user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT products.name, catalogs.name FROM products JOIN catalogs ON catalog_id = catalogs.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
--    Поля from, to и label содержат английские названия городов, поле name — русское. 
--    Выведите список рейсов flights с русскими названиями городов.

SELECT 
  c1.name as `from`, 
  c2.name as `to` 
FROM 
  flights 
JOIN 
  cities c1
JOIN
  cities c2
ON 
  c1.label = `from` AND c2.label = `to`;
