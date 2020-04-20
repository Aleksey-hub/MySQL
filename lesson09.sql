-- Практическое задание по теме “Транзакции, переменные, представления”
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
--    Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users (name, birthday_at , created_at , updated_at) 
  SELECT name, birthday_at , created_at , updated_at 
    FROM shop.users 
    WHERE id = 1;

COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
--    и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW prod AS SELECT products.name as product, catalogs.name as catalog
  FROM products
    JOIN catalogs
    WHERE products.catalog_id = catalogs.id;
   
SELECT * FROM prod;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
--    в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
--    с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
--    с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //

DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello()
RETURNS VARCHAR(12) DETERMINISTIC
BEGIN
	IF (CURRENT_TIME >= '06:00:00' AND CURRENT_TIME < '12:00:00') THEN
	  RETURN 'Доброе утро';
	ELSEIF (CURRENT_TIME >= '12:00:00' AND CURRENT_TIME < '18:00:00') THEN
	  RETURN 'Добрый день';
	ELSEIF (CURRENT_TIME >= '00:00:00' AND CURRENT_TIME < '06:00:00') THEN
	  RETURN 'Доброй ночи';
	ELSE
	  RETURN 'Добрый вечер';
	END IF;
END//

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
--    Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
--    значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
--    При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

CREATE TRIGGER products_trigger1 BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  END IF;
END//

CREATE TRIGGER products_trigger2 BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END//