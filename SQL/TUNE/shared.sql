-- Производительность SHARED POOL

-- Процент перезагрузки Library Cache
select sum(pins) "Pins", sum(reloads) "Reloads",
       sum(reloads)/(sum(pins)+sum(reloads))*100 "Percentage"
from v$librarycache;	   

-- Промахи в Dictionary Cache
select unique parameter "Cache Entry", gets "Gets", getmisses "Misses", 
       getmisses/(gets+getmisses)*100 "percentage miss"
from v$rowcache where gets+getmisses <> 0 ;

    
/* Все ли в порядке с SHARED_POOL_SIZE */
SELECT Decode( Count(*), 1, 'SHARED_POOL_SIZE is too small',
'Enjoy your life! It' || '''s Ok.') AS "Advise"
FROM v$shared_pool_reserved
WHERE request_failures > 0
AND last_failure_size < 
(
SELECT to_number(value)
FROM v$parameter
WHERE name = 'shared_pool_reserved_min_alloc'
); 

/* Все ли в порядке с SHARED_POOL_RESERVED_SIZE */
SELECT
Decode( Count(*), 1, 'SHARED_POOL_RESERVED_SIZE is too small',
'SHARED_POOL_RESERVED_SIZE is NOT small, check if it is big.') AS "Advise"
FROM v$shared_pool_reserved
WHERE request_failures > 0
AND (
( last_failure_size >
(
SELECT to_number(value)
FROM v$parameter
WHERE name = 'shared_pool_reserved_min_alloc'
)
)
OR
( max_free_size <
(
SELECT to_number(value)
FROM v$parameter
WHERE name = 'shared_pool_reserved_min_alloc'
)
)
OR
( free_space < 
(
SELECT to_number(value)
FROM v$parameter
WHERE name = 'shared_pool_reserved_min_alloc')
)
); 

/* Все ли в порядке с SHARED_POOL_RESERVED_SIZE */
SELECT Decode( Count(*), 1, 'SHARED_POOL_RESERVED_SIZE is too big',
'SHARED_POOL_RESERVED_SIZE is NOT big.') AS "Advise"
FROM v$shared_pool_reserved
WHERE request_misses = 0
AND ( free_space >=
(
SELECT to_number(value)/2
FROM v$parameter
WHERE name = 'shared_pool_reserved_size'
)
); 


/* Попадание в кеши */

select 'dictionary cache'  paramname, 
       sum(gets) gets,
	   sum(getmisses) misses, 
   	   trunc(sum(gets-getmisses)*100/sum(gets), 2) rate 
    from v$rowcache
union
   select 'library cache' paramname,
       sum(gets) gets,
	   sum(gets)-sum(gethits) misses,
	   trunc(sum(gethits)*100/sum(gets),2) rate
	 from v$librarycache
union
   select 'buffer cache' paramname,
       (congets.value+dbgets.value) gets ,
	   physreads.value misses,
   round((congets.value+dbgets.value-physreads.value)*100/(congets.value+dbgets.value),4) rate
   from v$sysstat congets,   v$sysstat dbgets, v$sysstat physreads
   where congets.name='consistent gets' and dbgets.name='db block gets'and physreads.name='physical reads'
/*
buffer cache	  186397288	4763199	 97.4446
dictionary cache	2296531	  12450	 99.45
library cache	     931715	  20521	 97.79
*/


-- Script: shared_pool_free_lists.sql
select
decode(
sign(ksmchsiz - 812),
-1, (ksmchsiz - 16) / 4,
decode(
sign(ksmchsiz - 4012),
-1, trunc((ksmchsiz + 11924) / 64),
decode(
sign(ksmchsiz - 65548),
-1, trunc(1/log(ksmchsiz - 11, 2)) + 238,
254
)
)
) bucket,
sum(ksmchsiz) free_space,
count(*) free_chunks,
trunc(avg(ksmchsiz)) average_size,
max(ksmchsiz) biggest
from
sys.x_$ksmsp
where
inst_id = userenv('Instance') and
ksmchcls = 'free'
group by
decode(
sign(ksmchsiz - 812),
-1, (ksmchsiz - 16) / 4,
decode(
sign(ksmchsiz - 4012),
-1, trunc((ksmchsiz + 11924) / 64),
decode(
sign(ksmchsiz - 65548),
-1, trunc(1/log(ksmchsiz - 11, 2)) + 238,
254
)
)
);


