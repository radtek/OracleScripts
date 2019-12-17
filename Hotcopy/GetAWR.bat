@echo on
SET FILETYPE=AWR
SET LOG=awr.log
SET AWRHTML=AWR.html
SET FILE=GetAWR.bat
SET SERVICE_STATUS=OK
SET STATUS=OK
SET VERSION=1.0
SET ARGUS_SERVER=%COMPUTERNAME%
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
echo PATH: %PATH% >> %LOG% 2>&1
echo. >> %LOG% 2>&1

rem --- Настройка переменных
echo ---------------------------------------------------------- >> %LOG% 2>&1
CALL set_var.bat >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1

CALL :GetAWR >> %LOG% 2>&1

echo. >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1
echo Finished: %DATE% %TIME% >> %LOG% 2>&1
echo Status: %SERVICE_STATUS% >> %LOG% 2>&1


rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zz%FILETYPE%Log_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% %AWRHTML% set_var.bat

goto :eof



:GetAWR
rem -- Сбор статистики производительности Oracle
SQLPLUS /nolog @GetAWR.sql %DIR_HOTCOPY% %DATE% html %AWRHTML% > nul
SQLPLUS /nolog @GetAWR.sql %DIR_TMP% %DATE% text awr.txt
del /Q %DIR_TMP%awr.txt
exit /B 0

