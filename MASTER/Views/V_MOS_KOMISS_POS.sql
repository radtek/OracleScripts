--
-- V_MOS_KOMISS_POS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MOS_KOMISS_POS
(KOD_PROD, BUHANAL, SUMMA, AKCIZ1, SUMNDS)
AS 
select kod_prod, buhanal, sum(summa) as summa, sum(akciz1) as akciz1, sum(sumnds) as sumnds 
	        from sveta.sf_poz_prod 
		   where date_otgr>=to_date('01.04.2002','dd.mm.yyyy') and buhanal in (5,13) 
		   group by kod_prod, buhanal;


