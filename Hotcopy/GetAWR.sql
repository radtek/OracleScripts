WHENEVER SQLERROR CONTINUE

Connect / as sysdba

set echo off termout off heading off underline off;
set linesize 200
set pagesize 100

spool GetAWRExec.sql

SELECT 'define inst_num = '||TO_CHAR(i.instance_number)||';' from v$instance i
union all
SELECT 'define num_days=3;' from dual
union all
SELECT 'define inst_name = '||TO_CHAR(i.instance_name)||';' from v$instance i
union all
SELECT 'define db_name = '||TO_CHAR(d.name)||';' from v$database d
union all
SELECT 'define dbid = '||TO_CHAR(d.dbid)||';' from v$database d
union all
SELECT 'define report_type  = '''||'&3'||''';' from dual
union all
SELECT 'define begin_snap = '||TO_CHAR(min(snap_id+1))||';' from DBA_HIST_SNAPSHOT where begin_interval_time>=TO_DATE('&2','dd.mm.yyyy')-1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
union all
SELECT 'define end_snap = '||TO_CHAR(max(snap_id))||';' from DBA_HIST_SNAPSHOT where begin_interval_time<TO_DATE('&2','dd.mm.yyyy')+1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
union all
SELECT 'define report_name  = '||'&1'||'&4'||';' from dual
union all
SELECT '@@?/rdbms/admin/awrrpti;' from dual;

spool off

@@GetAWRExec.sql

exit


