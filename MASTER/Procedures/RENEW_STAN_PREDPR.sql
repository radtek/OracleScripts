--
-- RENEW_STAN_PREDPR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_STAN_PREDPR (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
BEGIN

  UPDATE stan_predpr
    set (predpr_gdkod) =
	    (SELECT DISTINCT A.gdkod FROM load_buffer.stan_predpr A
		 WHERE A.kod=stan_predpr.predpr_id AND
		       A.kst=stan_predpr.stan_id AND
			   A.kvet=stan_predpr.vetka_id)
    WHERE exists (SELECT * FROM load_buffer.stan_predpr B
              		 WHERE B.kod=stan_predpr.predpr_id AND
		                   B.kst=stan_predpr.stan_id AND
			               B.kvet=stan_predpr.vetka_id);

  INSERT INTO stan_predpr (predpr_id,stan_id,vetka_id,predpr_gdkod)
    (SELECT C.kod, C.kst, C.kvet, C.gdkod FROM load_buffer.stan_predpr C
      WHERE not exists (SELECT * FROM stan_predpr D
              		 WHERE C.kod=D.predpr_id AND
		                   C.kst=D.stan_id AND
			               C.kvet=D.vetka_id));

  COMMIT;

END RENEW_STAN_PREDPR;

/

