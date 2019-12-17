Spool c:\aa.lst
 
SELECT 'ANALYZE TABLE "' || table_name || '" COMPUTE STATISTICS;'
  FROM   all_tables
 WHERE  owner = 'TADM'
 ORDER BY 1
/

spool off

--@c:\aa.lst

