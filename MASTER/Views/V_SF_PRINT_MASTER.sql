--
-- V_SF_PRINT_MASTER  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_PRINT_MASTER
(KOD_PROD, KOD_TU, SCHETF, SF_NO, ID_POZ_PROD, 
 DATA_VYP_SF, FULL_NAME_NPOST, VYSTVAL, ADDR_PRED_POST, PHONE_POST, 
 INN_NPOST, PLRDOC, DATA_PLRD, PLRDOC_AND_DATE, DOGOVOR, 
 FULL_NAME_PLAT, ADDR_PRED_PLAT, PHONE_PLAT, INN_PLAT, GROTPR, 
 GROTPR_ADDR, GRPOL, GRPOL_ADDR, DOPOLN1, DOPOLN2, 
 NAIM_TOV, EDIZM, KOL, CENA, AKCIZ1, 
 SUMMA, AKCIZ2, STNDS, SUMNDS, STGSM, 
 SUMGSM, SUMNPR, ALLNDS, PROISX, GTD, 
 ALLNDS_PROPIS, NDS_PROPIS, NONDS_PROPIS, WITH_STNDS, WITH_STNDS_TXT, 
 BUHANAL, DATE_OTGR, DATE_DOG, BOSS, GLAVBUH)
AS 
SELECT
  s.kod_prod, s.kod_tu,
  DECODE(NVL(s.linkschf, 0), 0, s.schetf, s.schetf||'/'||
         LTRIM(TO_CHAR(s.linkschf))) ||
         '     от  ' || TO_CHAR(s.data_vyp_sf, 'DD.MM.RRRR')
    AS schetf,
/* 2001/02/05 sulim */ s.schetf, p.id_poz_prod,
  s.data_vyp_sf, s.full_name_npost, s.vystval,
  DECODE(p1.addr_pred, '?', NULL, p1.addr_pred)
    AS addr_pred_post,
  p1.phone AS phone_post,
  s.inn_npost,
  s.plrdoc, s.data_plrd,
/* 2001/01/30 sulim */ rpad(decode(s.data_plrd,null,s.plrdoc,
/* 2001/01/30 sulim */        s.plrdoc||' от '||to_char(s.data_plrd,'dd.mm.rr'))
/* 2001/01/30 sulim */ || sveta.get_av_plrdocs(s.kod_prod,s.kod_tu),300),
  s.dogovor AS dogovor,
  s.full_name_plat,
  p2.addr_pred AS addr_pred_plat,
  p2.phone AS phone_plat,
  DECODE(TRANSLATE(SUBSTR(s.inn_plat, 1, 1), 'x1234567890', 'x'),
         NULL, s.inn_plat, ' ')
    AS inn_plat,
  grotpr, grotpr_addr, grpol, grpol_addr,
  s.dopoln1, s.dopoln2,
  p.naim_tov,
  DECODE(p.edizm, '?', NULL, p.edizm)
    AS edizm,
  p.kol, p.cena, p.akciz1, p.summa, nvl(p.akciz2,0) as akciz2,
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
/* 2001/03/06 sulim */ , sveta.sf_f_get_propisi_sfprod(s.kod_prod, s.kod_tu)
/* 2002/02/10 vev   */ , sveta.sf_f_get_propisi_sfprodNDS(s.kod_prod, s.kod_tu)
/* 2002/02/10 vev   */ , sveta.sf_f_get_propisi_sfprodNONDS(s.kod_prod, s.kod_tu)
/* 2001/10/01 sulim */ , decode(stnds,null,decode(nvl(sumnds,0),0,'-','?'),'+')
/* 2001/10/01 sulim */    as with_stnds
/* 2001/10/01 sulim */ , decode(stnds,null,decode(nvl(sumnds,0),0,'НДС не обл.','расчетн.'),'Y')
/* 2001/10/01 sulim */    as with_stnds_txt
/* 2001/10/03 sulim */ , buhanal   /* для критерия суммирования количества */
/* 2002/02/11 vev   */ , date_otgr
/* 2002/02/11 vev   */, DECODE(s.datadog, NULL, NULL,TO_CHAR(s.datadog,' "от" DD.MM.YYYY'))
/* 2002/02/16 vev   */ , sf_signs.boss
/* 2002/02/16 vev   */ , sf_signs.blavbuh
FROM
  sveta.sf_sfak_prod s, sveta.sf_stat0_poz_prod p,
  sveta.sf_kls_pred p1, sveta.sf_kls_pred p2,
  sf_Signs
WHERE
  s.id_npred_post = p1.id_pred
  AND s.id_pred_plat  = p2.id_pred
  AND p.kod_prod = s.kod_prod
  AND p.kod_tu = s.kod_tu;


