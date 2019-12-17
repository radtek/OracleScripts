--
-- V_DAYLYFACT_PROIZV  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DAYLYFACT_PROIZV
(D_FAKT_DATE, PLAN_REF_ID, PROIZV)
AS 
SELECT a.D_FAKT_DATE, a.PLAN_REF_ID, iif_num(a.d_fakt_otgr_nar-pla.ostat+a.d_fakt_ostat_tek+a.d_fakt_hran_tek-pla.hran-a.d_fakt_perepasp-a.d_fakt_pokup,'<',0,0,a.d_fakt_otgr_nar-pla.ostat+a.d_fakt_ostat_tek+a.d_fakt_hran_tek-pla.hran-a.d_fakt_perepasp-a.d_fakt_pokup) as proizv
  FROM dayly_fact a, plan_refinery pla
 WHERE ((pla.ID = a.plan_ref_id));


