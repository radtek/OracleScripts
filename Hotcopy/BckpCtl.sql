WHENEVER SQLERROR CONTINUE

SPOOL BckpCtl.Log
Connect / as sysdba
alter database backup controlfile to '&2.control01.ctl' reuse;
exit
