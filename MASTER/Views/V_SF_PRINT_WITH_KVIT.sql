--
-- V_SF_PRINT_WITH_KVIT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_PRINT_WITH_KVIT
(KOD_PROD, KOD_TU, SCHETF, SCHETUSL, SF_NO, 
 ORIG_SF_NO, ID_POZ_PROD, DATA_VYP_SF, FULL_NAME_NPOST, VYSTVAL, 
 ADDR_PRED_POST, PHONE_POST, INN_NPOST, PLRDOC, DATA_PLRD, 
 PLRDOC_AND_DATE, DOGOVOR, FULL_NAME_PLAT, ADDR_PRED_PLAT, PHONE_PLAT, 
 KORS_PRED_PLAT, RS_PRED_PLAT, BIK_PRED_PLAT, BANK_PRED_PLAT, INN_PLAT, 
 GROTPR, GROTPR_ADDR, GRPOL, GRPOL_ADDR, DOPOLN1, 
 DOPOLN2, NAIM_TOV, EDIZM, KOL, CENA, 
 AKCIZ1, SUMMA, AKCIZ2, STNDS, SUMNDS, 
 STGSM, SUMGSM, SUMNPR, ALLNDS, PROISX, 
 GTD, ALLNDS_PROPIS, NDS_PROPIS, NONDS_PROPIS, WITH_STNDS, 
 WITH_STNDS_TXT, BUHANAL, DATE_OTGR, DATE_DOG, BOSS, 
 GLAVBUH, NUM_PROTOKOL, PLAT_OKPO, NAKL_NUM, VES_PROPIS, 
 DOVER_NUM, KVIT_ID, NUM_CIST, AKCIZ_TXT, DATE_MOS, 
 KPP_PLAT, KPP_POST)
AS 
SELECT 
  s.kod_prod, s.kod_tu, 
  DECODE(NVL(s.linkschf, 0), 0, s.schetf, s.schetf||'/'|| 
         LTRIM(TO_CHAR(s.linkschf))) || 
         '     от  ' || TO_CHAR(DECODE(SIGN(s.data_vyp_sf-p.date_otgr),-1,p.date_otgr,s.data_vyp_sf), 'DD.MM.RRRR') 
    AS schetf, 
/* 2004/02/02 vev     '6' || TO_CHAR(s.data_vyp_sf,'MM') || ' от ' || 
   TO_CHAR(s.data_vyp_sf, 'DD.MM.YYYY') || 'г.' AS schetUsl, */ 
/* 02.06.2004 psv */    TRIM(s.schetf) || ' от ' ||  TO_CHAR(s.data_vyp_sf, 'DD.MM.YYYY') || 'г.' AS schetUsl, 
/* 2001/02/05 sulim */ s.schetf, BILLS.nom_sf, p.id_poz_prod, 
  s.data_vyp_sf, s.full_name_npost, LOWER(s.vystval) AS vystval, 
  DECODE(p1.addr_pred, '?', NULL, p1.addr_pred) 
    AS addr_pred_post, 
  p1.phone AS phone_post, 
  s.inn_npost, 
  s.plrdoc, s.data_plrd, 
/* 2001/01/30 sulim */ RPAD(DECODE(SIGN(p.date_otgr-TO_DATE('01.08.2002','dd.mm.yyyy')),1,'',DECODE(s.data_plrd,NULL,s.plrdoc, 
/* 2001/01/30 sulim */        s.plrdoc||' от '||TO_CHAR(s.data_plrd,'dd.mm.rr')) 
/* 2001/01/30 sulim */ || sveta.get_av_plrdocs(s.kod_prod,s.kod_tu)),300), 
  s.dogovor AS dogovor, 
  s.full_name_plat, 
  p2.addr_pred AS addr_pred_plat, 
  p2.phone AS phone_plat, 
  pp.BANK_KORS AS kors_pred_plat,  ---  @KVS для печати реквизитов в счете 
  pp.RS AS rs_pred_plat,           --- 
  bk.BIK AS bik_pred_plat,         --- 
  bk.BANK_NAME AS bank_pred_plat,  --- 
  DECODE(TRANSLATE(SUBSTR(s.inn_plat, 1, 1), 'x1234567890', 'x'), 
         NULL, s.inn_plat, ' ') 
    AS inn_plat, 
  grotpr, grotpr_addr, grpol, grpol_addr, 
  s.dopoln1, s.dopoln2, 
  p.naim_tov, 
  DECODE(p.edizm, '?', NULL, p.edizm) AS edizm, 
--/* PSV позиции по тр. ср-вам */ DECODE(kv.ID,NULL,p.kol,DECODE(buhanal,48,p.kol,50,p.kol,68,p.kol,69,p.kol,SIGN(kv.SUM_PROD)*ABS(kv.VES_BRUTTO))) AS kol, 
  p.kol, 
  DECODE(BILLS.prod_id_npr,'10001',NULL,TO_CHAR(p.cena,'9999999.99')), 
  p.akciz1, 
--/* PSV позиции по тр. ср-вам */ DECODE(kv.ID,NULL,p.summa,DECODE(buhanal,47,0,48,kv.SUM_VOZN11+kv.SUM_VOZN12,50,kv.SUM_VOZN11+kv.SUM_VOZN12,68,DECODE(id_nfprod,'10013',kv.TARIF_GUARD,kv.TARIF),69,kv.SUM_STRAH,kv.SUM_PROD)) AS summa, 
  p.summa, 
--/* PSV позиции по тр. ср-вам */ DECODE(kv.ID,NULL,NVL(p.akciz2,0),DECODE(buhanal,47,0,48,NVL(p.akciz2,0),50,NVL(p.akciz2,0),68,NVL(p.akciz2,0),69,NVL(p.akciz2,0),kv.SUM_AKCIZ)) AS akciz2, 
  NVL(p.akciz2,0) AS akciz2, 
--  p.stnds, 
-- 2001/02/08 sulim --  nvl(p.stnds,0), 
/* 2001/02/16 sulim  Обратно из-за: Есть "Ставка=0", а есть "НДС не облаг." */ 
/* 2001/02/16 sulim */  p.stnds, 
--/* PSV позиции по тр. ср-вам */ DECODE(kv.ID,NULL,p.sumnds,DECODE(buhanal,47,0,48,kv.SUM_VOZN11_NDS+kv.SUM_VOZN12_NDS,50,kv.SUM_VOZN11_NDS+kv.SUM_VOZN12_NDS,68,DECODE(id_nfprod,'10013',kv.TARIF_GUARD_NDS,kv.TARIF_NDS),69,0,kv.SUM_PROD_NDS)) AS sumnds, 
  p.sumnds, 
  p.stgsm, p.sumgsm, p.sumnpr, 
--/* PSV позиции по тр. ср-вам */ DECODE(kv.ID,NULL,p.allnds,DECODE(buhanal,47,0,48,kv.SUM_VOZN11+kv.SUM_VOZN11_NDS+kv.SUM_VOZN12+kv.SUM_VOZN12_NDS,50,kv.SUM_VOZN11+kv.SUM_VOZN11_NDS+kv.SUM_VOZN12+kv.SUM_VOZN12_NDS,68,DECODE(id_nfprod,'10013',kv.TARIF_GUARD+kv.TARIF_GUARD_NDS,kv.TARIF+kv.TARIF_NDS),69,kv.SUM_STRAH,kv.SUM_PROD+kv.SUM_AKCIZ+kv.SUM_PROD_NDS)) AS allnds, 
  p.allnds, 
--/* 2001/02/06 sulim */  p.allnds-nvl(p.sumnpr,0) as sumbeznpr, 
/* MYudin временно p.proisx,*/ 
  '-' AS proisx, 
  DECODE(UPPER(p.proisx), 
         'РОССИЯ', '-', p.gtd) 
    AS gtd 
/* 2001/03/06 sulim */ , sveta.Sf_F_Get_Propisi_Sfprod(s.kod_prod, s.kod_tu) 
/* 2002/02/10 vev   */ , sveta.Sf_F_Get_Propisi_Sfprodnds(s.kod_prod, s.kod_tu) 
/* 2002/02/10 vev   */ , sveta.Sf_F_Get_Propisi_Sfprodnonds(s.kod_prod, s.kod_tu) 
/* 2001/10/01 sulim */ , DECODE(stnds,NULL,DECODE(NVL(sumnds,0),0,'-','?'),'+') 
/* 2001/10/01 sulim */    AS with_stnds 
/* 2001/10/01 sulim */ , DECODE(stnds,NULL,DECODE(NVL(sumnds,0),0,'НДС не обл.','расчетн.'),'Y') 
/* 2001/10/01 sulim */    AS with_stnds_txt 
/* 2001/10/03 sulim */ , buhanal   /* для критерия суммирования количества */ 
/* 2002/02/11 vev   */ , p.date_otgr 
/* 2002/02/11 vev   */, DECODE(s.datadog, NULL, NULL,TO_CHAR(s.datadog,' "от" DD.MM.YYYY')) 
/* 2002/02/16 vev   */ , V_SF_SIGNS.boss 
/* 2002/02/16 vev   */ , V_SF_SIGNS.blavbuh 
/* 2002/05/22 vev   */ , Get_Price_Protokol(s.kod_prod) 
/* 2002/06/19 vev   */ , Get_Plat_Okpo(s.kod_prod) 
/* 2002/06/19 vev   */ , Get_Nakl_Num(s.kod_prod) 
/* 2002/06/19 vev   */ , sveta.sf_f_get_propisi_ves(s.kod_prod, s.kod_tu) 
/* 2002/06/19 vev   */ , Get_Dover_Num(s.kod_prod), 
kv.ID, 
kv.NUM_CIST, 
/*buhanal, 
KLS_PROD.akciz, 
BILLS.akciz_dok,*/ 
-- DECODE(kv.ID,NULL,'',DECODE(buhanal,47,'',48,'',50,'',68,'',69,'',DECODE(KLS_PROD.AKCIZ,1,DECODE(NVL(pp.AKCIZ_SVED_NUM,0),0,'','БЕЗ АКЦИЗА'),''))) AS AKCIZ_TXT, 
--DECODE(kv.ID,NULL,'',DECODE(buhanal,47,'',48,'',50,'',68,'',69,'',p.NO_AKCIZ)) AS AKCIZ_TXT, 
p.NO_AKCIZ AS AKCIZ_TXT, 
BILLS.DATE_MOS, 
s.KPP_PLAT, 
s.KPP_POST 
FROM 
  sveta.v_sf_sfak_prod_psv s, sveta.sf_stat0_poz_prod p, MASTER.BILLS, 
  (SELECT * FROM MASTER.V_KVIT_ALL WHERE DATE_KVIT>=TO_DATE('01.01.2003','dd.mm.yyyy')) kv, 
  sveta.sf_kls_pred p1, sveta.sf_kls_pred p2, 
  MASTER.KLS_PREDPR pp, MASTER.KLS_BANKS bk, V_SF_SIGNS, MASTER.KLS_PROD 
WHERE s.kod_prod=BILLS.nom_dok 
  AND s.id_npred_post = p1.id_pred 
  AND s.id_pred_plat  = p2.id_pred 
  AND p.kod_prod = s.kod_prod 
  AND p.kod_tu = s.kod_tu 
  AND LTRIM(RTRIM(p2.FULL_NAME))=LTRIM(RTRIM(pp.PREDPR_NAME)) 
  AND pp.BANKS_ID=bk.ID(+) 
  AND p.kod_prod = kv.BILL_ID(+) 
  AND p.KVIT_ID = kv.ID(+) 
--  AND s.kod_prod = kv.BILL_ID(+) 
--  AND BILLS.nom_sf=6002000 
-- AND s.kod_prod=6093360 
  AND s.DATA_VYP_SF>=TO_DATE('01.01.2003','dd.mm.yyyy') 
  AND p.DATE_OTGR>=TO_DATE('01.01.2003','dd.mm.yyyy') 
  AND BILLS.DATE_KVIT>=TO_DATE('01.01.2003','dd.mm.yyyy') 
  AND kv.PROD_ID_NPR=KLS_PROD.ID_NPR(+);


