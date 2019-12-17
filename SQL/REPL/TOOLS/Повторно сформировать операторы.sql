insert into updatelist (TABLENAME, TABLERN, AUTHID, MODIFDATE, OPERATION, NOTE)
select distinct 'DOCINPT',e.IN_DOC,'SNP_REPL_MANUAL',SYSDATE,a.operation,'?' 
from snp_repl.repl_call_out a, snp_repl.repl_schema_row b , snp_repl.repl_table c,snp_repl.v_arh_doclinks e
where a.schemarow_rn=b.rn and b.table_dest_rn=c.rn and a.tablern=e.rn
and c.tablename='DOCLINKS' and a.counter>=3;

insert into updatelist (TABLENAME, TABLERN, AUTHID, MODIFDATE, OPERATION, NOTE)
select distinct c.tablename,a.tableRN,'SNP_REPL_MANUAL',SYSDATE,a.operation,'?' 
from snp_repl.repl_call_out a, snp_repl.repl_schema_row b , snp_repl.repl_table c 
where a.schemarow_rn=b.rn and b.table_dest_rn=c.rn and a.counter>=3;

delete from snp_repl.repl_call_out where rn in (select a.rn
from snp_repl.repl_call_out a, snp_repl.repl_schema_row b , snp_repl.repl_table c 
where a.schemarow_rn=b.rn and b.table_dest_rn=c.rn and a.counter>=3
);


