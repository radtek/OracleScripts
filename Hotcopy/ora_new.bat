set ORACLE_SID=NB
set ORACLE_HOME=D:\Oracle
set PATH=D:\Oracle\BIN;%PATH%
oradim -new -sid NB -intpwd master -startmode auto -pfile "D:\oracle\admin\NB\pfile\initNB.ora"
