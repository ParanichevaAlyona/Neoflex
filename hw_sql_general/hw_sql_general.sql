
select * from bookings.aircrafts;
select * from bookings.airports;
select * from bookings.boarding_passes;
select * from bookings.bookings;
select * from bookings.flights;
select * from bookings.seats;
select * from bookings.ticket_flights;
select * from bookings.tickets;
/*
-- Написать запрос по шаблону, к демонстрационной базе данных, 
использовать любую таблицу на ваше усмотрение, 
главный критерий код запроса должен быть рабочим и возвращать строки, 
код запроса приложить в качестве результата выполненого ДЗ, 
самостоятельно код запроса выполнить и проанализировать результат.

Шаблоны: 
--1
SELECT col1, col2, ...colN
FROM tableName;
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights;

/*
--2
SELECT DISTINCT col1, col2, ...colN
FROM tableName;
*/
SELECT DISTINCT flight_id, fare_conditions, amount
FROM bookings.ticket_flights;

/*
--3
SELECT col1, col2, ...colN
FROM tableName
WHERE condition;
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
WHERE fare_conditions = 'Business';

/*
--4 использовать как AND так и OR в одном условии.
SELECT col1, col2, ...colN
FROM tableName
WHERE condition1 AND|OR condition2;
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
WHERE (fare_conditions = 'Business' and amount > 40000) 
       or
	   (fare_conditions = 'Comfort' and amount > 20000)
	   or
	   (fare_conditions = 'Economy' and amount > 10000);

/*
--5
SELECT col2, col2, ...colN
FROM tableName
WHERE colName IN (val1, val2, ...valN);
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
WHERE fare_conditions IN ('Comfort', 'Economy');

/*
--6
SELECT col1, col2, ...colN
FROM tableName
WHERE colName BETWEEN val1 AND val2;
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
WHERE amount BETWEEN 5000 and 10000;

/*
--7
SELECT col1, col2, ...colN
FROM tableName
WHERE colName LIKE pattern;
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
WHERE ticket_no like '%543212%';

/*
--8 Использовать одновременно ASC и DESC для разных столбцов
SELECT col1, col2, ...colN
FROM tableName
WHERE condition
ORDER BY colName [ASC|DESC];
*/
SELECT ticket_no, flight_id, fare_conditions, amount
FROM bookings.ticket_flights
ORDER BY flight_id DESC, amount ASC;

/*
--9
SELECT SUM(colName)
FROM tableName
WHERE condition
GROUP BY colName;
*/
SELECT flight_id, SUM(amount)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Business'
GROUP BY flight_id;

/*
--10
SELECT COUNT(colName)
FROM tableName
WHERE condition;
*/
SELECT flight_id, count(ticket_no)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Comfort'
GROUP BY flight_id;

/*
--11
SELECT SUM(colName)
FROM tableName
WHERE condition
GROUP BY colName
HAVING (function condition);
*/
SELECT flight_id, SUM(amount)
FROM bookings.ticket_flights
WHERE fare_conditions = 'Business'
GROUP BY flight_id
HAVING COUNT(ticket_no) > 20;

/*
-----
Аналогично предыдущему заданию, по шаблонам написать рабочие запросы к демонстрационной базе данных.

-- создание таблицы, не менее 4х колонок разного типа,
 1 колонка первичный ключ, одна необнуляймая
CREATE TABLE tableName (
  col1 datatype,
  col2 datatype,
  ...
  colN datatype,
  PRIMARY KEY (одна или более колонка)
);
*/
CREATE TABLE bookings.crew (
    person_id     INTEGER,
    flight_id     INTEGER,
	first_name    VARCHAR(20) NOT NULL,
	last_name     VARCHAR(25) NOT NULL,
	job_id        VARCHAR(10),
    airline_id    VARCHAR(10),
    experience    INTEGER,

    CONSTRAINT book_crew_pk PRIMARY KEY(person_id),
	CONSTRAINT book_flight_id_fk FOREIGN KEY(flight_id)
		REFERENCES bookings.flights(flight_id)
);

/*
-- удаление таблицы
DROP TABLE tableName;
*/
DROP TABLE bookings.crew;

/*
-- создание индекса
CREATE UNIQUE INDEX indexName
ON tableName (col1, col2, ...colN);
*/
CREATE UNIQUE INDEX index_name
ON bookings.crew (first_name, last_name);

/*
-- удаление индекса
ALTER TABLE tableName
DROP INDEX indexName;
*/
DROP INDEX bookings.index_name;

/*
-- получение описания структуры таблицы
DESC tableName;
*/
SELECT column_name, column_default, data_type 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name = 'ticket_flights';

/*
-- очистка таблицы
TRUNCATE TABLE tableName;
*/
TRUNCATE TABLE bookings.aircrafts;

/*
-- выбрать одно из вариантов: добавление/удаление/модификация колонок
ALTER TABLE tableName ADD|DROP|MODIFY colName [datatype];
*/
ALTER TABLE bookings.aircrafts
ADD COLUMN date_release date;

/*
-- переименование таблицы
ALTER TABLE tableName RENAME TO newTableName;
*/
ALTER TABLE bookings.airports RENAME TO airports_name;

/*
-- вставка значений
INSERT INTO tableName (col1, col2, ...colN)
VALUES (val1, val2, ...valN)
*/
INSERT INTO bookings.aircrafts (aircraft_code, model, range, date_release)
VALUES ('S10', 'Sukhoi Superjet New', 2960, '2024-01-01');

/*
-- обновление записей
UPDATE tableName
SET col1 = val1, col2 = val2, ...colN = valN
[WHERE condition];
*/
UPDATE bookings.aircrafts
SET date_release = CURRENT_DATE
WHERE date_release IS NULL;

/*
-- удаление записей
DELETE FROM tableName
WHERE condition;
*/
DELETE FROM bookings.ticket_flights
WHERE flight_id = 5346;




