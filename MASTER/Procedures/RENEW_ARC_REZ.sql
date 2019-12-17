--
-- RENEW_ARC_REZ  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Arc_Rez (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  new_DB DATE;
  new_DE DATE;
BEGIN

new_DB:=TO_DATE(TO_CHAR(date_beg,'dd.mm.yyyy') || ' 00:00','dd.mm.yyyy hh24:mi');
new_DE:=TO_DATE(TO_CHAR(date_end,'dd.mm.yyyy') || ' 23:59','dd.mm.yyyy hh24:mi');

--- Удаляем записи
DELETE FROM MASTER.ARC_REZ C WHERE C.dateupload BETWEEN new_DB AND new_DE AND ORG_STRU_ID=1;

UPDATE load_buffer.ARC_REZ_LOC SET NUM_REZ=' ' WHERE NUM_REZ IS NULL;
UPDATE load_buffer.ARC_REZ_LOC SET M_O=0 WHERE M_O IS NULL;
UPDATE load_buffer.ARC_REZ_LOC SET KOL_K=0 WHERE KOL_K IS NULL;
UPDATE load_buffer.ARC_REZ_LOC SET MAX_KOL=0 WHERE MAX_KOL IS NULL;
UPDATE load_buffer.ARC_REZ_LOC SET TIM_='00:01' WHERE TIM_='24:00';
UPDATE load_buffer.ARC_REZ_LOC SET TIM_='14:00' WHERE TIM_='014:0';

--- Добавляем
INSERT INTO MASTER.ARC_REZ
     (ORG_STRU_ID,DATEUPLOAD,REZ_NUM,REZ_NUM_UNP,VOL,MAX_VOL,DEAD_VOL,PRIM,DISP_NAME,AR_TOV_ID,PROD_ID_NPR,kol_lkrez)
     (SELECT 1,TO_DATE(TO_CHAR(AR.dat_,'dd.mm.yyyy ') || SUBSTR(AR.tim_,1,5),'dd.mm.yyyy hh24:mi'),
             AR.NUM_REZ,AR.N_REZ,sum(AR.KOL_K),sum(AR.MAX_KOL),sum(AR.M_O),AR.PRIM,AR.DISP,sum(AR.TOV_K),P.KOD,sum(ar.kol_lkrez)
        FROM load_buffer.arc_rez_loc AR,MASTER.V_PROD_OK P
       WHERE P.KOD_10=AR.OKP and AR.KOL_K<>0 AND
         NOT EXISTS (SELECT C.REZ_NUM FROM MASTER.ARC_REZ C
                   WHERE TO_DATE(TO_CHAR(AR.dat_,'dd.mm.yyyy ') || SUBSTR(AR.tim_,1,5),'dd.mm.yyyy hh24:mi')=C.DATEUPLOAD
                     AND AR.NUM_REZ=C.REZ_NUM
                     AND AR.TOV_K=C.AR_TOV_ID
                     AND P.KOD=C.PROD_ID_NPR
                       AND AR.KOL_K=C.VOL)
                       group by 1,TO_DATE(TO_CHAR(AR.dat_,'dd.mm.yyyy ') || SUBSTR(AR.tim_,1,5),'dd.mm.yyyy hh24:mi'),AR.NUM_REZ,AR.N_REZ,AR.PRIM,AR.DISP,P.KOD);

     COMMIT;
END Renew_Arc_Rez;
/

