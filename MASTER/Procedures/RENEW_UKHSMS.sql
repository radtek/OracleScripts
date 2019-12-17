--
-- RENEW_UKHSMS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_UKHSMS (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='')IS
BEGIN
  execute immediate 'TRUNCATE TABLE LOAD_BUFFER.MASTER_FILES_UKHSMS';
     
  INSERT INTO LOAD_BUFFER.MASTER_FILES_UKHSMS
  select distinct terminal_name as netbios_name, SUBSTR(NLS_UPPER(appl_name),INSTR(NLS_UPPER(appl_name),'\',-1,1)+1,200) as filename 
  from MASTER.REPL_SESSION 
    where date_start>=TRUNC(add_months(sysdate,-3),'MONTH')
    and descript = 'ON SESSION LOGON'
    and appl_name is not null
    and appl_name <>'?'
  UNION 
  select distinct terminal_name as netbios_name, SUBSTR(NLS_UPPER(appl_name),INSTR(NLS_UPPER(appl_name),'\',-1,1)+1,200) as filename 
  from MASTER.REPL_SESSION@NB.WORLD
    where date_start>=TRUNC(add_months(sysdate,-3),'MONTH')
    and descript = 'ON SESSION LOGON'
    and appl_name is not null
    and appl_name <>'?';    
    
  COMMIT;
  
  FOR lcur IN (select * from LOAD_BUFFER.MASTER_FILES_UKHSMS) LOOP
     insert into master_files@kmisql3.world values (lcur.netbios_name,lcur.filename);
  END LOOP;  
  
  COMMIT;

 END RENEW_UKHSMS;
/

