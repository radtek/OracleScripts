--
-- GET_CONTRACT_PARUS_VZ  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_CONTRACT_PARUS_VZ(ps_doc varchar2, ps_param varchar2, pd_date date)
return  
--Desc:возвращает сответствующий номер договора из Парус
--14.07.2006 VZhukow
--Для 604 отчета
--функция быда переделана из GET_CONTRACT_PARUS
--так как была проблема
varchar2
is
ls_result varchar2(50);
ls_result_sf varchar2 (60);
ln_rn number;
function get_rn_gcp (pn_rn number) return varchar2
as
lsl_result varchar2(60);
begin
begin
--select trim(pref_numb)||'-'||trim(reg_numb)||'*'||TO_CHAR(acc_date,'DD.mm.YYYY') into
select trim(reg_numb)||'*'||TO_CHAR(acc_date,'YYYYmmDD') into
lsl_result
from docinpt@oracle.world d_i, doclinks@oracle.world d_l,
docoutpt@oracle.world d_o,DICACCFO@oracle.world D_AC
where
d_l.in_doc = d_i.rn
and d_l.out_doc = d_o.rn
and d_i.document = pn_rn
and d_i.unitcode = 'GoodsTransInvoicesToConsumers'
and d_o.unitcode = 'AccountFactOutput'
AND D_O.DOCUMENT = D_AC.RN;
exception when others then
lsl_result:= '-9999*-9999';
end;
return (lsl_result);
end;



begin
ls_result_sf:='-9999';
ls_result :='-3333';
If ps_param = 'AUTO_CONT' then
begin
select distinct
substr(accnumb,1,decode(instr(ACCNUMB,'('),0,length(accnumb),instr(ACCNUMB,'('))-1)
into 
ls_result
from transinvcust@Oracle.world A1
where
trim(A1.PREF)||'-'||trim(A1.NUMB) = ps_doc
and rownum = 1;
exception when others then
ls_result:= '-9999';
end;
end if;

If ps_param = 'AUTO_ACC' then
begin
select distinct rn into ln_rn
from transinvcust@Oracle.world A1
where
trim(A1.PREF)||'-'||trim(A1.NUMB) = ps_doc
and rownum = 1;
exception when others then
ls_result:= '-9999';
end;
If ls_result<> '-9999' then
ls_result:=get_rn_gcp (ln_rn);
end if;
end if;

If ps_param = 'GD_CONT' then
begin
select distinct substr(accnumb,1,decode(instr(ACCNUMB,'('),0,length(accnumb),instr(ACCNUMB,'('))-1)  
into 
ls_result
from parus_fin y,transinvcust@oracle.world a2, kvit y2
where
y.kvit_id = y2.id
and y.rn = a2.rn
and y2.num_kvit = to_number(ps_doc)
and y2.date_kvit = pd_date
and rownum = 1;
exception when others then 
ls_result:='-9999';
end;
end if;

if ps_param = 'GD_ACC' then
begin
select distinct a2.rn into  ln_rn
from parus_fin y,transinvcust@oracle.world a2, kvit y2
where
y.kvit_id = y2.id
and y.rn = a2.rn
and y2.num_kvit = to_number(ps_doc)
and y2.date_kvit = pd_date
and rownum = 1;
exception when others then 
ls_result:='-9999';
end;
If ls_result<>'-9999' then
ls_result:=get_rn_gcp (ln_rn);
end if;
end if;
return(trim(NVL(ls_Result,'-9999')));
end; 
/

