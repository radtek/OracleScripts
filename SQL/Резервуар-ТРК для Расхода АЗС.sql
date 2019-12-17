select /*+ RULE */ mech, a.* from azsrepout a 
where rep_date=to_date('18.01.2004','dd.mm.yyyy') 
and prn=217696592
and nomen=95873245


select c.nRn as nCELL
  from 
     azsrezlistcol a, v_stplRackCells c
  where  a.rn = 195108224
     and a.mrn = c.nRn;
	 
	 
select cell, count(*)
  from azscolcells a
  where numb = '1'
group by cell
having count(*)>1  

select * 
from azscolcells a
where cell=159684901

select *
from azsrezlistcol
where rn=10987833 or rn=454121

select a.rn as nGun
from azscolcells a
where a.cell = 159684901
and a.prn=
and numb = '1';




select max(LPAD(NUMB,10, ' ')) into sNUMB from AZSCOLCELLS where PRN = OTRK.RN;