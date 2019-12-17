select count(*) num,round(sum(sharable_mem)/(1024*1024)) || 'M' tot 
  from v$sqlarea 
    where sharable_mem > 4400 ;