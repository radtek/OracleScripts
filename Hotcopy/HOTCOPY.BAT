rem --- В начале выполняем MoveArchiveLog.bat
rem --- В результате мы выполняем обновление программ и скриптов бакапа (если необходимо)
CALL MoveArchiveLog.bat 

@echo on
SET FILETYPE=HOTCOPY
SET LOG=HotCopy.log
SET FILE=HotCopy.bat
SET STATUS=OK
SET VERSION=4.1
SET USB_DRIVE=
SET ARGUS_SERVER=%COMPUTERNAME%
SET USE_RMAN=NO
SET DIR_BACKUP=D:\ARCHIVE\NB\
set nls_lang=AMERICAN_AMERICA.CL8MSWIN1251

echo. > %LOG% 2>&1
echo Type: %FILETYPE% >> %LOG% 2>&1
echo File: %CD%\%FILE% >> %LOG% 2>&1
echo Log: %CD%\%LOG% >> %LOG% 2>&1
echo Directory: %CD% >> %LOG% 2>&1
echo Computer: %COMPUTERNAME% >> %LOG% 2>&1
echo Version: %VERSION% >> %LOG% 2>&1
echo Started: %DATE% %TIME% >> %LOG% 2>&1
echo Username: %USERNAME% >> %LOG% 2>&1
echo ORACLE_HOME: %ORACLE_HOME% >> %LOG% 2>&1
echo ORACLE_SID: %ORACLE_SID% >> %LOG% 2>&1
echo PATH: %PATH% >> %LOG% 2>&1
echo. >> %LOG% 2>&1

rem --- Настройка переменных
echo ---------------------------------------------------------- >> %LOG% 2>&1
CALL set_var.bat >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1

CALL :RunLog >> %LOG% 2>&1

echo. >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1
echo Finished: %DATE% %TIME% >> %LOG% 2>&1
echo Status: %STATUS% >> %LOG% 2>&1

rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zzHotCopyLog_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat
goto :eof





rem ========================================================================================

:RunLog
rem -- Проверяем параллельное выполнение процедуры Update
if exist %DIR_TMP%update.is GOTO skip_run
GOTO exec_run

:skip_run
echo ------------------------------------ 
echo WARNING!!! Update is running
echo ------------------------------------ 
SET STATUS=UPDATE_RUNNING
GOTO :eof

:exec_run
rem -- Создаем флаг, для предотвращения параллельного запуска MoveArchiveLog.bat 
echo HotCopy started %DATE% %TIME% > %DIR_TMP%hotcopy.is 

rem --- Удаляем файл временного RAR-архива
DEL /Q %TEMP_BACKUPFILE%

IF .%USE_RMAN%.==.NO. CALL :RunBeginEndBackup
IF .%USE_RMAN%.==.YES. CALL :RunRMANBackup

rem *** Собираем и архивируем конфигурационные файлы
CALL ConfigAZS.bat

rem --- Определяем сервер репликации
SQLPLUS /nolog @srv_info.sql %ORACLE_SID% 

rem --- Информация о дисках, мониторах, принтерах
IF EXIST GetDeviceInfo.exe (
GetDeviceInfo.exe /disk /log
GetDeviceInfo.exe /monitor /log
GetDeviceInfo.exe /printer /log
) ELSE (
GetDiskInfo.exe C:
GetDiskInfo.exe D:
GetDiskInfo.exe E:
)

rem -- Удаляем временные файлы
DEL /Q %DIR_TMP%HotCopy.is
DEL /Q %TEMP_BACKUPFILE%

goto :eof


rem ========================================================================================

:RunRMANBackup
rem --- Процедура резервного копирования с использованием RMAN
rman target / nocatalog @backupfull.script 
rem pause Press any key to exit

rem --- копируем бакап на другие рабочие станции в сети и подчищаем устаревшие архивные журналы транзакций
echo y | net use o: \\%IP_ARM1% 
mkdir o:\hotcopy
mkdir o:\hotcopy\backup
robocopy %DIR_BACKUP% o:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use o: /delete

echo y | net use o: \\%IP_ARM2%
mkdir o:\hotcopy
mkdir o:\hotcopy\backup
robocopy %DIR_BACKUP% o:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use o: /delete

rem Копирование на диск USB 
if .%USB_DRIVE%.==.. goto skip_usb
mkdir %USB_DRIVE%hotcopy
mkdir %USB_DRIVE%hotcopy\backup
robocopy %DIR_BACKUP% %USB_DRIVE%HotCopy\backup\ /MIR /NP /R:0
:skip_usb

goto :eof


rem ========================================================================================


:RunBeginEndBackup
rem --- Процедура резервного копирования с использованием begin backup / end backup

rem --- на всякий случай дополнительно 
rem --- переключаем текущий журнальный файл ORACLE 
rem --- и архивируем все текущие журналы транзакций - с паузами, 
rem --- чтобы успел проснуться процесс архивации ARCH
SQLPLUS /nolog @SwitchLog.sql %ORACLE_SID% 
sleep.exe 10
SQLPLUS /nolog @archiveLog.sql %ORACLE_SID% 
sleep.exe 20

rem --- Копируем файлы настроек базы данных
XCOPY %DIR_PFILE%*.*  %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY %DIR_DATABASE%*.ora %DIR_TMP%DATABASE\ /Y /R /F 
XCOPY C:%ORA805_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY C:%ORA817_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY D:%ORA817_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY set_var.bat %DIR_TMP%ADMIN\ /Y /R /F 

rem --- отображаем содержимое каталога с базой данных
echo [LIST_ORADATA]
dir %DIR_ORADATA% /ON /TW /4 /A-D
echo [LIST_ORADATA_END]

rem --- проведем зачистку устаревших архивных журналов тразакций
waitdel %DIR_HOTCOPY%archive\*.* 8 00:00:00 
forfiles -p%DIR_HOTCOPY%archive -m*.* -d-9 -c"cmd /c del """@PATH\@FILE""" /f /q"

rem --- Копируем файлы БД *.dbf
Call HotCopyTS.bat %ORACLE_SID% SYSTEM          %DIR_ORADATA%SYSTEM*.DBF    %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% USERS           %DIR_ORADATA%USERS*.DBF     %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% RBS             %DIR_ORADATA%RBS*.DBF       %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% IDX             %DIR_ORADATA%INDX*.DBF      %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% REPL            %DIR_ORADATA%REPL*.DBF      %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% AUDIT_KERNEL    %DIR_ORADATA%AUDIT*.DBF     %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% TOOLS           %DIR_ORADATA%TOOLS*.DBF     %DIR_TMP% 

rem *** создаем копию ctl-файла 
SQLPLUS /nolog @BckpCtl.sql   %ORACLE_SID% %DIR_TMP% 
XCOPY %DIR_TMP%CONTROL01.CTL %DIR_TMP%CONTROL02.* /R /Y /F 
XCOPY %DIR_TMP%CONTROL01.CTL %DIR_TMP%CONTROL03.* /R /Y /F 

rem --- Переключаем текущий журнальный файл ORACLE 
rem --- и архивируем все текущие журналы транзакций - с паузами, 
rem --- чтобы успел проснуться процесс архивации ARCH
SQLPLUS /nolog @SwitchLog.sql %ORACLE_SID% 
sleep.exe 10
SQLPLUS /nolog @archiveLog.sql %ORACLE_SID% 
sleep.exe 20

rem --- Копируем текущие журнальные файлы redo*.log
XCOPY %DIR_ORADATA%redo*.log %DIR_TMP% /F /R /Y 

rem --- Копируем во временный каталог файлы архивных журналов транзакций,
rem --- которые накопились за время процедуры backup'а
xcopy /Y /R /F %DIR_ARCHIVE%*.arc %DIR_TMP%archive\ 

rem --- Добавляем во временный RAR-архив дополнительные файлы
"C:\Program Files\WinRAR\RAR.exe" m -m1 -ep2 -ri1 %TEMP_BACKUPFILE% %DIR_TMP%*.dbf %DIR_TMP%*.ctl %DIR_TMP%*.log %DIR_TMP%ADMIN\*.* %DIR_TMP%DATABASE\*.* %DIR_TMP%ARCHIVE\*.arc 

rem --- переименовываем старый backup
xcopy /Y /R /F %DIR_HOTCOPY%backup\HotCopy.rar %DIR_HOTCOPY%backup\HotCopyPrev.* 

rem --- создаем новый бакап
xcopy /Y /R /F %TEMP_BACKUPFILE% %DIR_HOTCOPY%backup\HotCopy.* 

rem --- отображаем содержимое последнего бакапа
echo [LIST_BACKUP]
dir %DIR_HOTCOPY%backup\HotCopy.rar /ON /TW /4 /A-D
"C:\Program Files\WinRAR\RAR.exe" l %DIR_HOTCOPY%backup\HotCopy.rar
echo [LIST_BACKUP_END]

rem --- копируем бакап на другие рабочие станции в сети и подчищаем устаревшие архивные журналы транзакций
echo y | net use o: \\%IP_ARM1% 
mkdir o:\hotcopy
mkdir o:\hotcopy\backup
del /Q o:\HotCopy\backup\HotCopyPrev.rar
rename o:\HotCopy\backup\HotCopy.rar HotCopyPrev.rar
xcopy /Y /R /F %DIR_HOTCOPY%backup\HotCopy.rar o:\HotCopy\backup\
waitdel o:\hotcopy\archive\*.* 8 00:00:00
forfiles -po:\hotcopy\archive -m*.* -d-9 -c"cmd /c del """@PATH\@FILE""" /f /q"
echo y | net use o: /delete

echo y | net use o: \\%IP_ARM2%
mkdir o:\hotcopy
mkdir o:\hotcopy\backup
del /Q o:\HotCopy\backup\HotCopyPrev.rar
rename o:\HotCopy\backup\HotCopy.rar HotCopyPrev.rar
xcopy /Y /R /F %DIR_HOTCOPY%backup\HotCopy.rar o:\HotCopy\backup\
waitdel o:\hotcopy\archive\*.* 8 00:00:00
forfiles -po:\hotcopy\archive -m*.* -d-9 -c"cmd /c del """@PATH\@FILE""" /f /q"
echo y | net use o: /delete

rem Копирование на диск USB 
if .%USB_DRIVE%.==.. goto skip_usb
mkdir %USB_DRIVE%hotcopy
mkdir %USB_DRIVE%hotcopy\backup
del /Q %USB_DRIVE%HotCopy\backup\HotCopyPrev.rar
rename %USB_DRIVE%HotCopy\backup\HotCopy.rar HotCopyPrev.rar
xcopy /Y /R /F %DIR_HOTCOPY%backup\HotCopy.rar %USB_DRIVE%HotCopy\backup\
waitdel %USB_DRIVE%hotcopy\archive\*.* 8 00:00:00
forfiles -p%USB_DRIVE%hotcopy\archive -m*.* -d-9 -c"cmd /c del """@PATH\@FILE""" /f /q"
:skip_usb

goto :eof

rem ========================================================================================

