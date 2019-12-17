/* Выводит список таблиц с полями типа LONG в указанном табличном пространстве */

select distinct owner, table_name, column_name, data_type from sys.dba_tab_columns 
  where data_type = 'LONG' and table_name in
    (select table_name from sys.dba_tables 
	   where tablespace_name = 'PARUS')
   