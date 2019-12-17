--
-- RENEW_KLS_VETKA  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Vetka (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN
  UPDATE load_buffer.vetka SET vetka='<Ветка получателя>' WHERE vetka IS NULL;
  COMMIT;

--  UPDATE KLS_VETKA
--    SET vetka_name = (SELECT A.vetka FROM load_buffer.vetka A WHERE A.kod=KLS_VETKA.id)
--    WHERE EXISTS (SELECT B.kod FROM load_buffer.vetka B WHERE B.kod=KLS_VETKA.id);

  INSERT INTO KLS_VETKA (id, vetka_name) (SELECT C.kod, C.vetka FROM load_buffer.vetka C
    WHERE NOT EXISTS (SELECT D.id FROM KLS_VETKA D WHERE D.ID=C.KOD));

  COMMIT;

END Renew_Kls_Vetka;

/

