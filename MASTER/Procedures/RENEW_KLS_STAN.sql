--
-- RENEW_KLS_STAN  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Stan(DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_STAN
    SET (stan_kod,stan_name,rast,region_id,aren_days,gdor_id,otdelenie,states_id) =
	    (SELECT A.kod, A.naim, A.rast, A.kobl, A.aren_days, A.kodgd, A.n_otd, A.kstran FROM load_buffer.stan A WHERE A.ID=KLS_STAN.ID)
    WHERE EXISTS (SELECT B.ID FROM load_buffer.stan B WHERE B.ID=KLS_STAN.ID);

  INSERT INTO KLS_STAN (ID, stan_kod, stan_name, rast, region_id, aren_days, gdor_id, otdelenie,states_id)
   (SELECT C.ID, C.kod, C.naim, C.rast, C.kobl, C.aren_days, C.kodgd, C.n_otd, C.kstran FROM load_buffer.stan C
    WHERE NOT EXISTS (SELECT D.ID FROM KLS_STAN D WHERE D.ID=C.ID));

  COMMIT;

END Renew_Kls_Stan;

/

