--
-- RENEW_KLS_INSURE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_KLS_INSURE (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
BEGIN
  UPDATE kls_insure
    set (insure_number,insure_date,full_sum,insure_year,insure_name)
	  = (SELECT num_dog,date_dog,IIF(full_sum,1,0),god_d,'?' FROM load_buffer.dog_stra WHERE dog_stra.id=kls_insure.id)
   WHERE EXISTS (SELECT A.id FROM load_buffer.dog_stra A WHERE A.id=kls_insure.id);

  INSERT INTO kls_insure (id,insure_year,insure_date,full_sum,insure_number,insure_name)
   (SELECT B.id,B.god_d,B.date_dog,IIF(B.full_sum,1,0),B.num_dog,'?' FROM load_buffer.dog_stra B
    WHERE not exists (SELECT A.id FROM kls_insure A WHERE A.id=B.id));
  COMMIT;
END RENEW_KLS_INSURE;

/

