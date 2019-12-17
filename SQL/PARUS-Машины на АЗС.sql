select c.SNAME, b.snomen, NLS_UPPER(a.scar) as AUTO_NUM, round(avg(b.NQuant), 2) as litr, round(avg(b.nquantalt), 2) as kg, count(*) as cnt
from v_transinvdept a, v_transinvdeptspecs b, dicnomns d, vaneev.v_dicstore_psv c
where 
d.rn = b.NNOMEN
and b.nquant > 100 /* Это чтобы всякая мелочь не цеплялась*/
and a.ddocdate >= TO_DATE('01.12.2003','dd.mm.yyyy')
and a.ddocdate <= TO_DATE('31.01.2004','dd.mm.yyyy')
and a.nrn = b.nprn
and a.scar is not null
and a.NIN_STORE=c.nRN
group by c.sNAME, b.snomen, NLS_UPPER(a.scar)
order by 1
