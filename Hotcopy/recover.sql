WHENEVER SQLERROR CONTINUE

spool recover.log

Connect / as sysdba

shutdown immediate

startup mount

RECOVER AUTOMATIC DATABASE;

ALTER DATABASE OPEN;

spool off

exit
