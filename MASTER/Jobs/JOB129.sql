--
-- JOB129  (Job) 
--
DECLARE
  X NUMBER;
  user_name varchar2(30);
BEGIN
  select user into user_name from dual;
  execute immediate 'alter session set current_schema = MASTER';
  BEGIN
    SYS.DBMS_JOB.SUBMIT
    ( job       => X 
     ,what      => 'MASTER.FOR_TEMP.CLEAR_TEMP_VARI;'
     ,next_date => TRUNC(SYSDATE+1)
     ,interval  => 'TRUNC(SYSDATE+1)'
     ,no_parse  => TRUE
    );
    execute immediate 'alter session set current_schema = ' || user_name ;
  EXCEPTION
    WHEN OTHERS THEN 
      execute immediate 'alter session set current_schema = ' || user_name ;
      RAISE;
  END;
  COMMIT;
END;
/



