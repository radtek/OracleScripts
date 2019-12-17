--
-- V_YAROSLAVSKY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_YAROSLAVSKY
(MARKET, DAT, FACTORYNAM, PRODUCTNAM, IDPROD, 
 KORPKOD, IDR3, COUNTRYNAM, TIPOTGRUZ, IDSTATION, 
 STATIONNAM, CONTRACTNU, CONTRACTNU2, CONDITIONN, STATIONPER, 
 CLIENTNAM, POLUCHATEL, EKSPEDITOR, SOBSTVCIST, TONSPLAN, 
 TONSRAZN, TONSPAY, PAYDAT, TONSFACT, NOMCIST, 
 NOMNAKL, TONSWAYPLA, TONSWAYPAY, IDPRC, PRC, 
 TYPEDOC, DATDOC, NOTE)
AS 
select /*+ RULE*/
  month.IS_EXP as market,
  kvit.DATE_KVIT as dat,
  'Ухта' as factorynam,
  kls_prod.LONG_NAME_NPR as productnam,
  kls_prod.ID_NPR as idprod,
  kls_prod.KOD_10 as korpkod,
  ksss_prod.MATNR AS idr3,
  kls_region.REGION_NAME as countrynam,
  kls_load_type.TYPE_OTGR_NAME as tipotgruz,
  kls_stan.STAN_KOD as idstation,
  kls_stan.STAN_NAME as stationnam,
  kls_dog.DOG_NUMBER as contractnu,
  kls_dog2.DOG_NUMBER as contractnu2,
  '???' as conditionn,
  '???' as stationper,
  plat.PREDPR_NAME clientnam,
  polu.PREDPR_NAME as poluchatel,
  decode(exped.PREDPR_NAME,'<Контрагент>','',exped.PREDPR_NAME) as ekspeditor,
  kls_vagowner.SHORT_NAME as sobstvcist,
  -1 as tonsplan,
  month.TONN_DECLARED as tonsrazn,
  -1 as tonspay,
  TO_DATE('01.01.2020','dd.mm.yyyy') as paydat,
  kvit.ves as tonsfact,
  kvit.NUM_CIST as nomcist,
  kvit.NUM_KVIT as nomnakl,
  -1 as tonswaypla,
  -1 as tonswaypay,
  -1 as idprc,
  -1 as prc,
  -1 as typedoc,
  kls_dog.DOG_DATE as datdoc,
  month.PRIM as note
  from 
    month,kvit,kls_prod,
	ksss_prod,kls_stan,
	kls_region,kls_vid_otgr,
	kls_load_type,kls_dog,kls_dog kls_dog2,
	kls_predpr plat,kls_predpr polu,kls_predpr exped,
	kls_vagowner
  where 
    month.nom_zd=kvit.nom_zd(+) and
	kvit.PROD_ID_NPR=kls_prod.ID_NPR and
	kls_prod.ID_NPR=ksss_prod.FOX_ID(+) and
	month.STAN_ID=kls_stan.ID and
	kls_stan.REGION_ID=kls_region.ID and
	month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR and
	kls_vid_otgr.LOAD_TYPE_ID=kls_load_type.ID and
	month.DOG_ID=kls_dog.ID and
	month.NPODOG_ID=kls_dog2.ID(+) and
	kls_dog.PREDPR_ID=plat.id and
    month.POLUCH_ID=polu.id and
	kvit.EXPED_ID=exped.id(+) and
	kvit.VAGOWNER_ID=kls_vagowner.ID;


