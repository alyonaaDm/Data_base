CREATE SCHEMA first_class;

select "current_schema"();

create table department
(
    id   serial primary key,
    name varchar
);

create table employee
(
    id            serial primary key,
    department_id int references department (id),
    chief_id      int,
    name          varchar,
    salary        int,
    FOREIGN KEY (chief_id) references employee (id)
);
alter table employee
    add constraint emp_constr check (id <> chief_id);

select currval('employee_id_seq');

select nextval('employee_id_seq');

insert into department(name)
values ('Отдел №1');

insert into department (name)
values ('Sales');
insert into department (name)
values ('Engineering');
insert into department (name)
values ('Training');
insert into department (name)
values ('Sales');
insert into department (name)
values ('Support');
insert into department (name)
values ('Sales');
insert into department (name)
values ('Business Development');
insert into department (name)
values ('Sales');
insert into department (name)
values ('Training');
insert into department (name)
values ('Engineering');

insert into employee (id, department_id, chief_id, name, salary)
values (1, 3, null, 'Fonzie', 46);
insert into employee (id, department_id, chief_id, name, salary)
values (2, 2, 1, 'Cathie', 9);
insert into employee (id, department_id, chief_id, name, salary)
values (3, 4, 1, 'Elston', 36);
insert into employee (id, department_id, chief_id, name, salary)
values (4, 5, 1, 'Esta', 10);
insert into employee (id, department_id, chief_id, name, salary)
values (5, 9, 1, 'Ruperto', 13);
insert into employee (id, department_id, chief_id, name, salary)
values (6, 7, 1, 'Marge', 99);
insert into employee (id, department_id, chief_id, name, salary)
values (7, 2, 6, 'Janey', 87);
insert into employee (id, department_id, chief_id, name, salary)
values (8, 2, 7, 'Kathleen', 69);
insert into employee (id, department_id, chief_id, name, salary)
values (9, 8, 1, 'Dylan', 37);
insert into employee (id, department_id, chief_id, name, salary)
values (10, 8, 1, 'Urbano', 2);
insert into employee (id, department_id, chief_id, name, salary)
values (11, 6, 1, 'Nissy', 87);
insert into employee (id, department_id, chief_id, name, salary)
values (12, 6, 1, 'Lela', 89);
insert into employee (id, department_id, chief_id, name, salary)
values (13, 3, 11, 'Jennette', 51);
insert into employee (id, department_id, chief_id, name, salary)
values (14, 10, 10, 'Cherice', 20);
insert into employee (id, department_id, chief_id, name, salary)
values (15, 10, 1, 'Tomi', 15);
insert into employee (id, department_id, chief_id, name, salary)
values (16, 9, 9, 'Rhoda', 1);
insert into employee (id, department_id, chief_id, name, salary)
values (17, 7, 7, 'Kinny', 66);
insert into employee (id, department_id, chief_id, name, salary)
values (18, 10, 7, 'Frannie', 29);
insert into employee (id, department_id, chief_id, name, salary)
values (19, 5, 3, 'Webb', 39);
insert into employee (id, department_id, chief_id, name, salary)
values (20, 2, 5, 'Shea', 43);
insert into employee (id, department_id, chief_id, name, salary)
values (21, 1, 19, 'Chrissie', 40);
insert into employee (id, department_id, chief_id, name, salary)
values (22, 1, 18, 'Benedick', 68);
insert into employee (id, department_id, chief_id, name, salary)
values (23, 8, 17, 'Kasper', 81);
insert into employee (id, department_id, chief_id, name, salary)
values (24, 10, 3, 'Tomi', 3);
insert into employee (id, department_id, chief_id, name, salary)
values (25, 10, 17, 'Reta', 96);
insert into employee (id, department_id, chief_id, name, salary)
values (26, 8, 2, 'Lorant', 71);
insert into employee (id, department_id, chief_id, name, salary)
values (27, 6, 2, 'Candi', 76);
insert into employee (id, department_id, chief_id, name, salary)
values (28, 6, 20, 'Delmer', 35);
insert into employee (id, department_id, chief_id, name, salary)
values (29, 7, 13, 'Isidoro', 14);

select *
from employee;
select *
from department;

insert into employee (department_id, chief_id, name, salary)
values (null, 8, 'Afton', 73);
insert into employee (department_id, chief_id, name, salary)
values (2, null, 'Afton2', 1000);

select setval('employee_id_seq', (select max(id) from employee));
select setval('department_id_seq', (select max(id) from employee));

-- -- -- -- -- HOMEWORK №1 -- -- -- -- --

create
or replace view employee_salary as
select e1.name,
       e1.salary as employee_salary,
       e2.salary as chief_salary,
       d.name    as departament_name
from employee as e1
         left join employee as e2 on e1.chief_id = e2.id
         join department d on d.id = e1.department_id
where e1.salary > e2.salary limit 10;

select *
from employee_salary;

--Вывести список сотрудников, получающих макс зп в своем отделе--
create
or replace view max_salary as
select e.name          as employee,
       e.salary        as employee_salary,
       e.department_id as dep_id
from employee as e
         join (select department_id, max(salary) as max_salary from employee group by department_id) m
              on e.salary = m.max_salary and e.department_id = m.department_id limit 10;

--Вывести список ID отделов, количество сотрудников в которых не превышает 3 человек--
create
or replace view three_employee as
select e.department_id as dep_id
from employee as e
         left join department d on e.department_id = d.id
group by e.department_id
having count(*) <= 3 limit 10;

--Вывести список сотрудников, не имеющих назначенного руководителя, работающего в том же отделе--
create
or replace view without_dep_chief as
select e1.name as employee_name,
       e1.department_id,
       e1.chief_id
from employee e1
         left join employee e2 on (e2.id = e1.chief_id and e2.department_id = e1.department_id)
where e2.id is null limit 10;

--Найти список ID отделов с максимальной суммарной зарплатой сотрудников--
create
or replace view dep_max_salary as
with sum_salary as (select e.department_id, sum(salary) as salary
                    from employee e
                    group by department_id)
select s.department_id
from sum_salary s
         join sum_salary on s.salary = (select max(salary) from sum_salary) limit 1;