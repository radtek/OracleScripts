select 'GRANT '|| privilege || ' ON ' || grantor || '.' || table_name || ' TO ' || grantee || DECODE(grantable,'YES',' WITH GRANT OPTION','') || ';'
from dba_tab_privs where owner='SYS' 

select 'GRANT SELECT ON SYS.' || table_name || ' TO PARUS WITH GRANT OPTION;'
from dba_tables where owner='SYS' and table_name like '%$'

select 'GRANT SELECT ON SYS.' || view_name || ' TO PARUS WITH GRANT OPTION;'
from dba_views where owner='SYS' and view_name like 'EXU%'


select 'GRANT SELECT ON SYS.' || view_name || ' TO PARUS WITH GRANT OPTION;'
from dba_views where owner='SYS' and view_name like 'GV_$%'



GRANT SELECT ON SYS.table_privilege_map  TO PARUS WITH GRANT OPTION;
GRANT SELECT ON SYS.user_tab_columns TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.system_privilege_map TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.STMT_AUDIT_OPTION_MAP TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.audit_actions TO PARUS WITH GRANT OPTION;

GRANT SELECT ON sys.incfil TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.incexp TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.incvid TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.resource_map TO PARUS WITH GRANT OPTION;
GRANT SELECT ON sys.user_astatus_map TO PARUS WITH GRANT OPTION;



