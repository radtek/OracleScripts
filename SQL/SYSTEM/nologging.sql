select 'alter TABLE ' || owner || '.' || table_name || ' NOLOGGING;' from all_tables
where owner='PARUS' and logging='YES' and table_name in 
(
select a.table_name
 from ALL_TAB_COLUMNS a,all_tables b 
 where a.COLUMN_NAME='IDENT' AND a.owner='PARUS'
   and a.owner=b.owner
   and a.table_name=b.table_name
   and b.logging='YES' 
)

select /*+ RULE */ 'alter index '||owner||'.'||segment_name||' rebuild online storage (pctincrease 0) tablespace TEMPIDX NOLOGGING;'
  from sys.dba_segments a
    where segment_type = 'INDEX'
	  and owner='PARUS'
	  and segment_name in 
(
select index_name from all_indexes
where logging='YES' and owner='PARUS' and table_name in 
(
select a.table_name
 from ALL_TAB_COLUMNS a,all_tables b 
 where a.COLUMN_NAME='IDENT' AND a.owner='PARUS'
   and a.owner=b.owner
   and a.table_name=b.table_name
   and b.logging='NO' 
)
) 









select 'alter TABLE ' || owner || '.' || table_name || ' LOGGING;' from all_tables
where logging='NO'  AND temporary='N'
union all
select 'alter index '||owner||'.'||segment_name||' rebuild online LOGGING;'
  from sys.dba_segments a
where segment_name in 
(
select index_name from all_indexes
where logging='NO' OR table_name in 
(
select table_name
 from all_tables 
 where logging='NO'  AND temporary='N' 
)
)

 

SELECT tablespace_name, segment_type, owner, segment_name
FROM dba_extents
WHERE file_id = :File
and :Block between block_id AND block_id + blocks - 1

  