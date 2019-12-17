The ability to keep the contents of the alert log for a given database online is quite useful. It allows you to do string searches, write jobs to monitor for errors, etc. The following SQL code may be used to maintain an online table with the online contents of the current database alert log. 

-- Oracle9i Alert Log Loader
-- Now you can have your alert log available ONLINE!!
-- Used external tables and dynamic SQL. Only for Oracle9i!!

drop table e_alert_log;
drop table t_perm_alert_log;
drop table t_temp_alert_log;

create table e_alert_log
(detail_line     VARCHAR2(2000)
 ) ORGANIZATION EXTERNAL
 (TYPE oracle_loader
 DEFAULT DIRECTORY alert_dir
 ACCESS PARAMETERS
 (  RECORDS DELIMITED BY NEWLINE
    nobadfile 
    nologfile
    nodiscardfile
    FIELDS TERMINATED by '   '
    MISSING FIELD VALUES ARE NULL
    (detail_line ) 
)
 LOCATION('alert_prjd.log') )
 parallel 5
 REJECT LIMIT UNLIMITED;


create table t_perm_alert_log
(row_id          number,
 detail_line     varchar2(2000) ) 
tablespace users
storage (initial 1m next 1m pctincrease 0);

create table t_temp_alert_log
(row_id      number,
 detail_line varchar2(2000) ) 
tablespace users
storage (initial 1m next 1m pctincrease 0);

create or replace procedure update_alert as
BEGIN

-- This truncates the temp table from the last run...
execute immediate 'truncate table t_temp_alert_log';

-- Now, populate the temp table with all the alert log contents....
execute immediate 'insert into t_temp_alert_log select rownum, 
                   detail_line from e_alert_log';

-- Now, populate the perm table with just the changes.....
execute immediate 'insert into t_perm_alert_log select row_id, 
                   detail_line from t_temp_alert_log b
where b.row_id > (select nvl(max(a.row_id),0) from t_perm_alert_log a)';
END;
/
