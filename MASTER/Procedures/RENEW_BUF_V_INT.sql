--
-- RENEW_BUF_V_INT  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_buf_v_int (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH')
          ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:=''
          , param2 VARCHAR2:=''
          , param3 VARCHAR2:='') IS
  date_inc DATE;
BEGIN

--- Добавляем 
INSERT /*+ APPEND*/ INTO MASTER.BUF_V_INT
     (
       SYB_RNK  
      ,N_OB         
      ,N_FID        
      ,N_GR_TY      
      ,N_SH         
      ,DD_MM_YYYY   
      ,N_INTER_RAS  
      ,KOL_DB       
      ,KOL          
      ,VAL          
      ,STAT         
      ,MIN_0        
      ,MIN_1        
      ,INTERV       
      ,AK_SUM       
      ,POK_START    
      ,RASH_POLN    
      ,IMPULSES     
     )
     (SELECT 
       SYB_RNK  
      ,N_OB         
      ,N_FID        
      ,N_GR_TY      
      ,N_SH         
      ,DD_MM_YYYY   
      ,N_INTER_RAS  
      ,KOL_DB       
      ,KOL          
      ,VAL          
      ,STAT         
      ,MIN_0        
      ,MIN_1        
      ,INTERV       
      ,AK_SUM       
      ,POK_START    
      ,RASH_POLN    
      ,IMPULSES
      FROM load_buffer.BUF_V_INT A
      WHERE NOT EXISTS (SELECT NULL 
                          FROM MASTER.BUF_V_INT B 
                          WHERE A.dd_mm_yyyy=B.dd_mm_yyyy
                            AND A.syb_rnk=B.syb_rnk 
                            AND A.n_ob=B.n_ob 
                            AND A.n_fid=b.n_fid
                            AND A.Min_0=B.Min_0
                            AND A.Min_1=B.Min_1
                            ) AND A.Stat is not null
     );
COMMIT;

delete from master.buf_v_int 
where dd_mm_yyyy < sysdate-7;

COMMIT;

END Renew_buf_V_INT; 
/

