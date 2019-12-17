--
-- GET_PLAT_OKPO  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.get_plat_okpo
 (nom_dok# number)
return varchar2
as
  val# varchar2(50);
--  propis# varchar2(4000);
begin
  select kls_predpr.OKPO into val# from kls_predpr,kls_dog,bills
    where kls_predpr.id=kls_dog.PREDPR_ID and bills.dog_id=kls_dog.id and bills.nom_dok=nom_dok#;

  return val#;
end get_plat_okpo;

/

