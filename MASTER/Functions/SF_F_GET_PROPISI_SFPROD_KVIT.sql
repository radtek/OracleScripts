--
-- SF_F_GET_PROPISI_SFPROD_KVIT  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.sf_f_get_propisi_sfprod_kvit
 (summa# number)
return varchar2
as
  sum# number;
  val# varchar2(3);
--  propis# varchar2(4000);
begin
  sum#:=summa#;
  --select prod_sum into sum# from bills
  --where nom_dok = nom_dok#;
  val#:='–”¡';
  return Upper(Substr(sfsys.get_propisi (sum#, val#),1,1)) || Substr(sfsys.get_propisi (sum#, val#),2,length(sfsys.get_propisi (sum#, val#))-1);
end sf_f_get_propisi_sfprod_kvit; 
/

