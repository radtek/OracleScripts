--
-- V_SF_PRINT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_PRINT
(KOD_PROD, KOD_TU, SCHETF, SF_NO, ORIG_SF_NO, 
 ID_POZ_PROD, DATA_VYP_SF, FULL_NAME_NPOST, VYSTVAL, ADDR_PRED_POST, 
 PHONE_POST, INN_NPOST, PLRDOC, DATA_PLRD, PLRDOC_AND_DATE, 
 DOGOVOR, FULL_NAME_PLAT, ADDR_PRED_PLAT, PHONE_PLAT, KORS_PRED_PLAT, 
 RS_PRED_PLAT, BIK_PRED_PLAT, BANK_PRED_PLAT, INN_PLAT, GROTPR, 
 GROTPR_ADDR, GRPOL, GRPOL_ADDR, DOPOLN1, DOPOLN2, 
 NAIM_TOV, EDIZM, KOL, CENA, AKCIZ1, 
 SUMMA, AKCIZ2, STNDS, SUMNDS, STGSM, 
 SUMGSM, SUMNPR, ALLNDS, PROISX, GTD, 
 ALLNDS_PROPIS, NDS_PROPIS, NONDS_PROPIS, WITH_STNDS, WITH_STNDS_TXT, 
 BUHANAL, DATE_OTGR, DATE_DOG, BOSS, GLAVBUH, 
 NUM_PROTOKOL, PLAT_OKPO, NAKL_NUM, VES_PROPIS, DOVER_NUM)
AS 
SELECT
  s.kod_prod, s.kod_tu,
  DECODE(NVL(s.linkschf, 0), 0, s.schetf, s.schetf||'/'||
         LTRIM(TO_CHAR(s.linkschf))) ||
         '     от  ' || TO_CHAR(DECODE(SIGN(s.data_vyp_sf-p.date_otgr),-1,p.date_otgr,s.data_vyp_sf), 'DD.MM.RRRR')
    AS schetf,
/* 2001/02/05 sulim */ s.schetf, V_BILLS.orig_nom_sf, p.id_poz_prod,
  s.data_vyp_sf, s.full_name_npost, s.vystval,
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
  DECODE(p.edizm, '?', NULL, p.edizm)
    AS edizm,
  p.kol, p.cena, p.akciz1, p.summa, NVL(p.akciz2,0) AS akciz2,
--  p.stnds,
-- 2001/02/08 sulim --  nvl(p.stnds,0),
/* 2001/02/16 sulim  Обратно из-за: Есть "Ставка=0", а есть "НДС не облаг." */
/* 2001/02/16 sulim */  p.stnds,
  p.sumnds, p.stgsm, p.sumgsm, p.sumnpr, p.allnds,
--/* 2001/02/06 sulim */  p.allnds-nvl(p.sumnpr,0) as sumbeznpr,
  p.proisx,
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
/* 2002/02/11 vev   */ , date_otgr
/* 2002/02/11 vev   */, DECODE(s.datadog, NULL, NULL,TO_CHAR(s.datadog,' "от" DD.MM.YYYY'))
/* 2002/02/16 vev   */ , SF_SIGNS.boss
/* 2002/02/16 vev   */ , SF_SIGNS.blavbuh
/* 2002/05/22 vev   */ , Get_Price_Protokol(s.kod_prod)
/* 2002/06/19 vev   */ , Get_Plat_Okpo(s.kod_prod)
/* 2002/06/19 vev   */ , Get_Nakl_Num(s.kod_prod)
/* 2002/06/19 vev   */ , sveta.sf_f_get_propisi_ves(s.kod_prod, s.kod_tu)
/* 2002/06/19 vev   */ , Get_Dover_Num(s.kod_prod)
FROM
  sveta.sf_sfak_prod s, sveta.sf_stat0_poz_prod p,
  sveta.sf_kls_pred p1, sveta.sf_kls_pred p2,
  SF_SIGNS, MASTER.KLS_PREDPR pp,
  KLS_BANKS bk, V_BILLS
WHERE s.kod_prod=V_BILLS.nom_dok
  AND s.id_npred_post = p1.id_pred
  AND s.id_pred_plat  = p2.id_pred
  AND p.kod_prod = s.kod_prod
  AND p.kod_tu = s.kod_tu
  AND LTRIM(RTRIM(pp.PREDPR_NAME)) = LTRIM(RTRIM(p2.FULL_NAME))
  AND bk.ID=pp.BANKS_ID;


