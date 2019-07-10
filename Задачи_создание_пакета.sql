create or replace package EmployeWorks is

/*=================================
* Процедура повышения зарплаты на 5% и 3% в зависимости от первоначального значения
*=================================
*@автор Аксёнов А.Д.
*/
procedure UpSalary;

/*=================================
* Процедура вывода в сумм зарплат по каждому отделу
* Такой метод по заданию не требовался, однако просто посчитать сумму - скучно
*=================================
*@автор Аксёнов А.Д.
*/
procedure ShowSumSalaryForDep;

/*=================================
* Процедура вывода в суммы зарплаты по всем отделам
* Как я понимаю - из задачи требуется этот метод
*=================================
*@автор Аксёнов А.Д.
*/
procedure ShowSumSalary;

/*=================================
* Функция повышения зарплат и вывода разницы до и после повышения
*=================================
*@автор Аксёнов А.Д.
*@return новая сумма зарплат
*/  
function UpAndGetSalary return varchar2;

/*=================================
* Функция получения фамилии сотрудника по его номеру
*=================================
* @автор Аксёнов А.Д.
* @param pEmpId номер сотрудника
* @return новая сумма зарплат
*/ 
function GetEmloye(pEmpId number) return varchar2;

end EmployeWorks;



create or replace package body EmployeWorks is

procedure UpSalary
is
BEGIN
  update employe e set e.salary = case when e.salary<15000 then e.salary*1.05 else  e.salary*1.03 end;
END UpSalary;

procedure ShowSumSalaryForDep
is
BEGIN
  for r in (
    select d.depname, sum(e.salary) sal
    from department d
    left join employe e on e.depid = d.id
    group by d.depname)
  loop
    dbms_output.put_line('Отдел: '||r.depname||' | Сумма зарплат: '||r.sal);
  end loop;
  
END ShowSumSalaryForDep;

procedure ShowSumSalary 
is
  vSalarySum number;
BEGIN
  Select sum(e.salary) sal into vSalarySum
  from employe e;
  
  dbms_output.put_line(vSalarySum);
      
END ShowSumSalary;
  
function UpAndGetSalary return varchar2
is
  vSumSal varchar2(100);
  vStatus number;
BEGIN
  dbms_output.enable;
  
  UpSalary;
  ShowSumSalary;
  
  dbms_output.get_line(vSumSal,vStatus);
  
  if vStatus = 0 then
    return vSumSal;
  end if;
  
  return null;

END UpAndGetSalary;

function GetEmloye(pEmpID number) return varchar2
is
  vSurname varchar2(20);
BEGIN
  select e.firstname into vSurname
  from Employe e
  where e.empno = pEmpId;
  
  return vSurname;
  
  exception
    when NO_DATA_FOUND then
      return null;  
END GetEmloye;

end EmployeWorks;
