WHENEVER SQLERROR CONTINUE

SPOOL SwitchLog.log 
Connect / as sysdba
ALTER SYSTEM SWITCH LOGFILE;
exit