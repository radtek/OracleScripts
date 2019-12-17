--
-- V_PARUS_REQUEST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_REQUEST
(ACCNUMB, SACCDOC, ACCDOC, ACCDATE, SFACEACC, 
 NFACEACC, SAGENT, NAGENT, STARIF, NTARIF, 
 SPAY_TYPE, NPAY_TYPE, SACC_AGENT, NEXECUTIVE, SSUBDIV, 
 NSUBDIV, SJUR_PERS, NJUR_PERS, NNOM_MODIF, SNOM_MODIF, 
 NNOMEN, SNOMEN, DOG_NUMBER, DOG_ID, SORD_PREF)
AS 
select trim(con.sdoc_pref)||trim(con.sdoc_numb) as accnumb,
con.sdoc_type as saccdoc,con.ndoc_type as accdoc, con.ddoc_date as accdate,
cord.sfaceacc,cord.nfaceacc,
cord.sagent,cord.nagent,
cord.starif,cord.ntarif,
cord.spay_type,cord.npay_type,
con.sexecutive as sacc_agent,con.nexecutive,
cord.ssubdiv,cord.nsubdiv,
cord.sjur_pers,
cord.njur_pers,
cords.nnom_modif,cords.snom_modif,cords.nnomen,cords.snomen,
KLS_DOG.DOG_NUMBER, AB.DOG_ID,
cord.sord_pref
from parus.v_consumerord@oracle.world cord,
parus.v_consumerords@oracle.world cords,
parus.v_stages@oracle.world st,
parus.v_contracts@oracle.world con,
KLS_DOG_PARUS AB,kls_dog
where cord.nrn=cords.nprn
and cord.nfaceacc=st.nfaceacc
and st.nprn=con.nrn
AND con.ddoc_date>TO_DATE('20.03.2002','dd.mm.yyyy') 
AND cord.dord_date>=TO_DATE('01.01.2003','dd.mm.yyyy') 
AND st.nstatus=1 
AND con.sdoc_pref LIKE 'ямо%'
AND trim(con.sdoc_pref)||trim(con.sdoc_numb)=AB.BASE_NUMB
AND AB.DOG_ID=KLS_DOG.ID;


