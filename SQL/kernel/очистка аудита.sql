select 'alter table '||table_owner||'.'||table_name||' truncate partition '||partition_name||' drop storage;' from ALL_TAB_PARTITIONS where table_owner in ('AUDIT_USER','AUDIT_USER_R3')  and PARTITION_NAME='M4'


