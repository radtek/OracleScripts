--
-- RENEW_REESTR_IN  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Reestr_in (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  vTmp NUMBER;
BEGIN

return;

update load_buffer.sv2_oil set gotov=0 where gotov=24;
update load_buffer.sv2_oil set n_nal=0 where n_nal=24;
update load_buffer.sv2_oil set k_nal=0 where k_nal=24;
 

-- Добавляем вагоны в справочник вагонов
INSERT /*+ APPEND*/ INTO MASTER.KLS_CIST
  (NUM_CIST, VAGONTYPE_ID)
  (SELECT DISTINCT k.n_cis,6
   FROM load_buffer.sv2_oil k 
   WHERE NOT EXISTS (SELECT NULL FROM MASTER.KLS_CIST A WHERE A.NUM_CIST=k.n_cis));

--- Обновляем SVED_IN
UPDATE MASTER.SVED_IN a SET
  (SVED_NUM, SVED_DATE, GOTOV_TIME, BEG_NALIV_TIME, END_NALIV_TIME, DATE_OFORML, 
   PROD_ID_NPR, MESTO_ID, PASP_NUM, REZ_NUM, PASP_DATE, PL, PL15, P_VOD, P_DIRT, MG_SOL, P_SOL)=
  (SELECT MAX(SVED_NUM) as SVED_NUM, MAX(SVED_DATE) as SVED_DATE,  
     MAX(GOTOV_TIME) as GOTOV_TIME, MAX(BEG_NALIV_TIME) as BEG_NALIV_TIME, 
	 MAX(END_NALIV_TIME) as END_NALIV_TIME, MAX(DATE_OFORML) as DATE_OFORML, 
     MAX(PROD_ID_NPR) as PROD_ID_NPR, MAX(MESTO_ID) as MESTO_ID, 
	 MAX(PASP_NUM) as PASP_NUM, MAX(REZ_NUM) as REZ_NUM, 
	 MAX(PASP_DATE) as PASP_DATE, MAX(DECODE(NVL(CTL,0),0,PL,0)) as PL, MAX(DECODE(NVL(CTL,0),0,0,PL)) as PL15, 
	 MAX(P_VOD) as P_VOD, MAX(P_DIRT) as P_DIRT, 
	 MAX(MG_SOL) as MG_SOL, MAX(P_SOL) as P_SOL
   FROM (	 
     SELECT 
       SUBSTR((CASE WHEN data<TO_DATE('01.01.2006','dd.mm.yyyy') THEN 'o' ELSE 'oo' END)||TO_CHAR(k.id_n),1,9) as ID, k.CTL,
	   np as SVED_NUM, data as SVED_DATE, k.ves_cis as VES,  
	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(gotov),'09')||':'||TO_CHAR(MOD(gotov*100,100),'09'),'dd.mm.yyyy hh24:mi') as GOTOV_TIME,
	   (CASE
	     WHEN n_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(n_nal),'09')||':'||TO_CHAR(MOD(n_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(n_nal),'09')||':'||TO_CHAR(MOD(n_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as BEG_NALIV_TIME,	   
	   (CASE
	     WHEN k_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as END_NALIV_TIME,	   
	   (CASE
	     WHEN k_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as DATE_OFORML,
   	   p.ID_NPR as PROD_ID_NPR,1 as MESTO_ID, k.NETTO_OIL as VES_NETTO,
	   k.N_PAS as PASP_NUM, '' as REZ_NUM, k.data as PASP_DATE, k.U_VES as PL, k.P_VOD, k.M_PRIM as P_DIRT,
	   k.CLOR as MG_SOL, k.PROCENT_CL as P_SOL
     FROM load_buffer.sv2_oil k, kls_prod p 
     WHERE k.sh_npr=p.unp_id
   ) sv
   WHERE sv.ID=a.ID
   GROUP BY ID 
  )
WHERE EXISTS
  ( SELECT NULL 
     FROM load_buffer.sv2_oil k, kls_prod p 
     WHERE k.sh_npr=p.unp_id AND SUBSTR((CASE WHEN data<TO_DATE('01.01.2006','dd.mm.yyyy') THEN 'o' ELSE 'oo' END)||TO_CHAR(k.id_n),1,9)=a.ID 
  );

--- Добавляем в SVED_IN
INSERT INTO MASTER.SVED_IN
  (ID, SVED_NUM, SVED_DATE, GOTOV_TIME, BEG_NALIV_TIME, END_NALIV_TIME, DATE_OFORML, 
   PROD_ID_NPR, MESTO_ID, PASP_NUM, REZ_NUM, PASP_DATE, PL, PL15, P_VOD, P_DIRT, MG_SOL, P_SOL)
  (SELECT ID, MAX(SVED_NUM) as SVED_NUM, MAX(SVED_DATE) as SVED_DATE,  
     MAX(GOTOV_TIME) as GOTOV_TIME, MAX(BEG_NALIV_TIME) as BEG_NALIV_TIME, 
	 MAX(END_NALIV_TIME) as END_NALIV_TIME, MAX(DATE_OFORML) as DATE_OFORML, 
     MAX(PROD_ID_NPR) as PROD_ID_NPR, MAX(MESTO_ID) as MESTO_ID, 
	 MAX(PASP_NUM) as PASP_NUM, MAX(REZ_NUM) as REZ_NUM, 
	 MAX(PASP_DATE) as PASP_DATE, MAX(DECODE(NVL(CTL,0),0,PL,0)) as PL, MAX(DECODE(NVL(CTL,0),0,0,PL)) as PL15, 
	 MAX(P_VOD) as P_VOD, MAX(P_DIRT) as P_DIRT, 
	 MAX(MG_SOL) as MG_SOL, MAX(P_SOL) as P_SOL
   FROM (	 
     SELECT 
       SUBSTR((CASE WHEN data<TO_DATE('01.01.2006','dd.mm.yyyy') THEN 'o' ELSE 'oo' END)||TO_CHAR(k.id_n),1,9) as ID,k.CTL,
	   np as SVED_NUM, data as SVED_DATE, k.ves_cis as VES,  
	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(gotov),'09')||':'||TO_CHAR(MOD(gotov*100,100),'09'),'dd.mm.yyyy hh24:mi') as GOTOV_TIME,
	   (CASE
	     WHEN n_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(n_nal),'09')||':'||TO_CHAR(MOD(n_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(n_nal),'09')||':'||TO_CHAR(MOD(n_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as BEG_NALIV_TIME,	   
	   (CASE
	     WHEN k_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as END_NALIV_TIME,	   
	   (CASE
	     WHEN k_nal<gotov THEN
     	   TO_DATE(TO_CHAR(data+1,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
		 ELSE  
     	   TO_DATE(TO_CHAR(data,'dd.mm.yyyy ') || TO_CHAR(FLOOR(k_nal),'09')||':'||TO_CHAR(MOD(k_nal*100,100),'09'),'dd.mm.yyyy hh24:mi')
	    END) as DATE_OFORML,
   	   p.ID_NPR as PROD_ID_NPR,1 as MESTO_ID, k.NETTO_OIL as VES_NETTO,
	   k.N_PAS as PASP_NUM, '' as REZ_NUM, k.data as PASP_DATE, k.U_VES as PL, k.P_VOD, k.M_PRIM as P_DIRT,
	   k.CLOR as MG_SOL, k.PROCENT_CL as P_SOL
     FROM load_buffer.sv2_oil k, kls_prod p 
     WHERE k.sh_npr=p.unp_id
   ) sv
   WHERE NOT EXISTS (SELECT NULL FROM MASTER.SVED_IN A WHERE A.ID=sv.ID)
   GROUP BY ID 
  );

--- Обновляем REESTR
UPDATE MASTER.REESTR_IN SET
  (SVED_IN_ID, DATE_OTGR, NUM_CIST,  
   KALIBR_ID, VES_CIST, CAPACITY, VZLIV, TEMPER, FAKT_PL, VES, VES_NETTO, VOLUME, VOLUME15, CTLV, GOST_ID)
= (SELECT 
     SUBSTR((CASE WHEN data<TO_DATE('01.01.2006','dd.mm.yyyy') THEN 'o' ELSE 'oo' END)||TO_CHAR(k.id_n),1,9),k.DATA,k.n_cis, 
     k.tip_cis, FOR_CIST.GET_VES_CIST(k.n_cis), FOR_CIST.GET_CAPACITY(k.n_cis),  
     k.v_vzl, k.t_pa, k.pogr, k.ves_cis/1000, k.netto_oil/1000,
	 k.OBM20, k.OBM15, k.CTL, DECODE(NVL(k.CTL,0),0,0,1)
    FROM load_buffer.sv2_oil k, kls_prod p 
    WHERE k.sh_npr=p.unp_id AND k.id_n*100000+k.id_c=MASTER.REESTR_IN.ID)
WHERE EXISTS 
  (SELECT NULL 
    FROM load_buffer.sv2_oil k, kls_prod p 
    WHERE k.sh_npr=p.unp_id AND k.id_n*100000+k.id_c=MASTER.REESTR_IN.ID);

--- Добавляем в REESTR_IN
INSERT INTO MASTER.REESTR_IN
  (ID, SVED_IN_ID, MESTO_ID, TEX_PD_ID, GROTP_ID, STAN_OTP_ID, FORMNAKL_ID, DATE_OTGR, NUM_CIST, VAGONTYPE_ID, 
   KALIBR_ID, VES_CIST, VAGOWNER_ID, CAPACITY, VZLIV, TEMPER, FAKT_PL, VES, VES_NETTO, STAN_VOZ_ID,
   VOLUME, VOLUME15, CTLV,GOST_ID)
  (SELECT 
     k.id_n*100000+k.id_c as ID, SUBSTR((CASE WHEN data<TO_DATE('01.01.2006','dd.mm.yyyy') THEN 'o' ELSE 'oo' END)||TO_CHAR(k.id_n),1,9),1,
	 DECODE(p.ID_NPR,'90002',7242958,NULL),
	 DECODE(p.ID_NPR,'90002',3826,NULL),
	 DECODE(p.ID_NPR,'90002',2290,NULL),6,k.DATA,k.n_cis,6, 
     k.tip_cis, FOR_CIST.GET_VES_CIST(k.n_cis), NVL(FOR_CIST.GET_VAGOWNER(k.n_cis),DECODE(p.ID_NPR,'90002',33,NULL)), FOR_CIST.GET_CAPACITY(k.n_cis),  
     k.v_vzl, k.t_pa, k.pogr, k.ves_cis/1000, k.netto_oil/1000,
	 DECODE(p.ID_NPR,'90002',2290,NULL), k.OBM20, k.OBM15, k.CTL, DECODE(NVL(k.CTL,0),0,0,1)
   FROM load_buffer.sv2_oil k, kls_prod p 
   WHERE k.sh_npr=p.unp_id AND NOT EXISTS (SELECT NULL FROM MASTER.REESTR_IN A WHERE A.ID=k.id_n*100000+k.id_c)
   )
   ORDER BY id;

  FOR lcur IN (SELECT ID,SVED_IN_ID, SVED_POS FROM reestr_in WHERE sved_pos is null ORDER BY id FOR UPDATE)
  LOOP
    vTmp:=FOR_SVED_IN.GetMaxNumPos(lcur.SVED_IN_ID);
    UPDATE reestr_in SET SVED_POS=vTmp WHERE ID=lcur.ID;
  END LOOP;	  

 COMMIT;

END Renew_Reestr_in;
/

