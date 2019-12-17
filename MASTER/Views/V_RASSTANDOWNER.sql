--
-- V_RASSTANDOWNER  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RASSTANDOWNER
(NAME_RASST, CIST_MPS, CIST_NOT_MPS, VAGON_MPS, VAGON_NOT_MPS)
AS 
SELECT
  kls_rasst.NAME_RASST,
/*  kls_prod.NAME_NPR,
  kvit.VAGONTYPE_ID,
  kvit.VAGOWNER_ID,
  kvit.num_cist,*/
  SUM(DECODE(kvit.VAGOWNER_ID,3,
    DECODE(kvit.VAGONTYPE_ID,6,(kvit.VES_BRUTTO),1,(kvit.VES_BRUTTO),0)
  ,0)) AS cist_mps,
  SUM(DECODE(kvit.VAGOWNER_ID,3,0,
    DECODE(kvit.VAGONTYPE_ID,6,(kvit.VES_BRUTTO),1,(kvit.VES_BRUTTO),0)
  )) AS cist_not_mps,
  SUM(DECODE(kvit.VAGOWNER_ID,3,
    DECODE(kvit.VAGONTYPE_ID,6,0,1,0,0,0,(kvit.VES_BRUTTO))
  ,0)) AS vagon_mps,
  SUM(DECODE(kvit.VAGOWNER_ID,3,0,
    DECODE(kvit.VAGONTYPE_ID,6,0,1,0,0,0,(kvit.VES_BRUTTO))
  )) AS vagon_not_mps
  FROM kvit,kls_rasst,month,kls_stan,kls_vid_otgr, kls_prod
  WHERE
    kls_stan.rast between kls_rasst.MIN_RASST and kls_rasst.MAX_RASST and
	kls_stan.ID=month.STAN_ID and
	kvit.prod_id_npr=kls_prod.id_npr and
	month.nom_zd=kvit.nom_zd and
	month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR and
	month.is_exp=0 and
	kls_vid_otgr.LOAD_TYPE_ID=1 and
	kvit.DATE_KVIT between
	  TO_DATE('01.07.2003','dd.mm.yyyy') and
	  TO_DATE('31.12.2003','dd.mm.yyyy')
/*	and kvit.VAGOWNER_ID<>3
	and kvit.VAGONTYPE_ID<>6*/
  GROUP BY
    kls_rasst.NAME_RASST/*,
	  kls_prod.NAME_NPR,
  kvit.VAGONTYPE_ID,
  kvit.VAGOWNER_ID,
  kvit.num_cist*/
;


