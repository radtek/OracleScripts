rem --- �� ��ࢮ� ����᪥ �� ���� �믮��塞 Service.bat
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

rem --- ����ன�� ��६�����
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

rem --- ��ࠢ��� ���� � ���
del /Q %DIR_AREMOTE_OUT%zzMoveArchiveLog*.rar
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zzMoveArchiveLog_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat
goto :eof



rem ========================================================================================


:RunLog

rem -- �஢��塞 ��ࠫ���쭮� �믮������ ��楤��� Update
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

rem --- ��।��塞 �ࢥ� ९����樨
SQLPLUS /nolog @srv_info.sql %ORACLE_SID%

rem --- ���ଠ�� � ��᪠�
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
rem --- ��楤�� १�ࢭ��� ����஢���� � �ᯮ�짮������ RMAN
rman target / nocatalog @backuplogs.script 
rem pause Press any key to exit

rem ����஢���� �� �������� ������ 1 
echo y | net use p: \\%IP_ARM1%
mkdir p:\hotcopy
mkdir p:\hotcopy\backup
robocopy %DIR_BACKUP% p:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use p: /delete

rem ����஢���� �� �������� ������ 2 
echo y | net use p: \\%IP_ARM2%
mkdir p:\hotcopy
mkdir p:\hotcopy\backup
robocopy %DIR_BACKUP% p:\HotCopy\backup\ /MIR /NP /R:0
echo y | net use p: /delete

rem ����஢���� �� ��� USB 
if .%USB_DRIVE%.==.. goto skip_usb
mkdir %USB_DRIVE%hotcopy
mkdir %USB_DRIVE%hotcopy\backup
robocopy %DIR_BACKUP% %USB_DRIVE%HotCopy\backup\ /MIR /NP /R:0
:skip_usb

goto :eof



rem ========================================================================================



:RunBeginEndBackup
rem --- ��楤�� १�ࢭ��� ����஢���� � �ᯮ�짮������ begin backup / end backup

rem --- �� ��直� ��砩 �������⥫쭮 
rem --- ��४��砥� ⥪�騩 ��ୠ��� 䠩� ORACLE 
rem --- � ��娢��㥬 �� ⥪�騥 ��ୠ�� �࠭���権 - � ��㧠��, 
rem --- �⮡� �ᯥ� �������� ����� ��娢�樨 ARCH
SQLPLUS /nolog @SwitchLog.sql %ORACLE_SID% 
sleep.exe 10
SQLPLUS /nolog @archiveLog.sql %ORACLE_SID%
sleep.exe 20


rem --- �����㥬 䠩�� (⮫쪮 ���� ��� ���������) ��娢��� ��ୠ��� �࠭���権 
rem --- � ��⠫�� ⥪�饣� backup'� � �� ��㣨� ࠡ�稥 �⠭樨 � ��

xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc %DIR_HOTCOPY%archive\

rem ����஢���� �� �������� ������ 1 
echo y | net use p: \\%IP_ARM1%
mkdir p:\hotcopy
mkdir p:\hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc p:\HotCopy\Archive\
echo y | net use p: /delete

rem ����஢���� �� �������� ������ 2 
echo y | net use p: \\%IP_ARM2%
mkdir p:\hotcopy
mkdir p:\hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc p:\HotCopy\Archive\
echo y | net use p: /delete

rem ����஢���� �� ��� USB 
if .%USB_DRIVE%.==.. goto skip_usb
mkdir %USB_DRIVE%hotcopy
mkdir %USB_DRIVE%hotcopy\archive
xcopy /Y /R /F /d %DIR_ARCHIVE%*.arc %USB_DRIVE%hotcopy\archive\
:skip_usb

rem -- �஢��塞 ��ࠫ���쭮� �믮������ HotCopy.bat
if exist %DIR_TMP%HotCopy.is GOTO step2

:step1
rem -- �᫨ HotCopy.bat �� �믮������, � 㤠�塞 ���� 䠩�� (��⠢�塞 �� 1 ��⪨) 
waitdel %DIR_ARCHIVE%*.arc 1 00:00:00
forfiles -p%DIR_ARCHIVE% -m*.arc -d-2 -c"cmd /c del """@PATH\@FILE""" /f /q"

GOTO next

:step2
rem -- �᫨ HotCopy.bat ����������� �����������, � ���� 䠩�� �� 㤠�塞
rem -- ������ 䫠� HotCopy.is �᫨ �� ���� 1 ���
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

rem -- �஢��塞 ��ࠫ���쭮� �믮������ HotCopy.bat
if exist %DIR_TMP%HotCopy.is GOTO :eof

rem �஢��塞 䫠� ������⭮�� ����᪠
date /T > %DIR_TMP%CheckDate.is
findstr /G:%DIR_TMP%CheckDate.is %DIR_TMP%RunServiceOnce.is
IF %ERRORLEVEL% EQU 0 goto :eof

date /T > %DIR_TMP%RunServiceOnce.is
CALL RunService.bat

goto :eof


rem ========================================================================================
