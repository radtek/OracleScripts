select /*+ ORDERED*/ s.sid,s.username,s.osuser,su.tablespace, 
round(sum(su.blocks*p.value)/1024/1024) "Mb", round(sum(su.blocks/t.blocks)*100,2) "%" 
from v$parameter p,v$sort_usage su,v$session s, 
(select tablespace_name,sum(blocks) blocks from dba_data_files group by tablespace_name 
union 
select tablespace_name,sum(blocks) blocks from DBA_TEMP_FILES group by tablespace_name) t 
where s.serial#=su.session_num and su.tablespace=t.tablespace_name and p.name='db_block_size' 
group by s.sid,s.username,s.osuser,su.tablespace
order by "Mb" desc;