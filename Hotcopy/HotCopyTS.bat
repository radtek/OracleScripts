rem **************************************************
rem  ����祥 ����஢���� �⤥�쭮�� 䠩�� ⠡��筮�� ����࠭�⢠ 
rem **************************************************
SQLPLUS /nolog @BckpTS %1 %2 Begin  
XCOPY /F /R /Y %3 %4 
SQLPLUS /nolog @BckpTS %1 %2 End    

rem --- ��७�ᨬ 䠩�(�) �� �६���� RAR-��娢
"C:\Program Files\WinRAR\RAR.exe" m -m1 -ep2 -ri1 %TEMP_BACKUPFILE% %4*.dbf
