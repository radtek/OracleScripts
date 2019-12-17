select 'alter table "REPL"."ZREPL_TRANSFER_1" drop constraint "'||constraint_name||'";' from DBA_CONSTRAINTS where table_name='ZREPL_TRANSFER_1'
