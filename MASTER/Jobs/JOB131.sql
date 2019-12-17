--
-- JOB131  (Job) 
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
     ,what      => 'master.FOR_PARUS.Renew_dog_PARUS;'
     ,next_date => SYSDATE+1/6
     ,interval  => 'SYSDATE+1/6'
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



