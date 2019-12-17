--
-- PREDPR_TALGAR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.PREDPR_TALGAR
(P_NAME, P_ID, P_SNAME, P_INN, P_ZIPJ, 
 P_ZIPP, P_CITYP, P_CITYJ, P_ADRESSP, P_ADRESSJ, 
 P_OKONH, P_OKPO, P_FAX, P_PHONE, PB_KKORS, 
 P_TID, PB_NAME, PB_ADRESS, PB_BIK, PB_ZIZ, 
 PR_NAME, PR_SNAME, P_HNAME, P_STATSNAME, P_STATESHORT, 
 P_PERTYPE, P_FS, P_IDFS, P_IDCOUNTRY, P_IDBSCH, 
 P_IDGRCOM, P_FDK, P_STATUS, P_CREATED, P_MODIFIED)
AS 
SELECT kls_predpr.predpr_name, kls_predpr.id, kls_predpr.short_name,
       kls_predpr.inn, kls_predpr.postindex_j, kls_predpr.postindex_p,
       kls_predpr.city_p, kls_predpr.city_j, kls_predpr.address_p,
       kls_predpr.address_j, kls_predpr.okonh, substr(kls_predpr.okpo,1,8), kls_predpr.fax,
       kls_predpr.phone, kls_predpr.bank_kors, kls_predpr.talgar_id,
       kls_bank.bank_name, kls_bank.address, kls_bank.bik, kls_bank.postindex,
       kls_region.region_name, kls_region.short_name, kls_holding.holding_name,
       kls_states.state_name, kls_states.short_name, kls_pertype.pertype_name, 
	   rtrim(substr(kls_predpr.predpr_name,1,4)),csl_k.cs_fs.id,181,121,kls_holding.id,3,3,sysdate,sysdate
  FROM kls_predpr, kls_bank, kls_holding, kls_region, kls_states, kls_pertype, csl_k.cs_fs
 WHERE (    (kls_bank.kors = kls_predpr.bank_kors)
        AND (kls_holding.id = kls_predpr.holding_id)
        AND (kls_region.id = kls_predpr.region_id)
        AND (kls_states.id = kls_region.states_id)
        AND (kls_pertype.id = kls_predpr.pertype_id)
        AND (kls_predpr.postindex_j <> '0')
        AND (kls_predpr.postindex_p <> '0')
        AND ((kls_predpr.talgar_id = 0) or (kls_predpr.talgar_id is null))
		AND (csl_k.cs_fs.code=rtrim(substr(kls_predpr.predpr_name,1,4)))
       );


