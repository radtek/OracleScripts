--
-- RENEW_VAL_INT  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_val_int (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH')
          ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:=''
          , param2 VARCHAR2:=''
          , param3 VARCHAR2:='') IS
  date_inc DATE;
BEGIN

--- Добавляем 
INSERT /*+ APPEND*/ INTO MASTER.VAL_INT
     (
       DD_MM_YYYY,
       INTERV,
       N_INTER,
       SYB_RNK,
       N_OB,
       N_GR_INTEGR,
       VAR_VR_ZON,
       VR_ZON,
       KOL_DB,
       KOL,
       STAT,
       VAL,
       MIN_0,
       MIN_1,
       SK,
       RASH_POLN
     )
     (SELECT 
       DD_MM_YYYY,
       INTERV,
       N_INTER,
       SYB_RNK,
       N_OB,
       N_GR_INTEGR,
       VAR_VR_ZON,
       VR_ZON,
       KOL_DB,
       KOL,
       STAT,
       VAL,
       MIN_0,
       MIN_1,
       SK,
       RASH_POLN
      FROM load_buffer.VAL_INT A
      WHERE NOT EXISTS (SELECT NULL 
                          FROM MASTER.VAL_INT B 
                          WHERE A.dd_mm_yyyy=B.dd_mm_yyyy
                            AND A.syb_rnk=B.syb_rnk 
                            AND A.n_ob=B.n_ob 
                            AND A.n_gr_integr=b.n_gr_integr
                            AND A.Min_0=B.Min_0
                            AND A.Min_1=B.Min_1
                            ) AND A.Stat is not null
     );

COMMIT;

delete from master.val_int 
where dd_mm_yyyy < sysdate-7;

COMMIT;

END Renew_VAL_INT; 
/

