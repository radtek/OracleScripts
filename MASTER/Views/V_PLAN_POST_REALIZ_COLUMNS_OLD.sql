--
-- V_PLAN_POST_REALIZ_COLUMNS_OLD  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PLAN_POST_REALIZ_COLUMNS_OLD
(VID_REAL, TIP_REAL, ORG_STRU, ORG_KIND, DATE_PLAN, 
 VID_REAL_ID, TIP_REAL_ID, ORG_KIND_ID, ORG_STRU_ID)
AS 
SELECT DISTINCT 
       vid_real.NAME AS vid_real, tip_real.NAME AS tip_real,
       org_stru.NAME AS org_stru, org.NAME AS org_kind,
       pr.date_plan, 
       vid_real.ID AS vid_real_id, tip_real.ID AS tip_real_id,
       org.ID AS org_kind_id, org_stru.ID AS org_stru_id
  FROM PLAN_REALIZ pr,
       KLS_ORG_KIND org,
       KLS_VID_REAL_KONS vid_real,
       KLS_TIP_REAL_KONS tip_real,
       ORG_STRUCTURE org_stru
 WHERE pr.parus_rn IS NULL
   AND (pr.org_kind_id = org.ID(+))
   AND (pr.vid_real_id = vid_real.ID(+))
   AND (pr.tip_real_id = tip_real.ID)
   AND (pr.org_stru_id = org_stru.ID)
   AND (pr.org_stru_id = org_stru.ID);


