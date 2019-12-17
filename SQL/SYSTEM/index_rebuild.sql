-- Выполнить сразу
select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSRPLIDX '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSREPLIDX' 

select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSTMPIDX '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSTEMPIDX' and owner<>'PARUS' 
	
select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSTMPIDX '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSTEMPIDX'  

select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSIDX1 '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSIDX2' and NVL(num_rows,0)>=0 and num_rows<500000
	
-- Выполнить позже	
select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSIDX1 '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSIDX2' 



select 'alter index '||owner||'.'||index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace PARUSIDX4 '||DECODE(LOGGING,'YES','LOGGING','NOLOGGING')||';'
  from sys.all_indexes
    where tablespace_name = 'PARUSIDX3'
