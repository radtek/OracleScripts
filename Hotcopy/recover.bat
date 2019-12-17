SET ORACLE_HOME=d:\oracle
SET ORACLE_SID=NB
set PATH=d:\Oracle\BIN;%PATH%
net stop oracleserviceNB
net start oracleserviceNB
d:\oracle\bin\SQLPLUS.exe /nolog @c:\hotcopy\recover.sql
