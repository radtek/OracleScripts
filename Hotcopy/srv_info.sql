WHENEVER SQLERROR CONTINUE

Connect / as sysdba
select 'BACKUP_INFO_SERVER_NAME' as title, b.name as value from zrepl_config a, zrepl_server b where a.id=b.id
UNION ALL
select 'BACKUP_INFO_SERVER_DATE',to_char(sysdate,'dd.mm.yyyy hh24:mi:ss') from dual
union all
select 'BACKUP_INFO_ZREPL_META_LAST_DATE',to_char(max(DATA),'dd.mm.yyyy hh24:mi:ss') from zrepl_meta;

exit
