rem --- ����ன�� ��६�����
SET USE_RMAN=NO
CALL set_var.bat

rem --- ��ࢨ� ������ ���� ����饭
net stop oracleserviceNB
net start oracleserviceNB

pause


rem --- �믮��塞 �ਯ� �� ����⠭������� ���� ������
rem --- �� �����襭�� �ਯ�, ���� ������ �㤥� ��⮢� � ࠡ��
IF .%USE_RMAN%.==.NO. CALL :RunBeginEndBackup
IF .%USE_RMAN%.==.YES. CALL :RunRMANBackup
pause

rem --- ��।��塞 �ࢥ� ९����樨
SQLPLUS /nolog @srv_info.sql %ORACLE_SID% >> restcopy.log

rem --- ��ࠢ��� ���� � ���
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 -inul %DIR_AREMOTE_OUT%RestCopyLog_%ORACLE_SID%_%COMPUTERNAME%_.rar %DIR_HOTCOPY%*.log %DIR_BDUMP%*.log



rem ========================================================================================


:RunRMANBackup
rem set nls_lang=RUSSIAN.RU8PC866
rem chcp 1251
REM SET DBID=����� �� ��᫥����� HotCopy.log
SQLPLUS / as sysdba @StartupNoMountPfile.sql > restcopy.log
rman target / nocatalog @restRMAN.script >> restcopy.log
SQLPLUS / as sysdba @OpenDatabase.sql >> restcopy.log
goto :eof


rem ========================================================================================


:RunBeginEndBackup
SQLPLUS /nolog @restcopy.sql %ORACLE_SID% %TEMP_DBFILE% 
goto :eof


rem ========================================================================================
