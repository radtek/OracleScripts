@echo on
SET FILETYPE=SERVICE
SET LOG=Service.log
SET COMPLOG=Computer.log
SET HDDLOG=Hdd.log
SET ORALOGFILES1=*ALRT.log
SET ORALOGFILES2=alert*.log
SET REPLLOG=error*.log
SET RRRLOG=rrr*.log
SET JOBLOG=job*.log
SET AWRHTML=AWR.html
SET FILE=Service.bat
SET SERVICE_STATUS=OK
SET STATUS=OK
SET DIR_JOB=C:\JOB\
SET DIR_REPL=C:\REPL\
SET VERSION=1.9
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

CALL :GetComputerInfo >> %LOG% 2>&1
CALL :GetHDDInfo >> %LOG% 2>&1
CALL :GetApplLog >> %LOG% 2>&1
CALL :GetAWR >> %LOG% 2>&1

echo. >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1
echo Finished: %DATE% %TIME% >> %LOG% 2>&1
echo Status: %SERVICE_STATUS% >> %LOG% 2>&1


rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zz%FILETYPE%Log_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %COMPLOG% %HDDLOG% %ORALOGFILES1% %ORALOGFILES2% %REPLLOG% %RRRLOG% %JOBLOG% %FILE% %AWRHTML% set_var.bat

goto :eof



:GetAWR
rem -- Сбор статистики производительности Oracle
SQLPLUS /nolog @GetAWR.sql %DIR_HOTCOPY% %DATE% html %AWRHTML% > nul
SQLPLUS /nolog @GetAWR.sql %DIR_TMP% %DATE% text awr.txt
del /Q %DIR_TMP%awr.txt
exit /B 0



:GetComputerInfo
rem -- Сбор информации о компьютере
SET STATUS=OK
SET COMPDIAGAPP=MSINFO32.EXE

echo. > %COMPLOG% 2>&1
echo Type: COMPUTER_INFO >> %COMPLOG% 2>&1
echo File: %COMPDIAGAPP% >> %COMPLOG% 2>&1
echo Log: %CD%\%COMPLOG% >> %COMPLOG% 2>&1
echo Directory: %CD% >> %COMPLOG% 2>&1
echo Computer: %COMPUTERNAME% >> %COMPLOG% 2>&1
echo Version: %VERSION% >> %COMPLOG% 2>&1
echo Started: %DATE% %TIME% >> %COMPLOG% 2>&1
echo Username: %USERNAME% >> %COMPLOG% 2>&1
echo. >> %COMPLOG% 2>&1
echo ---------------------------------------------------------- >> %COMPLOG% 2>&1
echo. >> %COMPLOG% 2>&1

start /wait %COMPDIAGAPP% /report %DIR_TMP%computer.txt
IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=COMPUTER_INFO_ERROR
echo Status: %STATUS%

type %DIR_TMP%computer.txt >> %COMPLOG% 2>&1
del /Q %DIR_TMP%computer.txt

rem Добавим информацию об антивирусе
xcopy /F /R /Y /D "C:\Program Files\Alwil Software\Avast5\defs\aswdefs.ini" %DIR_TMP%
xcopy /F /R /Y /D "C:\Program Files\AVAST Software\Avast\defs\aswdefs.ini" %DIR_TMP%
type %DIR_TMP%aswdefs.ini >> %COMPLOG% 2>&1
del /Q %DIR_TMP%aswdefs.ini

rem Добавим информацию о Time Zone
echo. >> %COMPLOG% 2>&1
echo [TIME_ZONE] >> %COMPLOG% 2>&1
cscript.exe timezone.vbs >> %COMPLOG% 2>&1

echo. >> %COMPLOG% 2>&1
echo ---------------------------------------------------------- >> %COMPLOG% 2>&1
echo. >> %COMPLOG% 2>&1
echo Finished: %DATE% %TIME% >> %COMPLOG% 2>&1
echo Status: %STATUS% >> %COMPLOG% 2>&1

exit /B 0

goto :eof


:GetHDDInfo
rem -- Диагностика дисков
SET STATUS=OK
SET HDDTYPE=HP_ARRAY_INFO
SET HDDDIAGAPP="C:\Program Files\Compaq\hpadu\bin\hpaducli.exe"
SET DD=%DATE%
SET TT=%TIME%

IF EXIST %HDDDIAGAPP% (CALL :GetArrayInfo %HDDDIAGAPP% %DIR_TMP%hdd.txt) ELSE CALL :GetSmartInfo %DIR_TMP%hdd.txt

echo. > %HDDLOG% 2>&1
echo Type: %HDDTYPE% >> %HDDLOG% 2>&1
echo File: %HDDDIAGAPP% >> %HDDLOG% 2>&1
echo Log: %CD%\%HDDLOG% >> %HDDLOG% 2>&1
echo Directory: %CD% >> %HDDLOG% 2>&1
echo Computer: %COMPUTERNAME% >> %HDDLOG% 2>&1
echo Version: %VERSION% >> %HDDLOG% 2>&1
echo Started: %DD% %TT% >> %HDDLOG% 2>&1
echo Username: %USERNAME% >> %HDDLOG% 2>&1
echo. >> %HDDLOG% 2>&1
echo ---------------------------------------------------------- >> %HDDLOG% 2>&1
echo. >> %HDDLOG% 2>&1

type %DIR_TMP%hdd.txt >> %HDDLOG% 2>&1
del /Q %DIR_TMP%hdd.txt
del /Q %DIR_TMP%hdd.bat

rem --- Информация о дисках
IF EXIST GetDeviceInfo.exe (
GetDeviceInfo.exe /disk /log /test >> %HDDLOG% 2>&1
) ELSE (
GetDiskInfo.exe C: >> %HDDLOG% 2>&1
GetDiskInfo.exe D: >> %HDDLOG% 2>&1
GetDiskInfo.exe E: >> %HDDLOG% 2>&1
)

echo. >> %HDDLOG% 2>&1
echo ---------------------------------------------------------- >> %HDDLOG% 2>&1
echo. >> %HDDLOG% 2>&1
echo Finished: %DATE% %TIME% >> %HDDLOG% 2>&1
echo Status: %STATUS% >> %HDDLOG% 2>&1

exit /B 0

goto :eof




:GetArrayInfo

  echo %1 -f %2 > %DIR_TMP%hdd.bat
  echo exit >> %DIR_TMP%hdd.bat
  
  start /wait %DIR_TMP%hdd.bat
  IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=HDD_INFO_ERROR
  echo Status: %STATUS%

  exit /B 0

goto :eof


:GetSmartInfo

  SET HDDTYPE=DISK_INFO
  SET HDDDIAGAPP=smartctl.exe

  echo. > %1
  echo smart info - disk C: >> %1
  %HDDDIAGAPP% -son C: >> %1
  %HDDDIAGAPP% -a C: >> %1
  IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=HDD_INFO_ERROR
  echo Status: %STATUS%

  echo. >> %1
  echo smart info - disk D: >> %1
  %HDDDIAGAPP% -son D: >> %1
  %HDDDIAGAPP% -a D: >> %1
  IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=HDD_INFO_ERROR
  echo Status: %STATUS%

  echo. >> %1
  echo smart info - disk E: >> %1
  %HDDDIAGAPP% -a E: >> %1

  echo. >> %1
  echo smart info - disk F: >> %1
  %HDDDIAGAPP% -a F: >> %1

  echo. >> %1
  echo smart info - disk G: >> %1
  %HDDDIAGAPP% -a G: >> %1

  echo. >> %1
  echo smart info - disk H: >> %1
  %HDDDIAGAPP% -a H: >> %1

  echo. >> %1
  echo smart info - disk I: >> %1
  %HDDDIAGAPP% -a I: >> %1

  exit /B 0

goto :eof




:GetApplLog
SET STATUS=OK

rem -- читаем файлы Alert.log
DEL /Q %ORALOGFILES1
FOR %%I IN (%DIR_BDUMP%%ORALOGFILES1%) DO CALL :ReadLastDay %%I %%~nI ALERT_LOG
DEL /Q %ORALOGFILES2
FOR %%I IN (%DIR_BDUMP%%ORALOGFILES2%) DO CALL :ReadLastDay %%I %%~nI ALERT_LOG

rem -- читаем файл C:\REPL\error.log
DEL /Q %REPLLOG%
FOR %%I IN (%DIR_REPL%%REPLLOG%) DO CALL :ReadLastDay %%I %%~nI REPL_LOG

rem -- читаем файл C:\REPL\rrr.log
DEL /Q %RRRLOG%
FOR %%I IN (%DIR_REPL%%RRRLOG%) DO CALL :ReadLastDay %%I %%~nI RRR_LOG

rem -- читаем файл C:\JOB\job.log
DEL /Q %JOBLOG%
FOR %%I IN (%DIR_JOB%%JOBLOG%) DO CALL :ReadLastDay %%I %%~nI JOB_LOG

exit /B 0

goto :eof



:ReadLastDay

SET rldLOG=%2.log
SET rldTYPE=%3

echo. > %rldLOG% 2>&1
echo Type: %rldTYPE% >> %rldLOG% 2>&1
echo File: %1 >> %rldLOG% 2>&1
echo Log: %CD%\%rldLOG% >> %rldLOG% 2>&1
echo Directory: %CD% >> %rldLOG% 2>&1
echo Computer: %COMPUTERNAME% >> %rldLOG% 2>&1
echo Version: %VERSION% >> %rldLOG% 2>&1
echo Started: %DATE% %TIME% >> %rldLOG% 2>&1
echo Username: %USERNAME% >> %rldLOG% 2>&1
echo. >> %rldLOG% 2>&1
echo ---------------------------------------------------------- >> %rldLOG% 2>&1
echo. >> %rldLOG% 2>&1

SET Line=0

For /F "usebackq" %%A In (`Type %1 ^| Find /V /C ""`) Do Set /A Line=%%A - 20000
IF %Line% LSS 0 SET Line=0
More +%Line% %1 > %DIR_TMP%rldLOGs.txt 

type %DIR_TMP%rldLOGs.txt >> %rldLOG% 2>&1
del /Q %DIR_TMP%rldLOGs.txt

echo. >> %rldLOG% 2>&1
echo ---------------------------------------------------------- >> %rldLOG% 2>&1
echo. >> %rldLOG% 2>&1
echo Finished: %DATE% %TIME% >> %rldLOG% 2>&1
echo Status: %STATUS% >> %rldLOG% 2>&1

goto :eof



