
SELECT * FROM (
SELECT l2.NAME,immediate_gets + gets total, immediate_gets "Immediates",
         misses + immediate_misses "Total Misses",
       ROUND(DECODE ( immediate_gets + gets,0,0,100 * ( ( misses + immediate_misses) / ( immediate_gets + gets) )),2) PERCENT
  FROM v$latch l1, v$latchname l2
 WHERE /*l2.NAME LIKE '%redo%' AND*/ l1.latch# = l2.latch#
 ) 
 WHERE percent>0
 order by percent desc


