rem --- При первом запуске за день выполняем Service.bat
CALL :RunServiceOnce 

@echo on
SET FILETYPE=MOVEARCHIVELOG
SET LOG=MoveArchiveLog.log
SET FILE=MoveArchiveLog.bat
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
del /Q %DIR_AREMOTE_OUT%zzMoveArchiveLog*.rar
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zzMoveArchiveLog_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat
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


IF .%USE_RMAN%.==.NO. CALL :RunBeginEndBackup
IF .%USE_RMAN%.==.YES. CALL :RunRMANBackup



DEL /Q %DIR_TMP%move\*.*

rem --- Определяем сервер репликации
SQLPLUS /nolog @srv_info.sql %ORACLE_SID%

rem --- Информация о дисках
IF EXIST GetDeviceInfo.exe (
GetDeviceInfo.exe /disk /log /test
) ELSE (
GetDiskInfo.exe C:
GetDiskInfo.exe D:
GetDiskInfo.exe E:
)

goto :eof



rem ========================================================================================



:RunRMANBackup
rem --- Процедура резервного копирования с использованием RMAN
rman target / nocatalog @backuplogs.script 
rem pause Press any key to exit

rem Копирование на компьютер оператора 1 
echo y | net use p: \\%IP_ARM1%
mkdir p:\hotcopy
mkdir p:\hotcopy\backup
robocopy %DIR_BACKUP% p:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use p: /delete

rem Копирование на компьютер оператора 2 
echo y | net use p: \\%IP_ARM2%
mkdir p:\hotcopy
mkdir p:\hotcopy\backup
robocopy %DIR_BACKUP% p:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use p: /delete

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


rem --- Копируем файлы (только новые или измененные) архивных журналов транзакций 
rem --- в каталог текущего backup'а и на другие рабочие станции в сети

xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc %DIR_HOTCOPY%archive\

rem Копирование на компьютер оператора 1 
echo y | net use p: \\%IP_ARM1%
mkdir p:\hotcopy
mkdir p:\hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc p:\HotCopy\Archive\
echo y | net use p: /delete

rem Копирование на компьютер оператора 2 
echo y | net use p: \\%IP_ARM2%
mkdir p:\hotcopy
mkdir p:\hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc p:\HotCopy\Archive\
echo y | net use p: /delete

rem Копирование на диск USB 
if .%USB_DRIVE%.==.. goto skip_usb
mkdir %USB_DRIVE%hotcopy
mkdir %USB_DRIVE%hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc %USB_DRIVE%hotcopy\archive\
:skip_usb

rem -- Проверяем параллельное выполнение HotCopy.bat
if exist %DIR_TMP%HotCopy.is GOTO step2

:step1
rem -- Если HotCopy.bat НЕ выполняется, то удаляем старые файлы (оставляем за 1 сутки) 
waitdel %DIR_ARCHIVE%*.arc 1 00:00:00
forfiles -p%DIR_ARCHIVE% -m*.arc -d-2 -c"cmd /c del """@PATH\@FILE""" /f /q"

GOTO next

:step2
rem -- Если HotCopy.bat ВЫПОЛНЯЕТСЯ ПАРАЛЛЕЛЬНО, то старые файлы не удаляем
rem -- Удалем флаг HotCopy.is если он старше 1 дня
echo ------------------------------------ 
echo WARNING!!! Parallel execution with HotCopy.bat 
echo ------------------------------------ 
waitdel %DIR_TMP%HotCopy.is 1 00:00:00 
forfiles -p%DIR_TMP% -mHotCopy.is -d-2 -c"cmd /c del """@PATH\@FILE""" /f /q"
GOTO next

:next
goto :eof



rem ========================================================================================


:RunServiceOnce
CALL set_var.bat

rem -- Проверяем параллельное выполнение HotCopy.bat
if exist %DIR_TMP%HotCopy.is GOTO :eof

rem проверяем флаг однократного запуска
date /T > %DIR_TMP%CheckDate.is
findstr /G:%DIR_TMP%CheckDate.is %DIR_TMP%RunServiceOnce.is
IF %ERRORLEVEL% EQU 0 goto :eof

date /T > %DIR_TMP%RunServiceOnce.is
CALL RunService.bat

goto :eof


rem ========================================================================================
