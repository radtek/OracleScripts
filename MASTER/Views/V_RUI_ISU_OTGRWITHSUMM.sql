--
-- V_RUI_ISU_OTGRWITHSUMM  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RUI_ISU_OTGRWITHSUMM
(DATE_KVIT, CENA, CENA_OTP, NOM_ZD, NUM_CIST, 
 NUM_KVIT, SUM_AKCIZ, SUM_PROD, SUM_PROD_NDS, SUM_STRAH, 
 SUM_VOZ, SUM_VOZN11, SUM_VOZN11_NDS, SUM_VOZN12, SUM_VOZN12_NDS, 
 SVED_NUM, TARIF, TARIF19, TARIF_ALT, TARIF_GUARD, 
 TARIF_GUARD_NDS, TARIF_NDS, TARIF_ORIG, VES, SHORT_NAME, 
 DOG_NUMBER, NAME_NPR)
AS 
SELECT k.date_kvit, k.cena, k.cena_otp, k.nom_zd, k.num_cist, k.num_kvit,
       k.sum_akciz, k.sum_prod, k.sum_prod_nds, k.sum_strah, k.sum_voz,
       k.sum_vozn11, k.sum_vozn11_nds, k.sum_vozn12, k.sum_vozn12_nds,
       k.sved_num, k.tarif, k.tarif19, k.tarif_alt, k.tarif_guard,
       k.tarif_guard_nds, k.tarif_nds, k.tarif_orig, k.ves, p.short_name,
       d.dog_number, prod.name_npr
  FROM kvit k, MONTH m, kls_predpr p, kls_prod prod, kls_dog d
 WHERE m.nom_zd = k.nom_zd
   AND m.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND k.prod_id_npr = prod.id_npr
   AND k.date_kvit >= '01-jul-2006'
   AND k.num_kvit <> 99999
   and m.poluch_id<>8;


