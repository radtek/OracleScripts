old  11: SELECT 'define report_type  = '''||'&3'||''';' from dual
new  11: SELECT 'define report_type  = '''||'text'||''';' from dual
old  13: SELECT 'define begin_snap = '||TO_CHAR(min(snap_id+1))||';' from DBA_HIST_SNAPSHOT where begin_interval_time>=TO_DATE('&2','dd.mm.yyyy')-1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
new  13: SELECT 'define begin_snap = '||TO_CHAR(min(snap_id+1))||';' from DBA_HIST_SNAPSHOT where begin_interval_time>=TO_DATE('10.07.2019','dd.mm.yyyy')-1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
old  15: SELECT 'define end_snap = '||TO_CHAR(max(snap_id))||';' from DBA_HIST_SNAPSHOT where begin_interval_time<TO_DATE('&2','dd.mm.yyyy')+1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
new  15: SELECT 'define end_snap = '||TO_CHAR(max(snap_id))||';' from DBA_HIST_SNAPSHOT where begin_interval_time<TO_DATE('10.07.2019','dd.mm.yyyy')+1 and begin_interval_time> (select startup_time from  v$instance i where rownum=1)
old  17: SELECT 'define report_name  = '||'&1'||'&4'||';' from dual
new  17: SELECT 'define report_name  = '||'c:\hotcopy\oradata\'||'awr.txt'||';' from dual

define inst_num = 1;                                                                                                                                                                                    
define num_days=3;                                                                                                                                                                                      
define inst_name = nb;                                                                                                                                                                                  
define db_name = NB;                                                                                                                                                                                    
define dbid = 2378935397;                                                                                                                                                                               
define report_type  = 'text';                                                                                                                                                                           
define begin_snap = 110965;                                                                                                                                                                             
define end_snap = 111029;                                                                                                                                                                               
define report_name  = c:\hotcopy\oradata\awr.txt;                                                                                                                                                       
@@?/rdbms/admin/awrrpti;                                                                                                                                                                                

10 rows selected.

