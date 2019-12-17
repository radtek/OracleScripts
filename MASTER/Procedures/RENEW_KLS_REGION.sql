--
-- RENEW_KLS_REGION  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Region(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_REGION
    SET (region_name, short_name, kod_statistic, kod_moscow, okato, states_id) =
	    (SELECT A.naim, A.s_naim, TO_CHAR(A.kod_st), A.kod_mosk, A.okato, DECODE(A.kod_mosk,203,0,204,0,1) FROM load_buffer.region A WHERE A.kod=KLS_REGION.ID)
    WHERE EXISTS (SELECT B.kod FROM load_buffer.region B WHERE B.kod = KLS_REGION.ID);

  INSERT INTO KLS_REGION (ID,region_name,short_name,kod_statistic,kod_moscow,okato,states_id)
    SELECT C.kod, C.naim, C.s_naim, TO_CHAR(C.kod_st), C.kod_mosk, C.okato, DECODE(C.kod_mosk,203,0,204,0,1) FROM load_buffer.region C
    WHERE NOT EXISTS (SELECT D.ID FROM KLS_REGION D WHERE D.ID=C.KOD);

  COMMIT;

END Renew_Kls_Region;

/

