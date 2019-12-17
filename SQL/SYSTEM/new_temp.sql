-- Изменение
spool new_temp.lst;

SELECT  'ALTER USER '||username||' TEMPORARY TABLESPACE TEMP ;' FROM sys.dba_users a;

spool off;

@new_temp.lst;



-- Проверка

SELECT   username, account_status, default_tablespace, temporary_tablespace,
         PROFILE
    FROM sys.dba_users a
  WHERE temporary_tablespace<>'TEMP'
ORDER BY temporary_tablespace,username,
         account_status,
         default_tablespace,
         temporary_tablespace,
         PROFILE;
