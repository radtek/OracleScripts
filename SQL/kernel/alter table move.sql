-- создаем пустую таблицу
create table t ( x number )
   tablespace users
   storage ( initial 10M next 10M )
  
analyze table t compute statistics;

select blocks, extents from user_segments where segment_name = 'T'; -- сколько физически занято 

select blocks, empty_blocks from user_tables where table_name = 'T'; -- чем именно занято (содержит данные, в т.ч. удаленные и полностью пустые)

select count(distinct dbms_rowid.rowid_block_number(rowid)) used_blocks from t; -- без удаленных данных


-- повторяем раз 20, чтобы записей было более 500 000
insert into t    select id   from lider.goods;

select count(*) from t

analyze table t compute statistics;

select blocks, extents from user_segments where segment_name = 'T'; -- сколько физически занято 

select blocks, empty_blocks from user_tables where table_name = 'T'; -- чем именно занято (содержит данные, в т.ч. удаленные и полностью пустые)

select count(distinct dbms_rowid.rowid_block_number(rowid)) used_blocks from t; -- без удаленных данных

-- удаляем первые  500 000 записей
delete from t where rownum <= 500000;

analyze table t compute statistics;

select blocks, extents from user_segments where segment_name = 'T'; -- сколько физически занято 

select blocks, empty_blocks from user_tables where table_name = 'T'; -- чем именно занято (содержит данные, в т.ч. удаленные и полностью пустые)

select count(distinct dbms_rowid.rowid_block_number(rowid)) used_blocks from t; -- без удаленных данных

-- освобождаем пространство
alter table t deallocate unused; -- помогает, если удаляются столбцы
alter table t move tablespace users; -- помогает, если удаляются записи и столбцы

analyze table t compute statistics;

select blocks, extents from user_segments where segment_name = 'T'; -- сколько физически занято 

select blocks, empty_blocks from user_tables where table_name = 'T'; -- чем именно занято (содержит данные, в т.ч. удаленные и полностью пустые)

select count(distinct dbms_rowid.rowid_block_number(rowid)) used_blocks from t; -- без удаленных данных

-- скрипт для освобождения таблиц от пустых блоков 
select 'alter table '||owner||'.'||table_name||' deallocate unused;'
  from sys.all_tables
    where tablespace_name = 'USERS' and rownum<=2
union all    
select 'alter table '||owner||'.'||table_name||' move tablespace USERS_NEW;'
  from sys.all_tables
    where tablespace_name = 'USERS' and rownum<=2
union all    
select 'alter index '||a.owner||'.'||a.index_name||' rebuild '||DECODE(index_type,'BITMAP','','online')||' storage (pctincrease 0) tablespace IDX_NEW LOGGING;'
  from sys.all_indexes a,  (select * from sys.all_tables where tablespace_name = 'USERS' and rownum<=2) b
    where b.owner=a.owner and b.table_name=a.table_name  
