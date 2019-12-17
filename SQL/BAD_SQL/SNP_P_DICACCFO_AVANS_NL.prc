CREATE OR REPLACE procedure       snp_p_dicaccfo_avans_nl
as
begin

for A in (select fo.company, fo.rn, fo.acc_date
            from dicaccfo fo
           where fo.type_acc_fo = 0
             and fo.oncome_date is null
             and fo.acc_date >= '01.05.2004')
loop             
   P_DICACCFO_BOOK_INPUT_SAL (A.company, A.rn, A.acc_date);
end loop;
commit;

for C in (select fo.company, fo.rn 
            from dicaccfo fo,acatalog c 
           where fo.crn = c.rn
             and c.name like 'ж/д тариф'--'%(Ухта)%'
             and fo.type_acc_fo = 1
             and fo.include_date is null
             and fo.acc_date >= '01.06.2002'
     	order by fo.ACC_DATE )
loop
   P_DICACCFO_AVANS_AUTO_SAL (C.company, C.rn,to_date('31.05.2004','dd.mm.yyyy'); --sysdate);   
end loop;
commit;
end;
/

