-- Практическое задание по теме “NoSQL”
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

-- Добавление нового IP-адреса и установка количества посещений равным 1.
  HSET ip 192.168.1.1 1

-- Увеличение количества посещений на 1.
  HINCRBY ip 192.168.1.1 1

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
--    поиск электронного адреса пользователя по его имени.

  -- Для поиска электронного адреса используем базу данных 0
  SELECT 0
  SET user_name Aleksei example@mail.ru
  
  -- Поиск электронного адреса пользователя
  GET Aleksei
  
  
  -- Для поиска имени пользователя используем базу данных 1
  SELECT 1
  SET example@mail.ru Aleksei
  
  -- Поиск имени пользователя
  GET example@mail.ru
  
-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
   
  db.shop.insert({name: 'Процессоры'})
  db.shop.insert({name: 'Материнские платы'})
  db.shop.insert({name: 'Видеокарты'})
  db.shop.insert({name: 'Жесткие диски'})
  db.shop.insert({name: 'Оперативная память'})
    
  db.shop.insert({name: 'Intel Core i3-8100', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price: 7890.00, catalog_name: 'Процессоры', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'Intel Core i5-7400', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price: 12700.00, catalog_name: 'Процессоры', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'AMD FX-8320E', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', price: 4780.00, catalog_name: 'Процессоры', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'AMD FX-8320', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', price: 7120.00, catalog_name: 'Процессоры', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'ASUS ROG MAXIMUS X HERO', description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', price: 19310.00, catalog_name: 'Материнские платы', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'Gigabyte H310M S2H', description: 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', price: 4790.00, catalog_name: 'Материнские платы', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})
  db.shop.insert({name: 'MSI B250M GAMING PRO', description: 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX.', price: 5060.00, catalog_name: 'Материнские платы', created_at: '2020-04-25 19:00:16', updated_at: '2020-04-25 19:00:16'})