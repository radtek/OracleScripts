--
-- RENEW_VAL_INT_D  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_val_int_d (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
BEGIN

--- Обновляем 
/*UPDATE MASTER.VAL_INT_D B SET
  (
    DD_MM_YYYY, SYB_RNK, N_OB, N_GR_INTEGR, KOL_DB, KOL, NET_INT, VAL, STAT, KOL_DB_BP, KOL_BP, VAL_BP, RS, VAL_PR, R              
  )
 = (SELECT 
        DD_MM_YYYY, SYB_RNK, N_OB, N_GR_INTEGR, KOL_DB, KOL, NET_INT, VAL, STAT, KOL_DB_BP, KOL_BP, VAL_BP, RS, VAL_PR, R              
      FROM load_buffer.VAL_INT_D A
    WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob AND A.syb_rnk=B.syb_rnk AND A.dd_mm_yyyy=B.dd_mm_yyyy)
 WHERE EXISTS (SELECT NULL FROM load_buffer.VAL_INT_D A WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob AND A.syb_rnk=B.syb_rnk AND A.dd_mm_yyyy=B.dd_mm_yyyy);
*/

--- Добавляем 
INSERT /*+ APPEND*/ INTO MASTER.VAL_INT_D
     (
      DD_MM_YYYY, SYB_RNK, N_OB, N_GR_INTEGR, KOL_DB, KOL, NET_INT, VAL, STAT, KOL_DB_BP, KOL_BP, VAL_BP, RS, VAL_PR, R
     )
     (SELECT 
          DD_MM_YYYY, SYB_RNK, N_OB, N_GR_INTEGR, KOL_DB, KOL, NET_INT, VAL, STAT, KOL_DB_BP, KOL_BP, VAL_BP, RS, VAL_PR, R
       FROM load_buffer.VAL_INT_D A
       WHERE NOT EXISTS (SELECT NULL FROM MASTER.VAL_INT_D B 
       WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob 
       AND A.syb_rnk=B.syb_rnk AND A.dd_mm_yyyy=B.dd_mm_yyyy) and A.DD_MM_YYYY<SYSDATE-1
     ) ;
COMMIT;

delete from master.val_int_d
where dd_mm_yyyy < sysdate-7;

COMMIT;

END Renew_VAL_INT_D; 
/

