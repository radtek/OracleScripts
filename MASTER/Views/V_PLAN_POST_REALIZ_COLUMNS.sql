--
-- V_PLAN_POST_REALIZ_COLUMNS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PLAN_POST_REALIZ_COLUMNS
(VR_ID, VR_NAME, TR_ID, TR_NAME, OK_ID, 
 OK_NAME, OS_ID, OS_NAME)
AS 
SELECT /*+ ORDERED */ 
  vr.ID AS vr_id 
  , vr.NAME AS vr_name 
  , tr.ID AS tr_id 
  , tr.NAME AS tr_name 
  , ok.ID AS ok_id 
  , ok.NAME AS ok_name 
  , os.ID AS os_id 
  , os.NAME AS os_name 
FROM MASTER.ORG_STRUCTURE os 
  , MASTER.KLS_ORG_KIND ok 
  , MASTER.KLS_TIP_REAL_KONS tr 
  , MASTER.KLS_VID_REAL_KONS vr 
WHERE tr.ID IN (1, 2) 
  AND vr.ID IN (1, 5) 
  AND os.PLAN_REAL <> 0 
  AND ok.ID IN (1, 5);


