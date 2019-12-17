SET LINESIZE 200
COLUMN SQL1 HEADING "--SQL1"
SET ECHO OFF

spool c:\tmp\clear_audit_user_tmp.sql;

select 'alter table '||table_owner||'.'||table_name||' truncate partition '||partition_name||' drop storage;' as SQL1 from ALL_TAB_PARTITIONS where table_owner in ('AUDIT_USER','AUDIT_USER_R3')  and PARTITION_NAME='M'||TO_CHAR(TO_NUMBER(TO_CHAR(ADD_MONTHS(sysdate,-6),'MM')));

spool off;

@c:\tmp\clear_audit_user_tmp.sql