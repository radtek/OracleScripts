--
-- V_RUI_OTGR_RASST_STOROGEV  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RUI_OTGR_RASST_STOROGEV
(DATE_KVIT, VES, RAST, SOBSTV, KIND_NPR)
AS 
SELECT /*+ ORDERED */
       k.date_kvit, k.ves, s_nazn.rast, 
	   DECODE (vow.sobstv_ID, 3, 1, 0) AS sobstv,/* МПС - 1, остальные 0*/
       DECODE (vt.ID, 6, 1, 0) AS kind_npr /*Цистерна 6 - 1, остальные 0*/ 
  FROM MONTH m,
       KVIT k,
       KLS_STAN s_nazn,
       KLS_VID_OTGR vo,
       KLS_VAGOWNER vow,
	   KLS_VAGONTYPE vt
 WHERE (m.nom_zd = k.nom_zd)
   AND (s_nazn.ID = m.stan_id)
   AND ((m.load_abbr = vo.load_abbr) AND (vo.load_type_id = 1))
   AND (k.vagowner_id = vow.ID) and k.VAGONTYPE_ID=vt.ID
   and k.ves>0
   AND (k.date_kvit >= TO_DATE ('01.01.2002', 'dd.mm.yyyy'))
   AND (k.prod_id_npr <> '90000')
   AND (m.nazn_otg_id <> 5);


