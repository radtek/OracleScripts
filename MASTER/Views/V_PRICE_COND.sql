--
-- V_PRICE_COND  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PRICE_COND
(ACCNUMB, SACCDOC, ACCDOC, ACCDATE, SFACEACC, 
 NFACEACC, SAGENT, NAGENT, STARIF, NTARIF, 
 SPAY_TYPE, NPAY_TYPE, SACC_AGENT, NEXECUTIVE, SSUBDIV, 
 NSUBDIV, SJUR_PERS, NJUR_PERS, NNOM_MODIF, SNOM_MODIF, 
 NNOMEN, SNOMEN, DOG_NUMBER, DOG_ID, SORD_PREF, 
 BEGIN_DATE, END_DATE, PROD, NPRICE)
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
cord.sord_pref,
rs.dpricedate as begin_date,
NVL(rs.denddate,TO_DATE('31.12.2099','dd.mm.yyyy')) AS end_date,
P.PROD,rsc.nprice
from parus.v_consumerord@oracle.world cord,
parus.v_consumerords@oracle.world cords,
parus.v_stages@oracle.world st,
parus.v_contracts@oracle.world con,
KLS_DOG_PARUS AB,kls_dog,
parus.v_rlpricespecs@oracle.world rs,
parus.v_rlpricescond@oracle.world rsc,
KLS_PROD_NOMENKLATOR P
where cord.nrn=cords.nprn
and cord.nfaceacc=st.nfaceacc
and st.nprn=con.nrn
and cord.ntarif=rs.ntarif and (rs.nrn=rsc.nprn and cord.npay_type=rsc.npaytype)
and rs.nnommodif=cords.nnom_modif
AND con.ddoc_date>TO_DATE('20.03.2002','dd.mm.yyyy') 
AND cord.dord_date>=TO_DATE('01.01.2003','dd.mm.yyyy') 
AND st.nstatus=1 
AND con.sdoc_pref LIKE 'ямо%'
AND trim(con.sdoc_pref)||trim(con.sdoc_numb)=AB.BASE_NUMB
AND AB.DOG_ID=KLS_DOG.ID
AND LTRIM(RTRIM(UPPER(rs.snomen)))=P.MODIF
AND LTRIM(RTRIM(UPPER(rs.snommodif)))=P.MOD_MODIF;


