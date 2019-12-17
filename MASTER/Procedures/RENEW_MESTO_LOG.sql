--
-- RENEW_MESTO_LOG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Mesto_Log(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  
/*  INSERT INTO MESTO_LOG (LOG_ID, LOG_INFO, DATE_LOG, PROG_NAME, MESTO_ID, EVENT_ID,  USER_ID)
  (SELECT A.log_ID, A.LOG_INFO, TO_DATE(TO_CHAR(A.log_date,'dd.mm.yyyy') || ' ' || A.log_time,'dd.mm.yyyy hh24:mi:ss'), A.PROG_NAME, A.MESTO, A.EVENT_ID, A.USER_ID FROM load_buffer.protokol A
    WHERE NOT EXISTS (SELECT B.log_id FROM MESTO_LOG B WHERE B.log_id=A.log_id));
*/
  COMMIT;

END Renew_Mesto_Log;

/

