--
-- V_MOS_KOMISS_CLOSED_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MOS_KOMISS_CLOSED_SF
(FULL_NAME_PLAT, INN_PLAT, ADDR_PRED, DOGOVOR, DATADOG, 
 KOM_SF, DATE_KOM_SF, NPO_SF, DATE_NPO_SF, BUHANAL, 
 DATAPLAT, SUMBEZNDS, SUMNDS, SUMPLATBEZNDS, NDSPLAT, 
 TOTALPLAT)
AS 
select pred.PREDPR_NAME, pred.INN, pred.POSTINDEX_J || ' ' || pred.CITY_J || ' ' || pred.ADDRESS_J, dog.DOG_NUMBER, dog.DOG_DATE, s.SCHETF as kom_sf,
         s.DATA_VYP_SF as date_kom_sf, b.NPO_SF, b.DATE_VYP_SF as date_npo_sf,
         p.buhanal, o.dataplat, p.SUMMA as sumbeznds, p.SUMNDS, o.sumplatbeznds, o.ndsplat, o.totalplat
    from sveta.sf_sfak_prod s,
--         master.v_bills_snp b,
/* Вместо v_bills_snp */
         master.bills b,
/* - */
	     v_mos_komiss_opl o,
	     v_mos_komiss_pos p,
	     master.kls_predpr pred,
		 master.kls_dog dog
   where s.kod_prod=b.nom_dok and
         s.dogovor='0210218' and
         s.kod_prod=p.kod_prod and
		 p.kod_prod=o.kod_prod and
		 p.buhanal=o.buhanal and
--         b.PLAT_ID=pred.ID and
/* Вместо v_bills_snp */
         dog.PREDPR_ID=pred.ID and
/* - */
		 b.dog_id=dog.ID
   order by o.dataplat, p.buhanal, s.FULL_NAME_PLAT, kom_sf;


