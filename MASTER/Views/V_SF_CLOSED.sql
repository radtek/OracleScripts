--
-- V_SF_CLOSED  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_CLOSED
(VES, D_41, SUM_AKCIZ, D_191, SUM_NALIV, 
 NDC_NAL20, NDC_NAL03, D_441, D_194, D_442, 
 NDC_TR20, SUM_NACEN, KOD_REALP, DOG_REALP, NOM_SF, 
 NOM_DOK, NOM_POR, CLOSE_DATE, KOD_NFP)
AS 
select sum(nvl(r.VES,0)) as VES,
       sum(nvl(r.D_41,0))as D_41,
	   sum(nvl(r.SUM_AKCIZ,0))as SUM_AKCIZ,
	   sum(nvl(r.D_191,0))as D_191,
	   sum(nvl(r.SUM_NALIV,0))as SUM_NALIV,
       sum(nvl(r.NDC_NAL20,0))as NDC_NAL20,
	   sum(nvl(r.NDC_NAL03,0))as NDC_NAL03,
	   sum(nvl(r.D_441,0))as D_441,
	   sum(nvl(r.D_194,0))as D_194,
	   sum(nvl(r.D_442,0))as D_442,
	   sum(nvl(r.NDC_TR20,0))as NDC_TR20,
	   sum(nvl(r.SUM_NACEN,0))as SUM_NACEN,
	   r.KOD_REALP,
	   r.DOG_REALP,
	   r.NOM_SF,
	   r.nom_dok,
	   o.NOM_POR,
	   r.CLOSE_DATE,
	   MAX(r.kod_nfp) as kod_nfp
	   from real_opl r,opl o,KLS_DOG D1, KLS_DOG D2
	   where r.close_date is not null and r.UN_DOK=o.NOM_DOK AND d1.short_NUMBER=r.DOG_REALP and d1.MAINDOG_ID=d2.ID and d2.DOG_NUMBER='0210218'
	   group by r.KOD_REALP,r.DOG_REALP,r.NOM_SF,o.NOM_POR,r.CLOSE_DATE,r.nom_dok;


