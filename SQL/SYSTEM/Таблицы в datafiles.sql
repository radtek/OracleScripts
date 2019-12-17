select * from dba_data_files

select segment_name,sum(bytes) as sum from dba_extents where file_id=19 group by segment_name order by sum desc


select * from storage_raw where temperature=1000 order by temperature