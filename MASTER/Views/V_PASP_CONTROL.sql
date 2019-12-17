--
-- V_PASP_CONTROL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PASP_CONTROL
(REZ_NUM, PASP_TYP, PASP_NUM, NAME_NPR, PASP_DATE, 
 DATE_VIR, NEXT_PASP_NUM, NEXT_NAME_NPR, NEXT_PASP_DATE, NEXT_DATE_VIR, 
 INSPEKTOR, OTGR)
AS 
SELECT /*+ INDEX(AA PASP_DATE_VIR_I) */
  A.rez_num,
  A.pasp_typ,
  A.pasp_num,
  A.name_npr,
  A.pasp_date,
  A.date_vir,
  (SELECT MIN(C.pasp_num) FROM kls_pasp C WHERE C.MESTO_ID=1 and C.pasp_typ=2
      and C.rez_num=A.rez_num
	  and C.date_vir=A.next_date_vir) as next_pasp_num,
  (SELECT MIN(D.name_npr) FROM kls_pasp C, kls_prod D WHERE C.PROD_ID_NPR=D.ID_NPR and C.MESTO_ID=1 and C.pasp_typ=2
      and C.rez_num=A.rez_num
	  and date_vir=A.next_date_vir) as next_name_npr,
  (SELECT MIN(pasp_date) FROM kls_pasp C WHERE C.MESTO_ID=1 and C.pasp_typ=2
      and C.rez_num=A.rez_num
	  and date_vir=A.next_date_vir) as next_pasp_date,
  A.next_date_vir,
  A.inspektor,
  (SELECT SUM(VES_BRUTTO) FROM KVIT WHERE PASP_ID=A.ID) as otgr
from
(
select
  AA.ID,
  AA.rez_num,
  DECODE(AA.pasp_typ,2,'Ð','Í') as pasp_typ,
  AA.pasp_num,
  kls_prod.name_npr,
  AA.pasp_date,
  AA.date_vir,
  (SELECT MIN(date_vir) FROM kls_pasp C WHERE C.MESTO_ID=1 and C.pasp_typ=2
      and C.rez_num=AA.rez_num
	  and C.date_vir>AA.date_vir) as next_date_vir,
  inspektor
from kls_pasp AA,kls_prod
where AA.prod_id_npr=kls_prod.id_npr
  and AA.MESTO_ID=1
  and AA.rez_num<>'0'
) A;


