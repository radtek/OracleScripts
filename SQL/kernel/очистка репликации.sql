-- Очистка ZREPL_META
begin
  for lcur in (select distinct trunc(data) as data from lider.zrepl_meta where status=1 and data<sysdate-10) loop
    delete from lider.zrepl_meta where status=1 and data>lcur.data-1 and data<lcur.data+1;
    commit;
  end loop;
end;  

-- Очистка ZREPL_MSG_I
begin
  for lcur in (select distinct trunc(data) as data from lider.zrepl_msg_i where data<sysdate-10) loop
    delete from lider.zrepl_msg_i where data>lcur.data-1 and data<lcur.data+1;
    commit;
  end loop;
end;

-- Очистка ZREPL_MSG
begin
  for lcur in (select distinct trunc(data) as data from lider.zrepl_msg where data<sysdate-10-1) loop
    delete from lider.zrepl_msg where data>lcur.data-1 and data<lcur.data+1;
    commit;
  end loop;
end;

      


CREATE INDEX LIDER.zrepl_msg_i_data_idx ON LIDER.ZREPL_MSG_I
(DATA)
LOGGING
NOPARALLEL;



CREATE INDEX lider.ZREPL_META_DATA_IDX ON lider.ZREPL_META
(DATA)
LOGGING
NOPARALLEL;




select distinct trunc(data) as data from lider.zrepl_meta where status=1 and data<sysdate-10

