
/*
1. Напишите запрос, возвращающий строку следующего вида для каждого сотрудника: 
"<фамилия> зарабатывает <зарплата> каждый месяц, но хочет получать <зарплата * 3>". 
Назовите колонку 'Dream Salaries'. 
Результат сохранить в формате parquet со сжатием GZIP

1. Напишите запрос, возвращающий строку следующего вида для каждого сотрудника: 
"<фамилия> зарабатывает <зарплата> каждый месяц, но хочет получать <зарплата * 3>". 
Назовите колонку 'Dream Salaries'
*/
SELECT last_name || ' зарабатывает ' || salary || ' каждый месяц, но хочет получать ' || salary*3
       AS Dream_Salaries
FROM employees

/*
2. Напишите запрос, возвращающий адреса всех департаментов. 
Запрос должен возвращать ID локации, адрес (улицу), город, штат и страну.


2. Напишите запрос, возвращающий адреса всех департаментов. 
Запрос должен возвращать ID локации, адрес (улицу), город, штат и страну. 
---поменять на inner
*/
select location_id, street_address, city, state_province, country_name
FROM locations
NATURAL JOIN countries;

/*
3. Напишите запрос, возвращающий 
фамилию, ID отдела и наименование отдела 
для каждого сотрудника; 
Результат сохранить в формате avro со сжатием GZIP

3. Напишите запрос, возвращающий 
фамилию, ID отдела и наименование отдела 
для каждого сотрудника;
---поменять на inner
*/
SELECT last_name, department_id, department_name
FROM employees
NATURAL JOIN departments;

/*
4. Напишите запрос, возвращающий 
фамилию, ID сотрудника, фамилию менеджера и ID менеджера 
для каждого сотрудника 
(для сотрудников, у которых нет менеджера, в этих колонках должен быть NULL). 
Назовите колонки 'Employee', 'Emp#', 'Manager', 'Mgr#'. 
Результат сохранить в формате avro со сжатием Snappy

4. Напишите запрос, возвращающий 
фамилию, ID сотрудника, фамилию менеджера и ID менеджера 
для каждого сотрудника 
(для сотрудников, у которых нет менеджера, в этих колонках должен быть NULL). 
Назовите колонки 'Employee', 'Emp#', 'Manager', 'Mgr#'.
*/
--то же, что и в предыдущем задании, только 
--для доп условия используем LEFT JOIN
SELECT empl.last_name AS Employee, 
	   empl.employee_id AS EMP, 
	   chief.last_name AS Manager, 
	   empl.manager_id AS Mgr
FROM employees AS empl
LEFT JOIN employees AS chief ON chief.employee_id = empl.manager_id;

/*
5. Напишите запрос, возвращающий фамилии и зарплаты всех сотрудников, 
которые подчиняются сотруднику King. Используйте подзапрос.

5. Напишите запрос, возвращающий фамилии и зарплаты всех сотрудников, 
которые подчиняются сотруднику King. Используйте подзапрос.
*/
--находим id у King и далее его сотрудников
SELECT last_name, salary
FROM employees
WHERE manager_id in (SELECT employee_id
                     FROM employees
                     WHERE last_name = 'King');
					 
/*
6. Напишите запрос, возвращающий фамилии всех сотрудников, 
получающих больше, чем любой сотрудник отдела с ID 60.

6. Напишите запрос, возвращающий фамилии всех сотрудников, 
получающих больше, чем любой сотрудник отдела с ID 60.
---Заменить на отдел 60
*/
-- ищем наивысшую зп в 6 отделе и выводим всех, у кого больше
SELECT last_name
FROM employees
WHERE salary > (SELECT max(salary)
                FROM employees
                WHERE department_id = 60);
				
/*
7. Напишите запрос, возвращающий ID, фамилии и зарплаты всех сотрудников, 
работающих в одном отделе с работником, 
в чьей фамилии есть буква 'u' и получающих больше средней зарплаты в компании.


7. Напишите запрос, возвращающий ID, фамилии и зарплаты всех сотрудников, 
работающих в одном отделе с работником, 
в чьей фамилии есть буква 'u' и получающих больше средней зарплаты в компании. 
Используйте подзапрос.*/
--используем запросы из прошлых заданий
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id in (SELECT department_id
                        FROM employees
                        WHERE last_name SIMILAR TO '%[U,u]%')
      AND salary > (SELECT avg(salary)
                    FROM employees);
					
/*
8. Выведите фамилии, id отдела 
и название отдела для всех сотрудников, не привязанных ни к одному отделу, 
а также список отделов, к которым не привязан ни один сотрудник. 
Используйте операторы для работы с множествами.
*/
--сначала нахожу сотрудников, не привязанных к отделу,
--потом нахожу отделы, в которых нет сотрудников
SELECT last_name, employees.department_id, department_name
FROM employees
LEFT JOIN departments 
	ON employees.department_id = departments.department_id
WHERE employees.department_id IS NULL
    UNION
SELECT last_name, employees.department_id, department_name
FROM departments
LEFT JOIN employees 
	ON employees.department_id = departments.department_id
WHERE employees.last_name IS NULL;