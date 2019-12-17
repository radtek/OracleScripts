WHENEVER SQLERROR CONTINUE

Connect / as sysdba
alter tablespace &2 &3 backup;
exit
