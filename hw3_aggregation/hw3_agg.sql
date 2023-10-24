/*1. Напишите запрос, возвращающий job_id и количество сотрудников этой профессии.
*/
--группирую по професси, считаю кол-во в группе
SELECT job_id, count(employee_id)
FROM employees
GROUP BY job_id;

/*
2. Найдите количество сотрудников, являющихся менеджерами.
*/
-- считаю уникальные ID менеджеров, кроме NULL
SELECT count(distinct(manager_id))
FROM employees
WHERE manager_id NOT IS NULL;

/*
3. Найдите разность между наибольшей и наименьшей зарплатой.
*/
--нахожу максимальную зп, минимальную зп и их разность
SELECT max(salary) - min(salary) AS difference
FROM employees;

/*
4. напишите запрос, возвращающий id менеджера и наименьшую зарплату его сотрудника.
*/
--группирую по менеджерам и нахожу минимальную зп его сотрудника
SELECT manager_id, min(salary)
FROM employees
GROUP BY manager_id;

/*
5. Напишите запрос, возвращающий id тех отделов 
в которых нет сотрудников с должностью ST_CLERK. 
Используйте операторы для работы с множествами.
*/
--Вывожу все отделы, вычитаю отделы, где есть клерки
--исключая сотрудников, у которыз нет отдела
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
	EXCEPT
SELECT department_id
FROM employees
WHERE job_id = 'ST_CLERK'
GROUP BY department_id;

/*
6. Выведите id и название стран, в которых нет ни одного отдела. 
Используйте операторы для работы с множествами.
*/
--Вывожу все страны, вычитаю страны, где есть отделы
SELECT country_id, country_name
FROM countries
	EXCEPT
SELECT countries.country_id, country_name
FROM countries
INNER JOIN locations ON countries.country_id = locations.country_id
INNER JOIN departments ON locations.location_id = departments.location_id
GROUP BY countries.country_id, country_name;

/*
7. Выведите список job_id и department_id для отделов 10, 50, 20. 
Сохраните порядок отделов как указано в условии задачи. 
Используйте операторы для работы с множествами.
*/
--Вывожу без повторений job_id и department_id, использую union all, чтобы сохранить порядок
SELECT distinct(job_id), department_id
FROM employees
WHERE department_id = 10
    UNION ALL
SELECT distinct(job_id), department_id
FROM employees
WHERE department_id = 50
    UNION ALL
SELECT distinct(job_id), department_id
FROM employees
WHERE department_id = 20;

/*
8. Выведите employee_id и job_id сотрудников, 
которые ранее имели ту-же должность, как и сейчас.
*/
--Нахожу пересечение между сотрудниками и работой сейчас и сотрудниками и работой раньше
SELECT employee_id, job_id
FROM employees
    INTERSECT
SELECT employee_id, job_id
FROM job_history;

/*
9. Выведите фамилии, id отдела 
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