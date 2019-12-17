--
-- GET_REZ_VOL  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.get_rez_vol(ln_prod number, ln_org number, ls_par varchar2)
return  number 
is
result number;
begin
result:=0;
if ls_par = 'DEAD' then
select sum (arc_rez.dead_vol) into result 
from arc_Rez 
where Org_Stru_Id = ln_org
and prod_id_npr = ln_prod
group by Org_Stru_Id, prod_id_npr
order by Org_Stru_Id, prod_id_npr;
end if;
return(nvl(Result,0));
end; 
/

