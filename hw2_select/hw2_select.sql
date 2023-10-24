/*1. Напишите запрос, возвращающий системную дату. Назовите колонку 'Date'.
*/
SELECT current_date as Date;

/*
2. Напишите запрос, возвращающий ID сотрудника, его имя и фамилию, 
текущую зарплату и зарплату, увеличенную на 15.5% (в виде целого числа). 
Назовите новую колонку 'New Salary'.
*/
SELECT employee_id, first_name, last_name, salary, 
	   ROUND(salary * 1.155) AS New_Salary
FROM employees;

/*
3. Напишите запрос, возвращающий ID сотрудника, его имя и фамилию, 
текущую зарплату и зарплату, увеличенную на 15.5% (в виде целлого числа) 
и разность между текущей зарплатой и зарплатой после увеличения. 
Назовите новые колонку 'New Salary' и 'Increase'.
*/
--На сколько увеличили, такая и разница
SELECT employee_id, first_name, last_name, salary, 
	   ROUND(salary * 1.155) AS New_Salary, 
	   ROUND(salary * 0.155) AS Increase
FROM employees;

/*
4. Напишите запрос, возвращающий фамилию сотрудника 
(первая буква должна быть большой, остальные - маленькими) 
и количество букв в фамилии для сотрудников, 
фамилии которых начинаются с 'J', 'A' или 'M'. 
Назовите колонки 'Name' и 'Length'. 
Отсортируйте результат по возрастанию длины фамилии. 
*/
--используем функцию, делающую первую букву в слове заглавной
--а остальные строчными
--в шаблоне прописываю буквы, с которых должна
--начинаться фамилия
SELECT initcap(last_name) AS Name,
	    length(last_name) AS Length
FROM employees
WHERE last_name SIMILAR TO '[JAM]%'
ORDER BY Length;

/*
5. Напишите запрос, возвращающий фамилию сотрудника (первая буква должна быть большой, 
остальные - маленькими) и количество букв в фамилии для сотрудников, 
фамилии которых начинаются с буквы, которую вводит пользователь. 
Назовите колонки 'Name' и 'Length'. Отсортируйте результат по возрастанию длины фамилии. 
Напишите запрос таким образом, чтобы его результат не зависел от решистра символов, 
в котором вводится буква.
*/
--вместо [a] любая буква, которая нужна пользователю
--чтобы запрос не зависел от регстра, перевожу все символы в фамилии
--в нижний регистр
SELECT initcap(last_name) AS Name,
	   length(last_name) AS Length
FROM employees
WHERE lower(last_name) SIMILAR TO '[a]%'
ORDER BY Length;

/*
6. Напишите запрос, возвращающий для всех сотрудников фамилию и количесво месяцев, 
в течение которого этот сотрудник работает в компании 
(округлите результат до ближайшего целого числа). 
Назовите колонку 'MONTH_WORKED'. Отсортируйте записи по возрастанию количества месяцев.
*/
--с помощью функции age() извлекаем год, месяц и день и переводим
--все в месяцы
SELECT last_name, 
	   (EXTRACT(year FROM now()) - EXTRACT(year FROM hire_date)) * 12 +
       EXTRACT(month FROM now()) - EXTRACT(month FROM hire_date) +
       ROUND((EXTRACT(day FROM now()) - EXTRACT(day FROM hire_date))/30)
       AS MONTH_WORKED
FROM employees
ORDER BY MONTH_WORKED;

/*
7. Напишите запрос возвращающий фамилию сотрудника и его зарплату. 
Отформатируйте колонку с зарплатой так, чтобы её длина составляла 15 символов, 
а недостающие символы заполнялись символом '$' слева от суммы запрлаты 
(например 24000 -> $$$$$$$$$$24000).
*/
--так как ограничение на 15 сиволов, то склеиваю доллары и зп
--и беру только 15 символов справа
SELECT last_name, 
       right('$$$$$$$$$$$$$$$' || round(salary), 15)
FROM employees;

/*
8. Напишите запрос, отображащий первые 8 символов фамилии пользователя и отображающий 
его зарплату в виде строки символов '*', где каждый символ соответствует 100$. 
Отсортируйте результат по убыванию зарплаты. 
Назовите полученную колонку 'EMLOYEES_AND_THEID_SALARIES'
*/
--делю зп на 100, так как только каждые 100$ это *
--первожу целочисленный тип в символьный, узнаю длину
--и беру * от кол-ва длины
SELECT left(last_name, 8) || 
       left('***********', length(trim(to_char(round(salary)/100, '999999999'))))
       AS EMPLOYEES_AND_THEID_SALARIES
FROM employees
ORDER BY salary DESC;

/*
9. Напишите запрос, возвращающий фамилии 
и количество недель работы сотрудников отдела с ID - 90. 
Назовите полученную колонку 'TENSURE' 
и преобразуйте её значение в целое, отбросив вещественную часть. 
Отсортируйте результат по убыванию 'TENSURE.
*/
--(current_date - hire_date) = кол-во отработанных дней
--делим на 7, чтобы получть недели
SELECT last_name, round((current_date - hire_date)/7) AS TENSURE
FROM employees
WHERE department_id = 90
ORDER BY TENSURE DESC;
/*
10. Напишите запрос, возвращающий строку следующего вида для каждого сотрудника: 
"<фамилия> зарабатывает <зарплата> каждый месяц, но хочет получать <зарплата * 3>". 
Назовите колонку 'Dream Salaries'
*/
SELECT last_name || ' зарабатывает ' || salary || ' каждый месяц, но хочет получать ' || salary*3
       AS Dream_Salaries
FROM employees

/*
11. Напишите запрос, возвращающий фамилию, 
дату устройства на работу и дату пересмотра зарплаты для каждого сотрудника. 
Дата пересмотра зарплаты - первый понедельник после 6 месяцев работы в компании. 
Назовите колонку 'REVIEW'. 
Отформатируйте значение этой колонки так, 
чтобы дата выводилась в виде строки "Monday, the Thirty-First of July, 2000"
*/
--возвращает нужную дату, но только числами, словами не получилось
SELECT last_name, hire_date, 
       hire_date + interval '6 month' + 
       CASE EXTRACT(DOW FROM hire_date + interval '6 month') 
            WHEN 0 THEN interval '1 day'
            WHEN 1 THEN interval '0 day'
            WHEN 2 THEN interval '6 day'
            WHEN 3 THEN interval '5 day'
            WHEN 4 THEN interval '4 day'
            WHEN 5 THEN interval '3 day'
            WHEN 6 THEN interval '2 day'
       END
       AS REWIEW
FROM employees

/*
12. Напишите запрос возвращающий фамилию сотрудника и размер комиссии. 
Если сотрудник не получает комиссию - выведите 'No Comission'. 
Назовите полуеченную колонку COMM.
*/
--привожу комиссию к типу char
SELECT last_name,
       case
           when commission_pct IS NOT NULL THEN to_char(commission_pct, '0.99')
           else 'No Comission'
       end COMM
FROM employees;

/*
13. Напишите запрос, возвращающий адреса всех департаментов. 
Запрос должен возвращать ID локации, адрес (улицу), город, штат и страну. 
Используйте NATURAL JOIN.
*/
select location_id, street_address, city, state_province, country_name
FROM locations
NATURAL JOIN countries;

/*
14. Напишите запрос, возвращающий 
фамилию, ID отдела и наименование отдела 
для каждого сотрудника;
*/
SELECT last_name, department_id, department_name
FROM employees
NATURAL JOIN departments;

/*
15. Напишите запрос, возвращающий 
фамилию, JOB_ID, ID отдела и название отдела 
для всех сотрудников из Торонто.
*/
SELECT last_name, job_id, department_id, department_name
FROM employees
	NATURAL JOIN departments
	NATURAL JOIN locations
WHERE city = 'Toronto';

/*
16. Напишите запрос, возвращающий фамилию, ID сотрудника, 
фамилию менеджера и ID менеджера для каждого сотрудника. 
Назовите колонки 'Employee', 'Emp#', 'Manager', 'Mgr#'.
*/
--мне дважды нужна одна и та же таблица, поэтому использую
--для них псевдонимы
--соединяю таблицы так, чтобы у каждого сотрудника
--в строке было и данные менеджера
SELECT empl.last_name AS Employee, 
	   empl.employee_id AS EMP, 
	   chief.last_name AS Manager, 
	   empl.manager_id AS Mgr
FROM employees AS empl
INNER JOIN employees AS chief ON chief.employee_id = empl.manager_id;

/*
17. Напишите запрос, возвращающий 
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
18. Напишите запрос, возвращающий 
ID отдела, фамилию сотрудника и фамилии всех сотрудников, 
работающих в том-же отделе. 
Назовите колонки 'DEPARTMENT', 'EMPLOYEE' и 'COLLEAGUE'.
*/
--соединяем сотрудников из таблицы по отделу, исключая тот момент
--что каждый сотрудник повториться дважды
SELECT emp.department_id AS DEPARTMENT, 
	   emp.last_name AS EMPLOYEE, 
	   col.last_name AS COLLEAGUE
FROM employees AS emp
INNER JOIN employees AS col 
	ON emp.department_id = col.department_id AND emp.employee_id <> col.employee_id;

/*
19. Напишите запрос, возвращающий 
фамилию и дату найма всех сотрудников, 
нанятых после David.
*/
--используем подзапрос, чтобы узнать
--когда наняли David
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                   FROM employees
                   WHERE last_name = 'David');

/*
20. Напишите запрос, возвращающий 
фамилию сотрудника, дату найма сотрудника, фамилию менеджера и дату найма менеджера 
для всех сотрудников, нанятых раньше, чем их менеджеры.
*/
--соединяем с собой таблицу employee сотрудника с его менеджером
--и смотрим кого наняли раньше, чем его менеджера
SELECT empl.last_name AS Employee, empl.hire_date AS Emp_hire_date, 
       chief.last_name AS Manager, chief.hire_date AS Chief_hire_date
FROM employees AS empl
INNER JOIN employees AS chief ON chief.employee_id = empl.manager_id
WHERE empl.hire_date < chief.hire_date;

/*
22. Напишите запрос, возвращающий ID сотрудника, фамилию и зарплату всех сотрудников, 
получающих зарплату больше средней по компании. 
Отсортируйте результат по возрастанию зарплаты. 
Используйте подзапрос.
*/
--вычисляем для запроса среднюю зп
SELECT last_name, salary
FROM employees
WHERE salary > (SELECT avg(salary)
                FROM employees);
				
/*
23. Напишите запрос, возвращающий ID сотрудника и фамилию всех сотрудников, 
работающих в одном отделе с работником, в чьей фамилии есть буква 'u'. 
Используйте подзапрос.
*/
--узнаем сначала список отделов, где работают такие люди
--выводим всех сотрудников из списка отделов
SELECT employee_id, last_name
FROM employees
WHERE department_id in (SELECT department_id
                        FROM employees
                        WHERE last_name SIMILAR TO '%[U,u]%');

/*
24. Напишите запрос, возвращающий фамилию, ID отдела и JOB_ID всех сотрудников, 
отдел которых расположен в локации с ID 1700. Используйте подзапрос.
*/
--ищем id отделов в локации 1700
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id in (SELECT department_id
                        FROM departments
                        WHERE location_id = 1700);

/*
25. Напишите запрос, возвращающий фамилии и зарплаты всех сотрудников, 
которые подчиняются сотруднику King. Используйте подзапрос.
*/
--находим id у King и далее его сотрудников
SELECT last_name, salary
FROM employees
WHERE manager_id in (SELECT employee_id
                     FROM employees
                     WHERE last_name = 'King');
					 
/*
26. Напишите запрос возвращающий ID отдела, 
фамилии и JOB_ID для всех сотрудников Executive department.
*/
--ищем id отдела с нужным именем
SELECT department_id, last_name, job_id
FROM employees
WHERE department_id = (SELECT department_id
                       FROM departments
                       WHERE department_name = 'Executive');
					   
/*
27. Напишите запрос, возвращающий фамилии всех сотрудников, 
получающих больше, чем любой сотрудник отдела с ID 6.
*/
-- ищем наивысшую зп в 6 отделе и выводим всех, у кого больше
SELECT last_name
FROM employees
WHERE salary > (SELECT max(salary)
                FROM employees
                WHERE department_id = 6);
				
/*
28. Напишите запрос, возвращающий ID, фамилии и зарплаты всех сотрудников, 
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
