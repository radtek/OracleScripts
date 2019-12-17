--
-- SF_F_GET_PROPISI_SFPRODNONDS  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.sf_f_get_propisi_sfprodNONDS
 (kod_prod# number, kod_tu# number)
return varchar2
as
  sum# number;
  val# varchar2(3);
--  propis# varchar2(4000);
begin
  select sum(summa) into sum# from v_bill_pos poz
   where nom_dok = kod_prod#;
  val#:='–”¡';
  return Upper(Substr(sfsys.get_propisi (sum#, val#),1,1)) || Substr(sfsys.get_propisi (sum#, val#),2,length(sfsys.get_propisi (sum#, val#))-1);
end sf_f_get_propisi_sfprodNONDS; 
/

