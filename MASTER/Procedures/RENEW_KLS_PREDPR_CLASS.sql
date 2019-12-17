--
-- RENEW_KLS_PREDPR_CLASS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Predpr_class (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_PREDPR_CLASS
    SET (NAME, kod_stat, kod_mosc) =
        (SELECT naim, statistic, kod_mosc
           FROM load_buffer.predpr_i A WHERE TO_NUMBER(A.kod)=KLS_PREDPR_CLASS.ID)
   WHERE EXISTS (SELECT NULL FROM load_buffer.predpr_i B WHERE TO_NUMBER(B.kod)=KLS_PREDPR_CLASS.ID);

  COMMIT;

  INSERT INTO KLS_PREDPR_CLASS (ID, NAME, kod_stat, kod_mosc)
        (SELECT TO_NUMBER(C.kod), C.naim, C.statistic, C.kod_mosc 
	   FROM load_buffer.predpr_i C
	WHERE NOT EXISTS (SELECT NULL FROM KLS_PREDPR_CLASS D WHERE D.ID=TO_NUMBER(C.KOD)));

  COMMIT;

END Renew_Kls_Predpr_class;

/

