--
-- SF_F_GET_PROPISI_VES  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.sf_f_get_propisi_ves
 (kod_prod# number)
return varchar2
as
  sum# number;
  sum_propis varchar2 (4000);
--  propis# varchar2(4000);
begin
  select sum(ves) into sum# from v_kvit_all 
   where bill_id = kod_prod#;
  if nvl(sum#,0)=0 then
  	 sum_propis:=' ';
  else 
  	 sum_propis:=ves_pr(sum#);  
  end if;
  return sum_propis;
end sf_f_get_propisi_ves; 
/

