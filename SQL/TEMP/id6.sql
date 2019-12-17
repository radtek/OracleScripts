SQL> 
SQL> select 'alter index '||owner||'.'||name||' rebuild tablespace '||tablespace_name
  2  ||';'
  3  from temp_stats, dba_indexes
  4  where
  5  temp_stats.name = dba_indexes.index_name
  6  and
  7  (height > 3
  8  or
  9  del_lf_rows > 10);
SQL> 
SQL> select 'analyze index '||owner||'.'||name||' compute statistics;'
  2  from temp_stats, dba_indexes
  3  where
  4  temp_stats.name = dba_indexes.index_name
  5  and
  6  (height > 3
  7  or
  8  del_lf_rows > 10);
SQL> 
SQL> spool off;
