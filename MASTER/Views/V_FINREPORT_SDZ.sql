--
-- V_FINREPORT_SDZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_SDZ
(IS_HOLDING, KOD_PLAT, OWNER_ID, DOG_ID, DATE_BUXG, 
 KOL_DN, DATE_TO_OPL, SUMMA_DOK, SUMMA_PROD, SUMMA_AGEN, 
 NOM_DOK)
AS 
SELECT
  DECODE(KLS_PREDPR.HOLDING_ID,41,0,DECODE(KLS_PREDPR.HOLDING_ID,42,0,1)),
  KLS_DOG.PREDPR_ID,
  v_bills_for_real_opl.OWNER_ID,
  v_bills_for_real_opl.DOG_ID,
  v_bills_for_real_opl.DATE_BUXG,
  v_bills_for_real_opl.KOL_DN, 
  v_bills_for_real_opl.DATE_KVIT+v_bills_for_real_opl.KOL_DN, 
  NVL(r_o.d_41+r_o.d_191+r_o.sum_akciz+r_o.d_67+r_o.d_441+r_o.d_194+r_o.sum_nacen+r_o.sum_naliv+r_o.ndc_nal20+r_o.d_442+r_o.ndc_tr20,0) AS summa_dok,
  NVL(r_o.d_41+r_o.d_191+r_o.sum_akciz+r_o.d_67+r_o.d_441+r_o.d_194+r_o.sum_nacen,0),
  NVL(r_o.sum_naliv+r_o.ndc_nal20+r_o.d_442+r_o.ndc_tr20,0),
  r_o.nom_dok
FROM load_buffer.real_opl r_o,
     v_bills_for_real_opl,
     kls_dog,
     kls_predpr
WHERE (    (kls_dog.id = v_bills_for_real_opl.dog_id)
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND (r_o.nom_dok=v_bills_for_real_opl.nom_dok(+))
		AND (r_o.close_date is null OR r_o.CLOSE_DATE>TO_DATE('31.01.2002','dd.mm.yyyy'))
		AND KLS_DOG.PREDPR_ID<>710
       )
UNION ALL
SELECT
  DECODE(KLS_PREDPR.HOLDING_ID,41,0,DECODE(KLS_PREDPR.HOLDING_ID,42,0,1)),
  KLS_DOG.PREDPR_ID,
  v_bills_for_real_opl.OWNER_ID,
  v_bills_for_real_opl.DOG_ID,
  v_bills_for_real_opl.DATE_BUXG,
  v_bills_for_real_opl.KOL_DN, 
  v_bills_for_real_opl.DATE_KVIT+v_bills_for_real_opl.KOL_DN, 
  NVL(r_o.d_41+r_o.d_191+r_o.sum_akciz+r_o.d_67+r_o.d_441+r_o.d_194+r_o.sum_nacen+r_o.sum_naliv+r_o.ndc_nal20+r_o.d_442+r_o.ndc_tr20,0) AS summa_dok,
  DECODE(v_bills_for_real_opl.OWNER_ID,1,NVL(r_o.d_41+r_o.d_191+r_o.sum_akciz+r_o.d_67+r_o.d_441+r_o.d_194+r_o.sum_nacen,0),0),
  DECODE(v_bills_for_real_opl.OWNER_ID,1,NVL(r_o.sum_naliv+r_o.ndc_nal20+r_o.d_442+r_o.ndc_tr20,0),NVL(r_o.d_41+r_o.d_191+r_o.sum_akciz+r_o.d_67+r_o.d_441+r_o.d_194+r_o.sum_nacen+r_o.sum_naliv+r_o.ndc_nal20+r_o.d_442+r_o.ndc_tr20,0)),
  r_o.nom_dok
FROM load_buffer.real_opl r_o,
     v_bills_for_real_opl,
     kls_dog,
     kls_predpr
WHERE (    (kls_dog.id = v_bills_for_real_opl.dog_id)
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND (r_o.nom_dok=v_bills_for_real_opl.nom_dok(+))
		AND (r_o.close_date is null OR r_o.CLOSE_DATE>TO_DATE('31.01.2002','dd.mm.yyyy'))
		AND KLS_DOG.PREDPR_ID=710
       );


