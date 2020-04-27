-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
--    в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа 
--    и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
  id SERIAL,  
  table_name VARCHAR(100),
  target_id BIGINT,
  name VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP)
ENGINE=ARCHIVE;


DELIMITER -
	
DROP TRIGGER IF EXISTS users_trigger1-
CREATE TRIGGER users_trigger1 AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, target_id, name) VALUES ('users', NEW.id, NEW.name);
END-
	
DROP TRIGGER IF EXISTS catalogs_trigger1-
CREATE TRIGGER catalogs_trigger1 AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, target_id, name) VALUES ('catalogs', NEW.id, NEW.name);
END-
	
DROP TRIGGER IF EXISTS products_trigger1-
CREATE TRIGGER products_trigger1 AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, target_id, name) VALUES ('products', NEW.id, NEW.name);
END-


-- Для проверки
INSERT INTO 
  users (id, name, birthday_at, created_at, updated_at) 
VALUES
  (DEFAULT, 'Валерий', '1999-05-07', NOW(), NOW()),
  (DEFAULT, 'Сергей', '1990-05-13', NOW(), NOW());

INSERT INTO 
  catalogs (name) 
VALUES
  ('Клавиатуры'),
  ('Мышки');
 
SELECT * FROM logs;