--
-- T_PARUS_FIN_BINSERT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T_PARUS_FIN_BINSERT
BEFORE INSERT OR UPDATE
ON MASTER.PARUS_FIN
FOR EACH ROW
DECLARE
   tmpvar   NUMBER;
BEGIN
   tmpvar := 0;

   IF :NEW.ID IS NULL OR :NEW.ID = 0
   THEN
      SELECT seq_plan_refinery.NEXTVAL
        INTO tmpvar
        FROM DUAL;

      :NEW.ID := tmpvar;
   END IF;
END t_parus_fin_binsert;
/


