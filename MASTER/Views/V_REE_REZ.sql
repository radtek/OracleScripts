--
-- V_REE_REZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REE_REZ
(KIND_NPR, OST)
AS 
SELECT
  kls_prod.PROD_PLAN_ID AS kind_npr,
  SUM(DECODE(SIGN(arc_rez.VOL-arc_rez.DEAD_VOL),1,arc_rez.VOL-arc_rez.DEAD_VOL,0)) AS ost
  FROM arc_rez,kls_prod
  WHERE
    arc_rez.PROD_ID_NPR=kls_prod.ID_NPR and
	arc_rez.AR_TOV_ID=1 and  
    arc_rez.Dateupload=
     (SELECT MAX(arc_rez.DATEUPLOAD) 
       FROM arc_rez,v_temp_reestr_params WHERE
        arc_rez.DATEUPLOAD<=v_temp_reestr_params.DATETIME_REPORT)
  GROUP BY kls_prod.PROD_PLAN_ID;


