--
-- V_DAYLY_FACT_MO  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DAYLY_FACT_MO
(DATE_MO, M_O, PROD_ID_NPR, SOBSTV_ID)
AS 
SELECT   to_date(to_char(arc_rez.dateupload,'dd.mm.yyyy'),'dd.mm.yyyy') as date_mo, SUM (arc_rez.dead_vol) as m_o, arc_rez.prod_id_npr, 1 as sobstv_id
    FROM arc_rez
   WHERE (arc_rez.ar_tov_id = 1) and arc_rez.dateupload>sysdate-40 
GROUP BY arc_rez.dateupload, arc_rez.prod_id_npr;


