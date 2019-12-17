--
-- RENEW_KLS_STATES  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_States(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_STATES
    SET (state_name, short_name, kod_statistic, kod_moscow, napr_id) =
	    (SELECT A.naim, A.s_naim, A.kod_st, A.kod_mosk, A.kod_napr FROM load_buffer.states A WHERE A.kod=KLS_STATES.id)
    WHERE EXISTS (SELECT B.kod FROM load_buffer.states B WHERE B.kod=KLS_STATES.id)
	  AND KLS_STATES.ID<>170;

  INSERT INTO KLS_STATES (id, state_name, short_name, kod_statistic, kod_moscow, napr_id)
   (SELECT C.kod, C.naim, C.s_naim, C.kod_st, C.kod_mosk, C.kod_napr FROM load_buffer.states C
    WHERE NOT EXISTS (SELECT D.id FROM KLS_STATES D WHERE D.ID=C.KOD));

  COMMIT;

END Renew_Kls_States;

/

