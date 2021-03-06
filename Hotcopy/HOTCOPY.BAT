rem --- � ��砫� �믮��塞 MoveArchiveLog.bat
rem --- � १���� �� �믮��塞 ���������� �ணࠬ� � �ਯ⮢ ������ (�᫨ ����室���)
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
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zzHotCopyLog_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat
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
rem -- ������� 䫠�, ��� �।���饭�� ��ࠫ���쭮�� ����᪠ MoveArchiveLog.bat 
echo HotCopy started %DATE% %TIME% > %DIR_TMP%hotcopy.is 

rem --- ����塞 䠩� �६������ RAR-��娢�
DEL /Q %TEMP_BACKUPFILE%

IF .%USE_RMAN%.==.NO. CALL :RunBeginEndBackup
IF .%USE_RMAN%.==.YES. CALL :RunRMANBackup

rem *** ����ࠥ� � ��娢��㥬 ���䨣��樮��� 䠩��
CALL ConfigAZS.bat

rem --- ��।��塞 �ࢥ� ९����樨
SQLPLUS /nolog @srv_info.sql %ORACLE_SID% 

rem --- ���ଠ�� � ��᪠�, �������, �ਭ���
IF EXIST GetDeviceInfo.exe (
GetDeviceInfo.exe /disk /log
GetDeviceInfo.exe /monitor /log
GetDeviceInfo.exe /printer /log
) ELSE (
GetDiskInfo.exe C:
GetDiskInfo.exe D:
GetDiskInfo.exe E:
)

rem -- ����塞 �६���� 䠩��
DEL /Q %DIR_TMP%HotCopy.is
DEL /Q %TEMP_BACKUPFILE%

goto :eof


rem ========================================================================================

:RunRMANBackup
rem --- ��楤�� १�ࢭ��� ����஢���� � �ᯮ�짮������ RMAN
rman target / nocatalog @backupfull.script 
rem pause Press any key to exit

rem --- �����㥬 ����� �� ��㣨� ࠡ�稥 �⠭樨 � �� � ����頥� ���ॢ訥 ��娢�� ��ୠ�� �࠭���権
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

rem --- �����㥬 䠩�� ����஥� ���� ������
XCOPY %DIR_PFILE%*.*  %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY %DIR_DATABASE%*.ora %DIR_TMP%DATABASE\ /Y /R /F 
XCOPY C:%ORA805_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY C:%ORA817_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY D:%ORA817_NETA%*.ora %DIR_TMP%ADMIN\ /Y /R /F 
XCOPY set_var.bat %DIR_TMP%ADMIN\ /Y /R /F 

rem --- �⮡ࠦ��� ᮤ�ন��� ��⠫��� � ����� ������
echo [LIST_ORADATA]
dir %DIR_ORADATA% /ON /TW /4 /A-D
echo [LIST_ORADATA_END]

rem --- �஢���� ������ ���ॢ�� ��娢��� ��ୠ��� �ࠧ��権
waitdel %DIR_HOTCOPY%archive\*.* 8 00:00:00 
forfiles -p%DIR_HOTCOPY%archive -m*.* -d-9 -c"cmd /c del """@PATH\@FILE""" /f /q"

rem --- �����㥬 䠩�� �� *.dbf
Call HotCopyTS.bat %ORACLE_SID% SYSTEM          %DIR_ORADATA%SYSTEM*.DBF    %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% USERS           %DIR_ORADATA%USERS*.DBF     %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% RBS             %DIR_ORADATA%RBS*.DBF       %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% IDX             %DIR_ORADATA%INDX*.DBF      %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% REPL            %DIR_ORADATA%REPL*.DBF      %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% AUDIT_KERNEL    %DIR_ORADATA%AUDIT*.DBF     %DIR_TMP% 
Call HotCopyTS.bat %ORACLE_SID% TOOLS           %DIR_ORADATA%TOOLS*.DBF     %DIR_TMP% 

rem *** ᮧ���� ����� ctl-䠩�� 
SQLPLUS /nolog @BckpCtl.sql   %ORACLE_SID% %DIR_TMP% 
XCOPY %DIR_TMP%CONTROL01.CTL %DIR_TMP%CONTROL02.* /R /Y /F 
XCOPY %DIR_TMP%CONTROL01.CTL %DIR_TMP%CONTROL03.* /R /Y /F 

rem --- ��४��砥� ⥪�騩 ��ୠ��� 䠩� ORACLE 
rem --- � ��娢��㥬 �� ⥪�騥 ��ୠ�� �࠭���権 - � ��㧠��, 
rem --- �⮡� �ᯥ� �������� ����� ��娢�樨 ARCH
SQLPLUS /nolog @SwitchLog.sql %ORACLE_SID% 
sleep.exe 10
SQLPLUS /nolog @archiveLog.sql %ORACLE_SID% 
sleep.exe 20

rem --- �����㥬 ⥪�騥 ��ୠ��� 䠩�� redo*.log
XCOPY %DIR_ORADATA%redo*.log %DIR_TMP% /F /R /Y 

rem --- �����㥬 �� �६���� ��⠫�� 䠩�� ��娢��� ��ୠ��� �࠭���権,
rem --- ����� ���������� �� �६� ��楤��� backup'�
xcopy /Y /R /F %DIR_ARCHIVE%*.arc %DIR_TMP%archive\ 

rem --- ������塞 �� �६���� RAR-��娢 �������⥫�� 䠩��
"C:\Program Files\WinRAR\RAR.exe" m -m1 -ep2 -ri1 %TEMP_BACKUPFILE% %DIR_TMP%*.dbf %DIR_TMP%*.ctl %DIR_TMP%*.log %DIR_TMP%ADMIN\*.* %DIR_TMP%DATABASE\*.* %DIR_TMP%ARCHIVE\*.arc 

rem --- ��२�����뢠�� ���� backup
xcopy /Y /R /F %DIR_HOTCOPY%backup\HotCopy.rar %DIR_HOTCOPY%backup\HotCopyPrev.* 

rem --- ᮧ���� ���� �����
xcopy /Y /R /F %TEMP_BACKUPFILE% %DIR_HOTCOPY%backup\HotCopy.* 

rem --- �⮡ࠦ��� ᮤ�ন��� ��᫥����� ������
echo [LIST_BACKUP]
dir %DIR_HOTCOPY%backup\HotCopy.rar /ON /TW /4 /A-D
"C:\Program Files\WinRAR\RAR.exe" l %DIR_HOTCOPY%backup\HotCopy.rar
echo [LIST_BACKUP_END]

rem --- �����㥬 ����� �� ��㣨� ࠡ�稥 �⠭樨 � �� � ����頥� ���ॢ訥 ��娢�� ��ୠ�� �࠭���権
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

rem ����஢���� �� ��� USB 
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

