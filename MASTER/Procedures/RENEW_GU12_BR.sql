--
-- RENEW_GU12_BR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_GU12_BR (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
  IsFull NUMBER(1);
BEGIN
  RETURN;

-- Обновление рейсов  
  UPDATE /*+ RULE */ GU12_BR
    SET (ID_B, DATE_R, KOL_VAG, VES) =
	(SELECT 
	   B.ID,DATE_R,SUM(KOL),SUM(A.VES)
     FROM load_buffer.gu12br A, GU12_B B 
    WHERE A.time_ap=B.fox_kod AND B.ID=GU12_BR.ID_B AND A.DATE_R=GU12_BR.DATE_R
	GROUP BY B.ID,DATE_R
	) 
   WHERE EXISTS (SELECT NULL FROM load_buffer.gu12br A, GU12_B B 
    WHERE A.time_ap=B.fox_kod AND B.ID=GU12_BR.ID_B AND A.DATE_R=GU12_BR.DATE_R);

-- Добавление рейсов   
  INSERT INTO GU12_BR
    (ID_B, DATE_R, KOL_VAG, VES)
	(SELECT /*+ RULE */ B.ID, DATE_R, SUM(A.KOL) as KOL, SUM(A.VES) as VES
     FROM load_buffer.gu12br A, GU12_B b
     WHERE A.time_ap=B.fox_kod
       AND NOT EXISTS (SELECT null FROM GU12_BR C WHERE C.ID_B=b.ID and C.DATE_R=A.DATE_R)
     GROUP BY B.ID, DATE_R);
		 
-- Удаление заявок (на сутки)
  DELETE FROM /*+ RULE */ GU12_BR WHERE NOT EXISTS
      (SELECT NULL FROM load_buffer.gu12br A, gu12_b B WHERE A.time_ap=B.fox_kod AND B.ID=GU12_BR.ID_B AND A.DATE_R=GU12_BR.DATE_R)
	  AND GU12_BR.DATE_R BETWEEN date_beg AND date_end;

  COMMIT;

END Renew_GU12_BR;

/

