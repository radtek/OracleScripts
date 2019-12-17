--
-- V_MOS_KOMISS_OPL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MOS_KOMISS_OPL
(KOD_PROD, BUHANAL, DATAPLAT, SUMPLATBEZNDS, NDSPLAT, 
 TOTALPLAT, MONTHPLAT)
AS 
select 
kod_prod, buhanal, max(dataplat), sum(summabeznds20) as sumplatbeznds, sum(nds20) as ndsplat, sum(sumplat), LAST_DAY(dataplat) as totalplat 
	        from sveta.sf_opl_prod 
	       where dataplat>=to_date('01.04.2002','dd.mm.yyyy') and buhanal in (5,13) 
	       group by kod_prod, buhanal, LAST_DAY(dataplat);


