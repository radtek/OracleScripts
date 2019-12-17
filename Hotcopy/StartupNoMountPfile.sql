WHENEVER SQLERROR CONTINUE

Connect / as sysdba
SHUTDOWN ABORT;
startup force nomount pfile=D:\oracle\admin\NB\pfile\PFILENB.ora 
exit
