rem --- Настройка переменных
SET USE_RMAN=NO
CALL set_var.bat

rem --- Сервис должен быть запущен
net stop oracleserviceNB
net start oracleserviceNB

pause


rem --- Выполняем скрипт по восстановлению базы данных
rem --- по завершении скрипта, база данных будет готова к работе
IF .%USE_RMAN%.==.NO. CALL :RunBeginEndBackup
IF .%USE_RMAN%.==.YES. CALL :RunRMANBackup
pause

rem --- Определяем сервер репликации
SQLPLUS /nolog @srv_info.sql %ORACLE_SID% >> restcopy.log

rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 -inul %DIR_AREMOTE_OUT%RestCopyLog_%ORACLE_SID%_%COMPUTERNAME%_.rar %DIR_HOTCOPY%*.log %DIR_BDUMP%*.log



rem ========================================================================================


:RunRMANBackup
rem set nls_lang=RUSSIAN.RU8PC866
rem chcp 1251
REM SET DBID=взять из последнего HotCopy.log
SQLPLUS / as sysdba @StartupNoMountPfile.sql > restcopy.log
rman target / nocatalog @restRMAN.script >> restcopy.log
SQLPLUS / as sysdba @OpenDatabase.sql >> restcopy.log
goto :eof


rem ========================================================================================


:RunBeginEndBackup
SQLPLUS /nolog @restcopy.sql %ORACLE_SID% %TEMP_DBFILE% 
goto :eof


rem ========================================================================================
