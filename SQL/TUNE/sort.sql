/* Выводит список пользователей, в данное время использующих временное табличное пр-во (TEMP) */

select username, sql_text, sorts, rows_processed, optimizer_mode, 
   parsing_user_id, address, sq.module, session_addr, session_num, extents
      from v$sql sq, v$sort_usage sr, v$session ss
 	   	  where sq.address = sr.sqladdr 
		     and sr.SESSION_NUM = ss.SERIAL#
	   		    order by address ;