--
-- XX101_BDRVOTGR_EXEC  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Xx101_bdrvotgr_Exec IS
  
BEGIN

/*delete from UF_RELTOPHD_OTGR where UF_RELTOPHD_OTGR.mfrpn is null;*/

update UF_RELTOPHD_OTGR set
ZNAME = 'Не указан',
mfrpn=999999,
PROPAGATESTATUS=0
where UF_RELTOPHD_OTGR.mfrpn is null;

update UF_RELTOPHD_OTGR set
ZNAME = 'Нефть ярегская'
where UF_RELTOPHD_OTGR.mfrpn=2054;

update UF_RELTOPHD_OTGR set
PROPAGATESTATUS=0
where UF_RELTOPHD_OTGR.PROPAGATESTATUS is null;

update UF_RELTOPHD_OTGR set
ZNAME =(select kls_prod.abbr_npr from kls_prod where kls_prod.ksss_prod_id=UF_RELTOPHD_OTGR.MFRPN and rownum=1),
PROPAGATESTATUS=0
where UF_RELTOPHD_OTGR.ZNAME is null;
  COMMIT;                                

END Xx101_bdrvotgr_Exec; 
/

