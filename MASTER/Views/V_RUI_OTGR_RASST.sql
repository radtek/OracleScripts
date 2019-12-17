--
-- V_RUI_OTGR_RASST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RUI_OTGR_RASST
(AGENT_ID, DOG_NUMBER, DATE_KVIT, NUM_CIST, NUM_KVIT, 
 VES, RAST, SOBSTV, STAN_NAME, NAME_NPR, 
 OW, SOB, REP_OWNER_ID)
AS 
SELECT /*+ ORDERED INDEX(k) USE_NL(m,k,s_nazn,dog,prod,vo,KLS_VAGOWNER,vow,vsob) */
       dog.agent_id, dog.short_number AS dog_number, k.date_kvit, k.num_cist,
       k.num_kvit, k.ves, s_nazn.rast,
       DECODE (vow.ID - vsob.ID, 0, 1, 0) AS sobstv,
                                                    /* Собственные - 1, Арендованные - 0*/
                                                    s_nazn.stan_name,
       prod.name_npr, vow.vagowner_name AS ow, vsob.vagowner_name AS sob,
       NVL (for_temp.get_as_num ('LC_VAGOWNER', 'MASTER', 'GD_OTGR_RASST.XLS'),
            0
           ) AS rep_owner_id
  FROM kvit k,
       MONTH m,
       kls_stan s_nazn,
       kls_dog dog,
       kls_prod prod,
       kls_vid_otgr vo,
       kls_vagowner,
       kls_vagowner vow,
       kls_vagowner vsob
 WHERE (m.nom_zd = k.nom_zd)
   AND (s_nazn.ID = m.stan_id)
   AND (dog.ID = m.dog_id)
   AND (k.prod_id_npr = prod.id_npr)
   AND (m.load_abbr = vo.load_abbr)
   AND (vo.load_type_id = 1)
   AND (k.vagowner_id = kls_vagowner.ID)
   AND (kls_vagowner.owner_id = vow.ID)
   AND (kls_vagowner.sobstv_id = vsob.ID)
   AND vow.ID =
          DECODE (for_temp.get_as_num ('LC_VAGOWNER',
                                       'MASTER',
                                       'GD_OTGR_RASST.XLS'
                                      ),
                  0, vow.ID,
                  for_temp.get_as_num ('LC_VAGOWNER',
                                       'MASTER',
                                       'GD_OTGR_RASST.XLS'
                                      )
                 )
--   AND (k.date_kvit >= TO_DATE ('01.01.2005', 'dd.mm.yyyy'))
   AND (k.prod_id_npr <> '90000')
   AND (m.nazn_otg_id <> 5)
   AND k.vagowner_id <> 3
   AND k.tex_pd_id <> 7242958;


