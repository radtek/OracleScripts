--
-- V_ORDER_EXPORT_FAV  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ORDER_EXPORT_FAV
(SFACEACC, SAGENT, STARIF, SSHIPVIEW, SPAY_TYPE, 
 NOM_ZD, TONN_DECLARED, CIST_DECLARED, PRIM, DATE_PLAN, 
 INPUT_DATE, SAGNFIFO, PLANSTRU_ID, SSUBDIV, SJUR_PERS, 
 MODIF, MOD_MODIF, STAN_NAME, TAXGR_CODE, TAXGR_CODE_NEW, 
 REGION_NAME, REGION_ID, BASE_NUMB)
AS 
SELECT   /*+ ALL_ROWS */
            p.sfaceacc, p.sagent, p.starif, p.sshipview, p.spay_type,
            m.nom_zd, m.tonn_declared, m.cist_declared, m.prim, m.date_plan,
            m.input_date, TRIM (pr.gd_kod) || '/'
                          || TRIM (pr.okpo) AS sagnfifo, m.planstru_id,
            p.ssubdiv, p.sjur_pers, pn.modif, pn.mod_modif, s.stan_name,
            pn.taxgr_code, pn.taxgr_code_new, kls_region.region_name,
            s.region_id, kpd.base_numb
       FROM MONTH m,
            kls_dog d,
            v_parus_dog p,
            kls_predpr pr,
            kls_vid_otgr v,
            kls_planstru ps,
            kls_prod_nomenklator pn,
            kls_stan s,
            zakaz z,
            zakaz unp,
            kls_region,
            kls_dog_parus kpd
      WHERE pn.prod = m.prod_id_npr
        AND m.planstru_id = ps.ID
        AND d.ID = p.dog_id
        AND (unp.ID = m.zakaz_id AND unp.is_agent = 1)
        AND unp.link_id = z.ID
        AND z.dog_id = d.ID
        AND NOT (m.planstru_id = 178 OR m.planstru_id = 208)
        AND m.poluch_id = pr.ID
        AND m.stan_id = s.ID
        AND m.load_abbr = v.load_abbr
        AND z.is_agent = 2
        AND d.predpr_id <> 2641
        AND m.nazn_otg_id <> 2
        AND pn.is_actual <> 0
        AND (v.load_type_id = 1 OR v.load_type_id = 6)
        AND NOT EXISTS (
                        SELECT /*+ HASH_AJ */
                               month_id
                          FROM parus_fin
                         WHERE m.nom_zd = month_id
                               AND task = 'ConsumersOrders')
        AND m.input_date > TO_DATE ('01072007', 'ddmmyyyy')
        AND s.region_id = kls_region.ID
        AND kpd.dog_id=z.lukdog_id
   ORDER BY m.nom_zd;


