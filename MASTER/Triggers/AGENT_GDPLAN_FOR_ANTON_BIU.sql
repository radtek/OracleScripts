--
-- AGENT_GDPLAN_FOR_ANTON_BIU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.AGENT_GDPLAN_FOR_ANTON_BIU
BEFORE INSERT OR UPDATE
ON MASTER.AGENT_GDPLAN_FOR_ANTON
FOR EACH ROW
BEGIN
  :NEW.tarif:=0;
  FOR lcur IN (SELECT date_kvit,num_kvit,kvit.nom_zd FROM kvit,month,kls_prod 
   WHERE kvit.PROD_ID_NPR=kls_prod.ID_NPR 
    AND kls_prod.PROD_PLAN_ID=TO_NUMBER(:NEW.prod_npr_id) 
	AND kvit.NOM_ZD=month.NOM_ZD
	AND month.STAN_ID=:NEW.stan_id
	AND kvit.tarif<>0
	AND kvit.date_kvit<:NEW.date_plan
	ORDER BY kvit.ID DESC) LOOP
    BEGIN
	  FOR lcur2 IN (SELECT SUM(tarif_orig) AS tarif,SUM(ves) AS ves FROM kvit WHERE
	    nom_zd=lcur.nom_zd AND
		num_kvit=lcur.num_kvit AND
		date_kvit=lcur.date_kvit) LOOP
   	  
	    :NEW.tarif:=:NEW.ves*lcur2.tarif/lcur2.ves;
  	    EXIT;
      END LOOP;	
	  EXIT;
    END;
  END LOOP;
END AGENT_GDPLAN_FOR_ANTON_BIU;
/


