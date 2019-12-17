select * from DBA_HIST_SNAPSHOT order by begin_interval_time desc


select * from v_$logfile

select count(*) from all_constraints

select * from v_$log


select * from V_$ARCHIVED_LOG 
 
 



alter system switch logfile;

ALTER DATABASE DROP LOGFILE GROUP 7;

ALTER SYSTEM CHECKPOINT GLOBAL;

ALTER SYSTEM ARCHIVE LOG CURRENT


ALTER DATABASE ADD LOGFILE GROUP 7 ('D:\ORACLE\ORADATA\NB\REDO07.LOG') SIZE 100M REUSE;


Alter system set optimizer_secure_view_merging=FALSE scope=both;

Alter system set optimizer_mode=CHOOSE  scope=both; 


alter table KAZS_CHEQUE_PARAMS
  add constraint KAZS_CHEQUE_PARAMS_AK1 unique (ENTITY_TABLE_ID, ENTITY_TABLE_NAME, NAME)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 432M
    minextents 1
    maxextents unlimited
  );



BEGIN
  DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings(
    retention => NULL,        -- Minutes (= 30 Days). Current value retained if NULL.
    interval  => 30);          -- Minutes. Current value retained if NULL.
END;
/




select * from DBA_HIST_SQL_PLAN


select d.dbid            dbid
     , d.name            db_name
     , i.instance_number inst_num
     , i.instance_name   inst_name
  from v$database d,
       v$instance i;


SELECT 'define inst_num = '||TO_CHAR(i.instance_number)||';' from v$instance i
union all
SELECT 'define num_day=3;' from dual
union all
SELECT 'define inst_name = '||TO_CHAR(i.instance_name)||';' from v$instance i
union all
SELECT 'define db_name = '||TO_CHAR(d.name)||';' from v$database d
union all
SELECT 'define dbid = '||TO_CHAR(d.dbid)||';' from v$database d
union all
SELECT 'define begin_snap = '||TO_CHAR(min(snap_id))||';' from DBA_HIST_SNAPSHOT where begin_interval_time>=TO_DATE(:date1,'dd.mm.yyyy')
union all
SELECT 'define begin_snap = '||TO_CHAR(max(snap_id))||';' from DBA_HIST_SNAPSHOT where begin_interval_time>=TO_DATE(:date1,'dd.mm.yyyy')
union all
SELECT 'define report_type  = ''html'';' from dual
union all
SELECT 'define report_name  = GetAWR.html;' from dual





select min(snap_id) from 


EXEC DBMS_WORKLOAD_REPOSITORY.create_snapshot;

