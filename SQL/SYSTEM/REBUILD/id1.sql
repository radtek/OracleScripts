set pages 9999;
set heading off;
set feedback off;
set echo off;
spool id4.sql; 
select '@id2.sql' from dual; 
select 'analyze index '||owner||'.'||index_name||' validate structure;',
'@id3.sql;'
from dba_indexes
where
owner not in ('SYS','SYSTEM');
select 'commit;' from dual; 
spool off; 
set heading on;
set feedback on;
set echo on;
