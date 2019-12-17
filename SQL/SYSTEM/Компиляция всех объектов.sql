Spool c:\aa.lst

select distinct 'ALTER '||object_type||' '||owner||'.'||object_name||' compile;'
from all_objects
where object_type like 'TRIGGER' 
and status = 'INVALID'
/

select distinct 'ALTER '||object_type||' '||owner||'.'||object_name||' compile;'
from all_objects
where object_type like 'VIEW' 
and status = 'INVALID'
/

select distinct 'ALTER '||object_type||' '||owner||'.'||object_name||' compile;'
from all_objects
where object_type not like 'PACKAGE BODY' 
and object_type not like 'TRIGGER'  
and object_type not like 'VIEW'  
and status = 'INVALID'
/

select distinct 'ALTER package '||owner||'.'||object_name||' compile body;'
from all_objects
where object_type = 'PACKAGE BODY' 
and status = 'INVALID'
/

spool off

@c:\aa.lst

