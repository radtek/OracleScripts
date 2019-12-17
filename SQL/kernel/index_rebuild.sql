-- Выполнить сразу
select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace IDX LOGGING;'
  from sys.all_indexes
    where tablespace_name = 'USERS'
    
    and  table_name  not like '%DOCUM%'
    
    and num_rows<300000000 and num_rows>0


--

select 'alter table '||owner||'.'||table_name||' truncate partition M5 drop storage;'
from sys.all_tables
  where owner = 'AUDIT_USER_R3' 



  select *  from sys.all_tables where logging='NO'
  
  
  alter table set logging='YES' where logging='NO' and owner='LIDER'
  
  
select 'alter index '||owner||'.'||index_name||' LOGGING;'
from sys.all_indexes
where logging='NO' and owner<>'R3' and  temporary<>'Y'


select 'alter table '||owner||'.'||table_name||' LOGGING;'
from sys.all_tables
where logging='NO' and temporary<>'Y'


alter index FBU_VNP1C8.RN_V LOGGING;

alter index FBU_VNP1C8.AZS_R_PK LOGGING;