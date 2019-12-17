--
-- RENEW_KLS_REGION_2  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Region_2(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  INSERT INTO KLS_REGION (ID,region_name,short_name,kod_moscow,states_id)
    SELECT 400+C.kod_t, C.naim_ter, C.naim_ter, TO_CHAR(C.kod_t), DECODE(C.kod_t,203,0,204,0,1) FROM load_buffer.kod_ter C
    WHERE NOT EXISTS (SELECT D.ID FROM KLS_REGION D WHERE TO_NUMBER(D.KOD_MOSCOW)=C.KOD_T);

  COMMIT;

END Renew_Kls_Region_2;

/

