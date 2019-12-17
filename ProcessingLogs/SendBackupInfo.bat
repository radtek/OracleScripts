SET ORACLE_HOME=c:\oracle\ora10
SET PATH=c:\oracle\ora10\bin;%PATH%
SET DIR_IN=\\kmisql1\d$\aremote\azs\in\
SET DIR_TEMP=d:\temp\SendBAckupInfo\
SET DIR_OUT=\\corp\root\outmail\Kminb_backuplogs@lukoil.com\

mkdir %DIR_TEMP%
mkdir %DIR_OUT%
mkdir %DIR_OUT%SENT

rem SQLPLUS /nolog @backup_info_old.sql > %DIR_TEMP%backup_info_old.log
SQLPLUS /nolog @backup_info.sql > %DIR_TEMP%backup_info.log
echo oracle backup log: PETRONICS > %DIR_TEMP%subject.it

rem xcopy %DIR_TEMP%backup_info_old.log %DIR_OUT% /Y /C /F
xcopy %DIR_TEMP%backup_info.log %DIR_OUT% /Y /C /F
xcopy %DIR_TEMP%subject.it %DIR_OUT% /Y /C /F


for %%q in (%DIR_IN%TestBackupLog*.rar) do call :HotCopyLog3 %%q


goto :eof


:HotCopyLog3
xcopy %1 \\corp\root\outmail\ukhta_oracle_admins@lukoil.com\ /Y /C /F
echo oracle backup log: PETRONICS > %DIR_TEMP%subject.it
xcopy %DIR_TEMP%subject.it \\corp\root\outmail\ukhta_oracle_admins@lukoil.com\ /Y /C /F

DEL /Q %1
goto :eof
