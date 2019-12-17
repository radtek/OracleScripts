--
-- SHOW_OBJECT_TYPE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.show_object_type(obj_type_in IN VARCHAR2)
IS
BEGIN
DBMS_OUTPUT.PUT_LINE
(RPAD(obj_type_in,30)||
RPAD('Free blocks',15)||
RPAD('Total blocks',15)||
RPAD('Unused blocks',15)||
RPAD('Unused bytes',15)
);
DBMS_OUTPUT.PUT_LINE
(RPAD('-',30,'-')||
RPAD('-',15,'-')||
RPAD('-',15,'-')||
RPAD('-',15,'-')||
RPAD('-',15,'-')
);
OPEN object_cur(obj_type_in);
LOOP
FETCH object_cur INTO obj_rec;
EXIT WHEN object_cur%NOTFOUND;
IF obj_rec.TEMPORARY = 'N' THEN
DBMS_SPACE.FREE_BLOCKS (
segment_owner => USER,
segment_name => obj_rec.object_name,
segment_type => obj_type_in,
freelist_group_id => 0,
free_blks => free_blks);
DBMS_SPACE.UNUSED_SPACE(
segment_owner => USER,
segment_name => obj_rec.object_name,
segment_type => obj_type_in,
total_blocks => total_blocks,
total_bytes => total_bytes,
unused_blocks => unused_blocks,
unused_bytes => unused_bytes,
last_used_extent_file_id => last_used_extent_file_id,
last_used_extent_block_id => last_used_extent_block_id,
last_used_block => last_used_block);
DBMS_OUTPUT.PUT_LINE
(RPAD(obj_rec.object_name,30)||
RPAD(free_blks,15)||
RPAD(total_blocks,15)||
RPAD(unused_blocks,15)||
RPAD(unused_bytes,15)
);
END IF;
END LOOP;
CLOSE object_cur;
END show_object_type;

/

