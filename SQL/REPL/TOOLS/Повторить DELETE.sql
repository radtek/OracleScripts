delete  from repl_status b where
exists (select null from v_repl a where a.repl_rn=b.repl_rn and a.repl_operation='D')