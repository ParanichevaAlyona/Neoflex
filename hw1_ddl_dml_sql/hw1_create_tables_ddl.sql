/*
К вам обратились пердставители it-отдела полиции города Верхняя Пышма (Свердловской области).
В регионе повышенный уровень организованной преступности, и в рамках модернизации было решено
хранить информацию о преступных группировках в электроннном виде, в базе PostgreSQL.

После 10 бессонных ночей, и 20 пересогласований, аналитики и архитектор составили вот такую схему:

Задание 1. Создайте таблицы со следующими полями.
Используйти первичные и внешние ключи с подходящими условиями.
Для id используйте целочисленный тип int, для строк - тип varchar(30), для дат - тип date.

district - районы
    district_id - id района
    district_name - название района

    Ограничения:
        Все названия районов должны быть не пустым и уникальным
        Нельзя удалить район, в котором есть улицы
*/

--Отделяем создание полей и ограничений, кроме NOT NULL - его нельзя вынести отдельно
--Ограничение на удаление района, в котором есть улицы будет в дочерней таблице street
CREATE TABLE district (
    district_id int,
    district_name varchar(30) NOT NULL,
	
	CONSTRAINT district_district_id_pk PRIMARY KEY(district_id),
	CONSTRAINT unique_district_name UNIQUE(district_name)
);

/*
street - улицы
    street_id - id улицы
    street_name - название улицы
    district_id - id района, в к которому относится улица

    Ограничения:
        Каждая улица должна иметь не пустое имя 
		и относиться к какому-нибудь району
*/

CREATE TABLE street (
    street_id int,
    street_name varchar(30) NOT NULL,
    district_id int NOT NULL,
	
	CONSTRAINT street_street_id_pk PRIMARY KEY(street_id),
	CONSTRAINT street_district_id_fk FOREIGN KEY(district_id)
		REFERENCES district(district_id) ON DELETE RESTRICT
);

/*
gang - преступная группировка
    gang_id - id группировки
    gang_name - название группировки

    Ограничения:
        Название группировки должно быть не пустым и уникальным
		При удалении банды, у всех преступников, состоящих в этой банде, gang_id должен стать равным NULL
*/

--Ограничение касающееся таблицы criminal будет там
CREATE TABLE gang (
    gang_id int,
    gang_name varchar(30) NOT NULL,
	
	CONSTRAINT gang_gang_id_pk PRIMARY KEY(gang_id),
	CONSTRAINT gang_unique_gang_name UNIQUE(gang_name)
);

/*
gang_street_relation - связи (many-to-many) меджу бандами, и улицами, которые они контролируют
    gang_id - id группировки
    street_id - id улицы

    Ограничения:
        Все пары значений не должны повторяться и быть не пустыми (составной первичный ключ)
        При удалении банды или улицы, должны удаляться соответствующие записи
*/

--Так как первичный ключ и так содержит в себе свойства уникальности и не равности нулю,
--то отдельно данные ограничения не создаем
CREATE TABLE gang_street_relation (
    gang_id int,
    street_id int,
	
	CONSTRAINT relation_gang_id_fk FOREIGN KEY(gang_id)
		REFERENCES gang(gang_id) ON DELETE CASCADE,
	CONSTRAINT relation_street_id_fk FOREIGN KEY(street_id)
		REFERENCES street(street_id) ON DELETE CASCADE,
	CONSTRAINT relation_gang_street_pk PRIMARY KEY(gang_id, street_id)
);

/*
criminal - преступник
    criminal_id - id преступника
    last_name - фамилия
    first_name - имя
    middle_name - отчество
    birth_date - дата рождения
    death_date - дата смерти
    gang_id - id банды, в которой он состоит

    Ограничения:
        Фамилия и имя должны быть не пустыми
        Фамилия, имя и отчество должны начинаться с больших букв (если не пустые)
        Дата рождения должна быть не пустой
*/

--Для ограничения на вставку ФИО пользуемся шаблонами и оператором SIMILAR TO
CREATE TABLE criminal (
    criminal_id int,
    last_name varchar(30) NOT NULL,
    first_name varchar(30) NOT NULL,
    middle_name varchar(30),
    birth_date date NOT NULL,
    death_date date,
    gang_id int,
	
	CONSTRAINT criminal_criminal_id_pk PRIMARY KEY(criminal_id),
	CONSTRAINT criminal_gang_id_fk FOREIGN KEY(gang_id)
		REFERENCES gang(gang_id) ON DELETE SET NULL,
	CONSTRAINT criminal_cap_let_last_name CHECK(last_name  SIMILAR TO '[А-Я]%'),
	CONSTRAINT criminal_cap_let_first_name CHECK(first_name SIMILAR TO '[А-Я]%'),
	CONSTRAINT criminal_cap_let_middle_name CHECK(middle_name SIMILAR TO '[А-Я]%' OR middle_name IS NULL)
);

/*
Заказчик прислал вам письмо со списком районов, улиц, и банд.

Задание 2: Внесите в созданные таблицы следующе данные:

Районы и улицы:
1 - Ленинский
    1 - Проспект Ленина
    2 - Улица Ленина
    3 - 3й Ленинский проезд
    4 - 8й Ленинский тупик
2 - Кировский
    5 - Хажайная
    6 - Набережная
    7 - Астраханская
    8 - Московская
    9 - Мирный переулок
3 - Заводской
    10 - Проспект 50 лет октября
    11 - Электроугли
    12 - Улица академика Яблочкова
4 - Солнечный
    13 - Новоузенская
    14 - Улица имени Салтыкова-Щедрина
    15 - 99й автобусный тупик
    16 - Проспект 50 лет октября
*/

INSERT INTO district
VALUES 
(1, 'Ленинский'),
(2, 'Кировский'),
(3, 'Заводской'),
(4, 'Солнечный');

INSERT INTO street /*Ленинский*/
VALUES 
(1, 'Проспект Ленина', 1),
(2, 'Улица Ленина', 1),
(3, '3й Ленинский проезд', 1),
(4, '8й Ленинский тупик', 1);

INSERT INTO street /*Кировский*/
VALUES 
(5, 'Хажайная', 2),
(6, 'Улица Ленина', 2),
(7, 'Набережная', 2),
(8, 'Астраханская', 2),
(9, 'Мирный переулок', 2);

INSERT INTO street /*Заводской*/
VALUES 
(10, 'Проспект 50 лет октября', 3),
(11, 'Электроугли', 3),
(12, 'Улица академика Яблочкова', 3);

INSERT INTO street /*Солнечный*/
VALUES 
(13, 'Новоузенская', 4),
(14, 'Улица имени Салтыкова-Щедрина', 4),
(15, '99й автобусный тупик', 4),
(16, 'Проспект 50 лет октября', 4);


/*
Банды, и id улиц, которые они держат:
1 - Анонимные алкоголики
    1, 2, 4, 5
2 - Неуловимые мстители
    3, 7
3 - Дикобразы
    6, 10, 12
4 - Анонимные хакеры
    8, 9
5 - Панки
    15
*/

INSERT INTO gang
VALUES 
(1, 'Анонимные алкоголики'),
(2, 'Неуловимые мстители'),
(3, 'Дикобразы'),
(4, 'Анонимные хакеры'),
(5, 'Панки');

INSERT INTO gang_street_relation
VALUES 
(1, 1), (1, 2), (1, 4), (1, 5),
(2, 3), (2, 7),
(3, 6), (3, 10), (3, 12),
(4, 8), (4, 9),
(5, 15);

/*
После прогона всех личных дел преступников через ABBY FineReader, заказчик прислал вам такую таблицу:
create table temp_criminal (
    criminal_id int,
    surname varchar(30),
    name varchar(30),
    otchestvo varchar(30) ,
    birth_date varchar(30),
    death_date varchar(30),
    gang_id int
);

insert into temp_criminal values
(1  , 'осипова'     , 'наина'      , NULL          , '16.10.1964' , NULL       , 1),
(2  , 'кудрявцева'  , 'екатерина'  , 'сергеевна'   , '07.03.1989' , '20210607' , 4),
(3  , 'виленович'   , 'лаврентьев' , '   ипатиев'  , '08.02.1991' , '20190901' , 2),
(4  , 'харитонович' , 'андрей'     , 'андреев    ' , '05.02.1964' , '20110728' , 4),
(5  , 'романовна'   , 'таисия'     , 'ершова'      , '16.02.1960' , NULL       , 5),
(6  , '  тарасов'   , 'трофим'     , NULL          , '23.12.2018' , NULL       , 1),
(7  , '  фомичев'   , 'арсений'    , 'геннадиевич' , '14.08.1964' , NULL       , 2),
(8  , 'гертрудович' , 'мирон'      , ' тимурович  ', '18.01.2001' , NULL       , 5),
(9  , 'виноградова' , ' иванна '   , NULL          , '11.02.1976' , '20080624' , 4),
(10 , 'одинцова'    , 'виктория'   , 'антоновна'   , '18.06.1975' , NULL       , 4);


Задание 3. Создайте и заполните таблицу temp_criminal, используя код выше.
Изменять данные в таблице temp_criminal запрещено.
Вставьте все записи из таблицы temp_criminal в таблицу criminal так, что бы все записи вставились без ошибок.
Для решения воспользуйтесь конструкцией insert into ... select ...
*/

--Чтобы привести ФИО в необходимый вид, используем строковыми функциями,
--соответственно даты рождения и смерти приводим к типу date
INSERT INTO criminal
SELECT criminal_id, 
       concat(upper(left(TRIM(surname),1)),substr(TRIM(surname),2)), 
       concat(upper(left(TRIM(name),1)),substr(TRIM(name),2)), 
       concat(upper(left(TRIM(otchestvo),1)), substr(TRIM(otchestvo),2)), 
       DATE(birth_date), 
       DATE(death_date), 
       gang_id
FROM temp_criminal
WHERE otchestvo is not NULL;

INSERT INTO criminal
SELECT criminal_id, 
       concat(upper(left(TRIM(surname),1)),substr(TRIM(surname),2)), 
       concat(upper(left(TRIM(name),1)),substr(TRIM(name),2)), 
       NULL, 
       DATE(birth_date), 
       DATE(death_date), 
       gang_id
FROM temp_criminal
WHERE otchestvo is NULL;

/*
Задание 4: В честь 104 летия Великой Октябрьской Революции,
администрация Заводского района решила переименовать "Проспект 50 лет октября" в "Проспект 104 лет октября".
Внесите соответствующие изменения в базу, не указывая конкретный id улицы
*/

--Есть две улицы с одинаковым названием, но находящиеся в разных районах,
--поэтому чтобы переименовать нужную улицу, нужно еще одно поле.
--Так как запрещено использовать id улицы, но не запрещено использовать 
--id района, то воспользуемся им. 
--(Если совсем без айдишников, то нужно воспользоваться соединением таблиц)
UPDATE street
SET street_name = 'Проспект 104 лет октября'
WHERE street_name = 'Проспект 50 лет октября' AND district_id = 3;

/*
В результате сегодняшней потасовки:
1. Ликвидирована банда "Панки" (запись о банде надо удалить)
2. Трагически погибли все её участники (нужно установить им дату смерти)
3. 99й автобусный тупик Солнечного района уничтожен, на его месте теперь пустырь (запись об улице надо удалить)

Задание 5: Внесите соответствующие изменения в базу. Для получения сегодняшней даты используйте соответствующую функцию
*/

DELETE FROM gang 
WHERE gang_name = 'Панки';

--при удалении банды, у преступников зануляется gang_id
UPDATE criminal
SET death_date = current_date
WHERE gang_id is NULL;

DELETE FROM street 
WHERE street_name = '99й автобусный тупик';

/*
Задание 6: напишите запрос, возвращающий ФИО (как одно поле) и 
		дату рождения в формате 'DD MON YYYY' всех живых преступников 1964 года рождения
*/

--пользуемся строковыми функциями и функциями для дат
SELECT concat(last_name, first_name, middle_name), 
       to_char(birth_date, 'dd mm yyyy')
FROM criminal
WHERE death_date IS NULL AND EXTRACT(YEAR FROM birth_date::timestamp) = 1964;

/*
Задание 7: К базе данных подключился злоумышленник, и хочет удалить все таблицы. Какие команды он напишет?
Все команды никогда не должны завершаться с ошибкой, даже если таблицы уже была удалена ранее.
*/
/*
Для решения заданий в этой работе используются те же таблицы, что вы создали в первом ДЗ, а именно:
    1. district
    2. street
    3. gang
    4. gang_street_relation
    5. criminal

*/
--чтобы не поймать ошибку при удалении уже удаленной таблицы
--добавим к запросу IF EXISTS
DROP TABLE IF EXISTS district;
DROP TABLE IF EXISTS street;
DROP TABLE IF EXISTS gang;
DROP TABLE IF EXISTS gang_street_relation;
DROP TABLE IF EXISTS criminal;

/*
Задание 1.
Во время тестирования на стороне заказчика выяснилось, что требования к таблицам были составлены неккоректно.
В таблицу criminal нужно добавить:
    1. Столбец identity_document_num,  в котором будет храниться номер удостоверения личности (integer).
    2. Столбец identity_document_date, в котором будет храниться дата выдачи удостоверения личности
    3. Столбец identity_document_type, в котором будет храниться тип удостоверения личности ('Паспорт', 'Водительские права', ....)

Добавьте соответствующие столбцы в таблицу и заполните их фейковыми данными:
    1. identity_document_num  = floor(random() * 100000000)
    2. identity_document_date = current_date
    3. identity_document_type = 'Паспорт'
*/

--добавляем колонки с требуемыми типами данных
ALTER TABLE criminal
ADD COLUMN identity_document_num int,
ADD COLUMN identity_document_date date,
ADD COLUMN identity_document_type varchar(30);

--заполняем пустые ячейки
UPDATE criminal
SET identity_document_num = floor(random() * 100000000),
	identity_document_date = current_date,
	identity_document_type = 'Паспорт';


/*
Задание 2.
Заказчик просит добавить ограничения: 
все добавленные в предыдущем задании столбцы не должны содержать пустых значений,
и столбец identity_document_num не должен содержать дублей
*/

--на уникальность можно создать именованное ограничение
--а для NOT NULL придется воспользоваться изменением свойств полей
ALTER TABLE criminal
ADD CONSTRAINT crim_unique_id_doc_num UNIQUE(identity_document_num),
ALTER COLUMN identity_document_num SET NOT NULL,
ALTER COLUMN identity_document_date SET NOT NULL,
ALTER COLUMN identity_document_type SET NOT NULL;


/*
Задание 3.
Заказчик снова передумал - теперь он решил, что всех преступников мы будем идентифицировать только по паспорту, 
а значит информация об этом больше не нужна в таблице.
Удалите колоку identity_document_type из таблицы criminal
*/

ALTER TABLE criminal
DROP COLUMN identity_document_type;

/*
Задание 4.
Заказчик жалуется, что когда он ищет конкретных преступников по фамилии, или по номеру и дате выдачи паспорта, 
то запросы работают слишком медленно.
Создайте объекты, которые могут решить эту проблему.
*/

--по умолчанию создаются индексы на первичный ключ
--чтобы запросы работали быстрее создадим индексы на фамилию и номер и дату выдачи паспорта
CREATE INDEX index_last_name
ON criminal (last_name);

CREATE INDEX index_doc_name_date
ON criminal (identity_document_num, identity_document_date);

/*
Задание 5.
Заказчик хочет получить:
    1. ФИО (буквами нижнего регистра, со знаком '_' в качестве разделителя) преступников
    2. Названия улиц, в которых они орудуют
Напишите запрос, используя INNER JOIN
*/

--объединить таблицы criminal и street можно только 
--через таблицу gang_street_relation
--для удобства отсортируем запрос по ФИО
SELECT LOWER(CONCAT(last_name, '_', first_name, '_', middle_name)) as FIO, street_name
FROM criminal
INNER JOIN gang_street_relation USING(gang_id)
INNER JOIN street USING(street_id)
ORDER BY FIO;