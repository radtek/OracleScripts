--
-- JOB141  (Job) 
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
     ,what      => '
begin
  LINK_UNP_TO_SNP_AUTO(trunc(trunc(sysdate,''month'')-1,''month''));
end;  

begin
  LINK_UNP_TO_SNP_AUTO(trunc(sysdate,''month''));
end;  '
     ,next_date => SYSDATE+30/1440 
     ,interval  => 'SYSDATE+30/1440 '
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



