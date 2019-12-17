rem **************************************************
rem  Горячее копирование отдельного файла табличного пространства 
rem **************************************************
SQLPLUS /nolog @BckpTS %1 %2 Begin  
XCOPY /F /R /Y %3 %4 
SQLPLUS /nolog @BckpTS %1 %2 End    

rem --- переносим файл(ы) во временный RAR-архив
"C:\Program Files\WinRAR\RAR.exe" m -m1 -ep2 -ri1 %TEMP_BACKUPFILE% %4*.dbf
