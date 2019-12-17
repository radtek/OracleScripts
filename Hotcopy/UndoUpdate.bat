@echo on
SET FILETYPE=UNDO_UPDATE
SET LOG=UndoUpdate.log
SET FILE=UndoUpdate.bat
SET STATUS=OK
SET VERSION=1.6
SET ARGUS_SERVER=%COMPUTERNAME%

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

IF EXIST %dir_tmp%update.is (SET STATUS=UPDATE_RUNNING) ELSE (
  IF NOT EXIST %dir_hotcopy%update\update.ini (SET STATUS=UNDO_NOTHING) ELSE (
    CALL :RunUndoUpdate 
  )
) >> %LOG% 2>&1

echo. >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1
echo Finished: %DATE% %TIME% >> %LOG% 2>&1
echo Status: %STATUS% >> %LOG% 2>&1


rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 -inul %DIR_AREMOTE_OUT%zz%FILETYPE%Log_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat

goto :eof



:RunUndoUpdate
set TT=%TIME%
set DD=%DATE%

mkdir %dir_hotcopy%update\restore

rem -- Восстанавливаем файлы
IF EXIST %dir_hotcopy%update\update.ini CALL :UndoFILES

rem -- Удаляем временные файлы
DEL /Q %DIR_TMP%restoreFILES.bat

goto :eof


:UndoFILES
rem -- Обрабатываем секцию [FILES] файла update.ini
echo. > %dir_tmp%restoreFILES.bat
SET IsFILES=0
For /F "tokens=*" %%i In (%dir_hotcopy%update\update.ini) Do CALL :GetLineFILES "%%i"

echo %ERRORLEVEL%
CALL %dir_tmp%restoreFILES.bat

goto :eof



:GetLineFILES
IF %1 EQU "[CMD]" (SET IsFILES=2) ELSE (
  IF %1 EQU "[FILES]" (SET IsFILES=1) ELSE (CALL :PrintLineFILES %1)
)
goto :eof



:PrintLineFILES
IF %IsFILES% EQU 2 goto :eof
IF %IsFILES% EQU 0 goto :eof

rem -- добавляем команду (восстановить файл)
for /F "delims=>=- tokens=1,2*" %%i IN (%1) do CALL :PrintCorrectLineFILES "xcopy /F /R /Y" %%i %dir_hotcopy%update\restore\ %%j %dir_tmp%restoreFILES.bat
rem -- добавляем обработку ошибок
echo IF NOT %%ERRORLEVEL%% EQU 0 SET STATUS=UNDO_ERROR >> %dir_tmp%restoreFILES.bat
echo echo Status: %%STATUS%% >> %dir_tmp%restoreFILES.bat

exit /B 0

goto :eof



:PrintCorrectLineFILES
echo %3|findstr /E "\\"
if %ERRORLEVEL% EQU 0 (SET DIR_FROM=%3) ELSE SET DIR_FROM=%3\

echo %4|findstr /E "\\"
if %ERRORLEVEL% EQU 0 (SET DIR_TO=%4) ELSE SET DIR_TO=%4\

for /F "tokens=*" %%i IN (%1) do echo if exist %DIR_FROM%%2 %%i %DIR_FROM%%2 %DIR_TO% >> %5

exit /B 0

goto :eof