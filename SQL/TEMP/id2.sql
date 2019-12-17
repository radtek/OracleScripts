truncate table temp_stats;


create table temp_stats TABLESPACE TOOLS as 
select
name ,
most_repeated_key ,
distinct_keys ,
del_lf_rows ,
height ,
blks_gets_per_access 
from index_stats;
