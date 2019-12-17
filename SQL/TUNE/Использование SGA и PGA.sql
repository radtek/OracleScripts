/* Прогноз DB cache */
SELECT size_for_estimate, buffers_for_estimate, estd_physical_read_factor, estd_physical_reads
   FROM V$DB_CACHE_ADVICE
   WHERE name          = 'DEFAULT'
     AND block_size    = (SELECT value FROM V$PARAMETER WHERE name = 'db_block_size')
     AND advice_status = 'ON';
	 
	 
SELECT NAME, PHYSICAL_READS, DB_BLOCK_GETS, CONSISTENT_GETS,
      1 - (PHYSICAL_READS / (DB_BLOCK_GETS + CONSISTENT_GETS)) "Hit Ratio"
 FROM V$BUFFER_POOL_STATISTICS;
	 

/* Dictionary cache */ 
SELECT parameter
     , sum(gets)
     , sum(getmisses)
     , 100*sum(gets - getmisses) / sum(gets)  pct_succ_gets
     , sum(modifications)                     updates
  FROM V$ROWCACHE
 WHERE gets > 0
 GROUP BY parameter;

 
 SELECT namespace
     , pins
     , pinhits
     , reloads
     , invalidations
  FROM V$LIBRARYCACHE
 ORDER BY namespace
	 

/* Размер UGA PGA */	 
SELECT 'session uga memory' as NAME , SUM(VALUE)  as VALUE
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session uga memory'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#
union all
SELECT 'session uga memory max' as NAME , SUM(VALUE)  as VALUE
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session uga memory max'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#
UNION ALL
SELECT 'session pga memory' as NAME , SUM(VALUE)  as VALUE
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session pga memory'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#
union all
SELECT 'session pga memory max' as NAME , SUM(VALUE)  as VALUE
FROM V$SESSTAT, V$STATNAME
WHERE NAME = 'session pga memory max'
AND V$SESSTAT.STATISTIC# = V$STATNAME.STATISTIC#


/* Размер Shared pool reserved */ 
select * from V$SHARED_POOL_RESERVED	 

/* Кол-во повторных попыток сбросить redo buffer */ 
SELECT NAME, VALUE
  FROM V$SYSSTAT
 WHERE NAME = 'redo buffer allocation retries';

/* Статистика по PGA */ 
 SELECT * FROM V$PGASTAT;

/* Прогноз PGA */ 
SELECT LOW_OPTIMAL_SIZE/1024 low_kb, (HIGH_OPTIMAL_SIZE+1)/1024 high_kb, 
       estd_optimal_executions estd_opt_cnt, 
       estd_onepass_executions estd_onepass_cnt, 
       estd_multipasses_executions estd_mpass_cnt 
  FROM v$pga_target_advice_histogram 
 WHERE pga_target_factor = 2 
   AND estd_total_executions != 0 
 ORDER BY 1; 

SELECT LOW_OPTIMAL_SIZE/1024 low_kb,
       (HIGH_OPTIMAL_SIZE+1)/1024 high_kb,
       OPTIMAL_EXECUTIONS, ONEPASS_EXECUTIONS, MULTIPASSES_EXECUTIONS
  FROM V$SQL_WORKAREA_HISTOGRAM
 WHERE TOTAL_EXECUTIONS != 0;
 
 SELECT round(PGA_TARGET_FOR_ESTIMATE/1024/1024) target_mb,
       ESTD_PGA_CACHE_HIT_PERCENTAGE cache_hit_perc,
       ESTD_OVERALLOC_COUNT
  FROM V$PGA_TARGET_ADVICE;



