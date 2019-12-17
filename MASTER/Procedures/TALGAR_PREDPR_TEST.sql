--
-- TALGAR_PREDPR_TEST  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Talgar_predpr_Test IS
BEGIN

insert into sprtest.cs_adr (name,city,zipcode,id_country,status)
(select p_adressp as name,p_cityp as city,p_zipp as zipcode,p_idCountry as id_Country,p_status as status from master.predpr_talgar
minus
select name,city,zipcode,id_Country,status from sprtest.cs_adr);

insert into sprtest.cs_adr (name,city,zipcode,id_country,status)
(select p_adressj as name,p_cityj as city,p_zipj as zipcode,p_idCountry as id_Country,p_status as status from master.predpr_talgar
minus
select name,city,zipcode,id_Country,status from sprtest.cs_adr);

/*insert into sprtest.cs_adr (name,city,zipcode,id_country,status)
(select null as name,pb_adress as city,pb_ziz as zipcode,p_idCountry as id_Country,p_status as status from master.predpr_talgar
minus
select name,city,zipcode,id_Country,status from sprtest.cs_adr);
*/

COMMIT;

insert into sprtest.cs_company (name,sname,id_fs,id_country,id_grcom,id_bsch,id_adr_u, id_adr,
                                phone,fax,inn,okonx,okpo,status,created,modified,local_code)
								(select predpr_talgar.p_name,predpr_talgar.p_sname,predpr_talgar.p_idfs,
								predpr_talgar.p_idCountry,predpr_talgar.p_idgrcom,predpr_talgar.p_idbsch,aj.id,ap.id,
								predpr_talgar.p_phone,predpr_talgar.p_fax,predpr_talgar.p_inn,predpr_talgar.p_okonh,
								predpr_talgar.p_okpo,predpr_talgar.p_status,predpr_talgar.p_created,
								predpr_talgar.p_modified, predpr_talgar.P_ID 
								from master.predpr_talgar,sprtest.cs_adr ap, sprtest.cs_adr aj
								where (predpr_talgar.p_adressp=ap.name)
									  and (predpr_talgar.p_cityp=ap.city)
									  and (predpr_talgar.p_zipp=ap.zipcode) 
									  and (predpr_talgar.p_adressj=aj.name)
									  and (predpr_talgar.p_cityj=aj.city)
									  and (predpr_talgar.p_zipj=aj.zipcode) );

 
update kls_predpr c set c.talgar_id = (select max(b.ID) 
from kls_predpr a,sprtest.cs_company b where c.id=a.id and b.local_code=a.ID and b.local_code>0);
COMMIT;
END Talgar_Predpr_Test;

/

