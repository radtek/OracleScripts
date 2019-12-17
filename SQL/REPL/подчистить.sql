delete from snp_repl.repl_call_out a where counter=3 and operation in ('U','I')
and exists (select null from snp_repl.repl_call_out_hist b where b.site_source_rn=a.site_source_rn
and b.site_dest_rn=a.site_dest_rn and b.tablern=a.tablern and b.operation='D')