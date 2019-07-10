
--Вывести 1000 случайных чисел
-- Вариант 1
select mod(trunc(dbms_random.VALUE(level, level+3)), 1000) +1 val 
from dual connect by level <=1000
order by dbms_random.random();
 
--Вариант 2
CREATE TYPE tNumbers IS VARRAY(1000) OF NUMBER;
  Declare
    vRandomNumbers tNumbers := tNumbers();
    
    vI number :=1;
    vCheckNum number;
    vCheckRez number;
  Begin
    vRandomNumbers.EXTEND(1000);
    vRandomNumbers(vI):= trunc(DBMS_RANDOM.value(1,1000)); --первое число запишем в любом случае
    while (vI <=1000)
    loop
      vCheckNum := trunc(DBMS_RANDOM.value(1,1000));
      
      select count(*) into vCheckRez
      from table(vRandomNumbers) r
      where r.COLUMN_VALUE = vCheckNum;
        
      if vCheckRez <3 then
        dbms_output.put_line('vI='|| vI||'vCheckNum='||vCheckNum);              
        vRandomNumbers(vI) := vCheckNum;
        vI := vI+1;
      end if;
    end loop;
    
    --проверим, что нет значений повторяющихся более 3 раз
    for r in (
      select r.COLUMN_VALUE val, count(r.COLUMN_VALUE) cnt
      from table(vRandomNumbers) r
      group by r.COLUMN_VALUE
      having count(r.COLUMN_VALUE)>3) 
    loop
      dbms_output.put_line('r.val='||r.val||' r.cnt='||r.cnt);
    end loop;      
  End;
/
 -- DROP TYPE tNumbers FORCE;
 
 
--Удаление дублей
delete from t where rowid not in (
 select min(rowid) from t 
        group by a, b);
		

-- XML task a		
select * from
xmltable( 'root/row' 
passing 
xmltype('
<root>
  <row>
    <col>v11</col>
    <col>v12</col>
    <col>v13</col>
    <col>v14</col>
  </row>
  <row>
    <col>v21</col>
    <col>v22</col>
    <col>v23</col>
    <col>v24</col>
  </row>
</root>')
columns
 col1 varchar2 (10) path 'col[1]',
 col2 varchar2 (10) path 'col[2]',
 col3 varchar2 (10) path 'col[3]',
 col4 varchar2 (10) path 'col[4]');
 
 
 -- XML task b
 select 
 XMLQuery('for $i in $p/root/row
 for $r in $i/col 
 return <data row="{$i/position()}" col="{$r/position()}">{$r/text()}</data> '

 passing xmltype('
<root>
  <row>
    <col>v11</col>
    <col>v12</col>
    <col>v13</col>
    <col>v14</col>
  </row>
  <row>
    <col>v21</col>
    <col>v22</col>
    <col>v23</col>
    <col>v24</col>
  </row>
</root>') as "p" returning content )
from dual;

--XML task c
select xmltype('
<root>
  <row>
    <col>v11</col>
    <col>v12</col>
    <col>v13</col>
    <col>v14</col>
  </row>
  <row>
    <col>v21</col>
    <col>v22</col>
    <col>v23</col>
    <col>v24</col>
  </row>
</root>').transform(xmltype('<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:template match="root">
        <root>
            <xsl:apply-templates select="row"/>
        </root>
    </xsl:template>

    <xsl:template match="row">
      <xsl:apply-templates select="col">
        <xsl:with-param name="row" select="position()" />
      </xsl:apply-templates>  
    </xsl:template>
    
    <xsl:template match="col">
        <xsl:param name="row" />
        <data col="{position()}" row="{$row}">
            <xsl:value-of select="."/>
        </data>
    </xsl:template>

</xsl:stylesheet>'))
from dual;

--Коллекции
create or replace function Get_Collection return TNUM as
  vColect tnum;
begin
 
  select rownum r
    bulk collect
    into vColect
    from dual
  connect by rownum <= 1000;
 
  return vColect;
 
end Get_Collection;
/

--регулярные выражения
select regexp_substr(chars, '[^,]+', 1, 1) as c1,
       regexp_substr(chars, '[^,]+', 1, 2) as c2,
       regexp_substr(chars, '[^,]+', 1, 3) as c3,
       regexp_substr(chars, '[^,]+', 1, 4) as c4
  from (select '1,2,3,4' chars from dual) str;
 