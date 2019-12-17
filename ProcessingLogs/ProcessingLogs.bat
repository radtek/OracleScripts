SET ORACLE_HOME=c:\oracle\ora10
SET PATH=c:\oracle\ora10\bin;%PATH%

SET DIR_IN=\\kmisql1\d$\aremote\azs\backup_log\
SET DIR_TEMP=d:\temp\ProcessingLogs\
SET DIR_ARC=\\kmisql1\d$\aremote\azs\BACKUP_LOG\archive\
SET DIR_LOAD=d:\temp\ProcessingLogs\load\
SET LOG=%CD%\ProcessingLogs.log

mkdir %DIR_TEMP%
mkdir %DIR_ARC%
mkdir %DIR_LOAD%

waitdel %DIR_ARC%*MoveArchiveLog*.rar 1 00:00:00
DEL /Q %DIR_TEMP%*.err

rem -- отправим предыдущий лог-файл на обработку
rar a -ag -df %DIR_IN%ProcessingLogsLog_NB_%COMPUTERNAME%_%COMPUTERNAME%_.rar %CD%\ProcessingLogs.log

for %%q in (%DIR_IN%*Log_NB_*.rar) do call :RunRar %%q %%~nq >> %LOG%

for %%I in (%DIR_LOAD%*_ProcessingLogs*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr_proclogs.ctl 0 0 >> %LOG%

for %%I in (%DIR_LOAD%*_error*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr_repl.ctl 10 3 >> %LOG%
for %%I in (%DIR_LOAD%*_rrr*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr_repl.ctl 10 3 >> %LOG%
for %%I in (%DIR_LOAD%*_*ALRT*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr_alert.ctl 10 3 >> %LOG%
for %%I in (%DIR_LOAD%*_*ALERT*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr_alert.ctl 10 3 >> %LOG%

for %%I in (%DIR_LOAD%*.log) do call :RunLog %%I %%~nI %%~xI %%~tI %%~zI sqlldr.ctl 0 0 >> %LOG%

goto :eof


:RunRar
SET REPL_NAME=UNKNOWN
for /F "usebackq tokens=1,2,3,4,5 delims=_" %%i in (`echo %2`) DO SET REPL_NAME=%%k

SET ARM_NAME=UNKNOWN
for /F "usebackq tokens=1,2,3,4,5 delims=_" %%i in (`echo %2`) DO SET ARM_NAME=%%l

SET FILE_DT=UNKNOWN
for /F "usebackq tokens=1,2,3,4,5 delims=_" %%i in (`echo %2`) DO SET FILE_DT=%%m

SET SERVER_NAME=%REPL_NAME%@%ARM_NAME%
IF .%FILE_DT%. EQU .UNKNOWN. SET SERVER_NAME=%REPL_NAME%
IF .%FILE_DT%. EQU .. SET SERVER_NAME=%REPL_NAME%
IF .%REPL_NAME%. EQU .%ARM_NAME%. SET SERVER_NAME=%REPL_NAME%

DEL /Q %DIR_TEMP%*.log
rar e -y -ep %1 %DIR_TEMP% 

for %%I in (%DIR_TEMP%*.log) do call :RunUnPack %%I %SERVER_NAME% %%~nI 

echo Y | move /Y %1 %DIR_ARC%

goto :eof



:RunUnPack
xcopy /Y /C /F /R /D %1 %DIR_LOAD%%2_%3.*
goto :eof



:RunLog
SQLPLUS /nolog @trunc_buf.sql 

SET HEADER_ROWS=%8
IF .%8. EQU .. SET HEADER_ROWS=0
IF .%8. EQU .0. SET HEADER_ROWS=0

SET FOOTER_ROWS=%9
IF .%9. EQU .. SET FOOTER_ROWS=0
IF .%9. EQU .0. SET FOOTER_ROWS=0

head -%HEADER_ROWS% %1 > %DIR_TEMP%header.txt
tail -%FOOTER_ROWS% %1 > %DIR_TEMP%footer.txt

sqlldr silent parfile=sqlldr.par data=%DIR_TEMP%header.txt control=sqlldr_header.ctl 
sqlldr silent parfile=sqlldr.par data=%1 control=%7 bad=%DIR_TEMP%%2.bad log=%DIR_TEMP%%2.err
sqlldr silent parfile=sqlldr.par data=%DIR_TEMP%footer.txt control=sqlldr_footer.ctl 

SQLPLUS /nolog @exec_buf.sql %2%3 %4 %5 %6

DEL /Q %1

goto :eof


