--
-- RENEW_GR_INTEGR  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Gr_integr (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE GR_INTEGR B
    SET (
            ELEM_BAL, VID_OBEKT_RAB, VID_RASH, N_OB, SYB_RNK, N_GR_INTEGR, TYP_POK, INTERV, VAR_VR_ZON, DAT_START, DAT_END,            
            N_KON, TXT, KTO, DAT, N_GR_KON, SYB_RNK_K, N_OB_K, TYPE, AB            
           ) = (SELECT 
                    ELEM_BAL, VID_OBEKT_RAB, VID_RASH, N_OB, SYB_RNK, N_GR_INTEGR, TYP_POK, INTERV, VAR_VR_ZON, DAT_START, DAT_END,            
                    N_KON, TXT, KTO, DAT, N_GR_KON, SYB_RNK_K, N_OB_K, TYPE, AB            
                  FROM load_buffer.gr_integr A 
                  WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob AND A.syb_rnk=B.syb_rnk)           
   WHERE EXISTS (SELECT NULL FROM load_buffer.GR_INTEGR A WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob AND A.syb_rnk=B.syb_rnk);

  INSERT INTO GR_INTEGR (ELEM_BAL, VID_OBEKT_RAB, VID_RASH, N_OB, SYB_RNK, N_GR_INTEGR, TYP_POK, INTERV, VAR_VR_ZON, DAT_START, DAT_END,            
            N_KON, TXT, KTO, DAT, N_GR_KON, SYB_RNK_K, N_OB_K, TYPE, AB)
   (SELECT ELEM_BAL, VID_OBEKT_RAB, VID_RASH, N_OB, SYB_RNK, N_GR_INTEGR, TYP_POK, INTERV, VAR_VR_ZON, DAT_START, DAT_END,            
            N_KON, TXT, KTO, DAT, N_GR_KON, SYB_RNK_K, N_OB_K, TYPE, AB 
        FROM load_buffer.GR_INTEGR A
       WHERE NOT EXISTS (SELECT NULL FROM GR_INTEGR B WHERE A.n_gr_integr=b.n_gr_integr AND A.n_ob=B.n_ob AND A.syb_rnk=B.syb_rnk)
   );
  
  COMMIT;

END Renew_GR_INTEGR;
/

