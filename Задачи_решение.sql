create table Employe (
       Empno number(5) primary key,
       DepID number(5)  not null,
       FirstName varchar2(20) not null,
       SecondName varchar2 (20) not null,
       Patronymic varchar2 (20),
       PositionId number (2) not null,
       Birthday date,
       Salary number(10) not null
);

create table Department(
       ID number (5) primary key,
       DepName varchar2(50) not null
);

create table Position (
       ID number(2) primary key,
       Nane varchar2(50)
);

CREATE SEQUENCE EmployeEmpNo
minvalue 1
maxvalue 99999
start with 1
increment by 1
cache 20;


create or replace trigger Employe_BIU
  before insert or update
  on employe 
  for each row
begin
  if mod(:new.salary, 100) > 0 then
    raise_application_error(-20001, 'Заработная плата должна быть кратна 100');
  end if;
  
  if :new.empno is null then
    :new.empno := EmployeEmpNo.Nextval;
  end if;
  
end Employe_BIU;


insert into Department (id, DepName) values (1, 'Отдел маркетинга');
insert into Department (id, DepName) values (2, 'Отдел продаж');
insert into Department (id, DepName) values (3, 'Отдел закупок');

insert into Position (Id, Nane) values (1, 'Служащий');
insert into Position (Id, Nane) values (2, 'Руководитель группы');
insert into Position (Id, Nane) values (3, 'Начальник отдела');

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (1, 'Иванов','Иван','Иванычь', 1, 13000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (1, 'Лямдов','Арсен','Прыгучев', 1, 13000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (1, 'Петров','Иван','Арсеньевич', 2, 16000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (1, 'Губов','Машин','Закатывич', 3, 50000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (2, 'Самойлов','Иван','Петрович', 1, 12000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (2, 'Новичков','Ктото','Санькович', 1, 14000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (2, 'Командиров','Игнат','Васильевич', 2, 17000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (2, 'Шальнова','Алёна',null, 3, 50000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (3, 'Андреева','Инга','Петрова', 1, 12000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (3, 'Васильев','Василий','Иванычь', 1, 12500); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (3, 'Альпова','Юлия','Михайловна', 2, 20000); 

insert into Employe (DepID, FirstName, SecondName, Patronymic, PositionId, Salary)
values (3, 'Зюзин','Зюзь','Павлович', 3, 45000); 


select d.depname DepName, e.firstname||' '||e.secondname||' '||e.patronymic FIO 
from department d
left join Employe e on e.depid = d.id
order by 1, 2