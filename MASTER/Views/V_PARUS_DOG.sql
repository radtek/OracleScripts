--
-- V_PARUS_DOG  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_DOG
(SAGENT, NAGENT, ACCNUMB, DOG_NUMBER, DOG_ID, 
 SFACEACC, NFACEACC, SSUBDIV, NSUBDIV, STARIF, 
 NTARIF, SPAY_TYPE, NPAY_TYPE, SACC_AGENT, NEXECUTIVE, 
 SJUR_PERS, NJUR_PERS, SACCDOC, ACCDOC, ACCDATE, 
 SSHIPVIEW, NSHIP_TYPE, NFA_CURRENCY, SFA_CURRENCY)
AS 
SELECT /*+ FIRST_ROWS*/
       s.sagent, s.nagent, TRIM (sdoc_pref) || TRIM (sdoc_numb) AS accnumb,
       kls_dog.dog_number, ab.dog_id, s.sfaceacc, s.nfaceacc, s.ssubdiv,
       s.nsubdiv, s.starif, s.ntarif, s.spay_type, s.npay_type,
       s.sexecutive AS sacc_agent, s.nexecutive, c.sjur_pers, c.njur_pers,
       c.sdoc_type AS saccdoc, c.ndoc_type AS accdoc, c.ddoc_date AS accdate,
       s.sship_type AS sshipview, s.nship_type, s.nfa_currency,
       s.sfa_currency
  FROM parus.v_contracts@oracle.world c,
       parus.v_stages@oracle.world s,
       kls_dog_parus ab,
       kls_dog
 WHERE c.nrn = s.nprn
   AND ab.dog_id = kls_dog.ID
   AND c.ddoc_date > TO_DATE ('20.03.2002', 'dd.mm.yyyy')
   AND s.nstatus = 1
   AND TRIM (c.sdoc_pref) || TRIM (c.sdoc_numb) = ab.base_numb
   AND (   c.sdoc_pref LIKE '%ямо%'
        OR c.sdoc_pref LIKE '%Cмо%'
        OR c.sdoc_pref LIKE '%юпу%'
       )
   AND ab.is_actual = 1;


