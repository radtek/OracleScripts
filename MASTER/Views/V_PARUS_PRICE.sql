--
-- V_PARUS_PRICE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_PRICE
(ACCNUMB, SACCDOC, ACCDATE, SFACEACC, SAGENT, 
 STARIF, SPAY_TYPE, SACC_AGENT, SSUBDIV, SJUR_PERS, 
 NOM_MODIF, NOMEN, DOG_NUMBER, DOG_ID, ORD_PREF, 
 PROD, NPRICE, SSHIPVIEW, VALID_DOCNUMB, PROC_INSURE, 
 USL_SUM)
AS 
SELECT pr.accnumb AS accnumb, pr.saccdoc, pr.accdate, pr.sfaceacc, pr.sagent,
       pr.starif, pr.spay_type, pr.sacc_agent, pr.ssubdiv, pr.sjur_pers,
       pr.nom_modif, pr.nomen, kls_dog.dog_number, ab.dog_id, pr.ord_pref,
       p.prod, pr.nprice AS nprice, pr.sshipview, pr.valid_docnumb,
       pr.proc_insure, pr.usl_sum
  FROM v_price_gtc_pvz@oracle.world pr,
       kls_dog_parus ab,
       kls_dog,
       kls_prod_nomenklator p
 WHERE LTRIM (RTRIM (UPPER (pr.accnumb))) =
                                          LTRIM (RTRIM (UPPER (ab.base_numb)))
   AND ab.dog_id = kls_dog.ID
   AND LTRIM (RTRIM (UPPER (pr.nomen))) = LTRIM (RTRIM (UPPER (p.modif)))
   AND LTRIM (RTRIM (UPPER (pr.nom_modif))) =
                                           LTRIM (RTRIM (UPPER (p.mod_modif)))
   AND p.is_actual = 1
   AND ab.is_actual = 1;


