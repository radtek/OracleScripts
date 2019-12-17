@echo on
SET FILETYPE=UPDATE
SET LOG=Update.log
SET FILE=Update.bat
SET STATUS=OK
SET IS_SERVER=YES
SET SERVER_HOTCOPY=%DIR_HOTCOPY%
SET VERSION=1.7
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

if .%IS_SERVER%. EQU .NO. CALL :RunUpdateFromServer >> %LOG% 2>&1

mkdir %dir_hotcopy%update\
IF EXIST %dir_hotcopy%update\update.rar CALL :RunUpdate >> %LOG% 2>&1

echo. >> %LOG% 2>&1
echo ---------------------------------------------------------- >> %LOG% 2>&1
echo. >> %LOG% 2>&1
echo Finished: %DATE% %TIME% >> %LOG% 2>&1
echo Status: %STATUS% >> %LOG% 2>&1

rem --- Отправить логи в офис
"C:\Program Files\WinRAR\RAR.exe" a -ag -ri1 %DIR_AREMOTE_OUT%zz%FILETYPE%Log_NB_%ARGUS_SERVER%_%COMPUTERNAME%_.rar %LOG% %FILE% set_var.bat

goto :eof



:RunUpdateFromServer
echo set_var.bat > %DIR_TMP%exclude.txt
FOR %%I IN (%SERVER_HOTCOPY%update\update.rar) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%update\
FOR %%I IN (%SERVER_HOTCOPY%*.bat) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.cmd) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.sql) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.exe) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.vbs) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.txt) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.doc) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
FOR %%I IN (%SERVER_HOTCOPY%*.rtf) DO xcopy /F /R /Y /D /EXCLUDE:%DIR_TMP%exclude.txt %%I %DIR_HOTCOPY%
del /q %DIR_TMP%exclude.txt
goto :eof



:RunUpdate
set TT=%TIME%
set DD=%DATE%
SET STATUS=OK

mkdir %dir_hotcopy%update\arc_in
mkdir %dir_hotcopy%update\restore

rem ----------------------------------------------------------
echo Update started at %DD% %TT% > %DIR_TMP%update.is

rem -- Удаляем предыдущие обновления
del /Q %dir_hotcopy%update\update.ini
del /Q %dir_hotcopy%update\*.bat
del /Q %dir_hotcopy%update\*.cmd
del /Q %dir_hotcopy%update\*.sql
del /Q %dir_hotcopy%update\*.exe

rem -- Распаковываем обновления
"C:\Program Files\WinRAR\RAR.exe" e -y -ep %dir_hotcopy%update\update.rar %dir_hotcopy%update
IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=UPDATE_ERROR
echo Status: %STATUS%

rem -- Переносим файл обновления в архив
move /y %dir_hotcopy%update\update.rar %dir_hotcopy%update\arc_in\update%DD:~6,4%%DD:~3,2%%DD:~0,2%%TT:~0,2%%TT:~3,2%%TT:~6,2%.rar
IF  NOT %ERRORLEVEL% EQU 0 SET STATUS=UPDATE_ERROR
echo Status: %STATUS%

rem -- Обрабатываем обновление
IF EXIST %dir_hotcopy%update\update.ini CALL :RunUpdateCMD
IF EXIST %dir_hotcopy%update\update.ini CALL :CopyFILES

rem -- Удаляем временные файлы
DEL /Q %DIR_TMP%update.is
DEL /Q %DIR_TMP%delFILES.bat
DEL /Q %DIR_TMP%updateFILES.bat
DEL /Q %DIR_TMP%saveFILES.bat
DEL /Q %DIR_TMP%updateCMD.bat

goto :eof


:RunUpdateCMD
rem -- Обрабатываем секцию [CMD] файла update.ini
echo. > %dir_tmp%updateCMD.bat
SET IsCMD=0
For /F "tokens=*" %%i In (%dir_hotcopy%update\update.ini) Do CALL :GetLineCMD "%%i"

echo %ERRORLEVEL%
CALL %dir_tmp%updateCMD.bat

goto :eof



:GetLineCMD
IF %1 EQU "[FILES]" (SET IsCMD=2) ELSE (
  IF %1 EQU "[CMD]" (SET IsCMD=1) ELSE (CALL :PrintLineCMD %1)
)
goto :eof



:PrintLineCMD
IF %IsCMD% EQU 2 goto :eof
IF %IsCMD% EQU 0 goto :eof

rem -- добавляем команду
for /F "tokens=*" %%i IN (%1) do echo %%i >> %dir_tmp%updateCMD.bat

rem -- добавляем обработку ошибок
echo %1 | findstr /I "mkdir"
IF %ERRORLEVEL% EQU 0 (
  echo IF NOT %%ERRORLEVEL%% EQU 0 IF NOT %%ERRORLEVEL%% EQU 1 SET STATUS=UPDATE_ERROR >> %dir_tmp%updateCMD.bat
  echo echo Status: %%STATUS%% >> %dir_tmp%updateCMD.bat
) ELSE (
  echo IF NOT %%ERRORLEVEL%% EQU 0 SET STATUS=UPDATE_ERROR >> %dir_tmp%updateCMD.bat
  echo echo Status: %%STATUS%% >> %dir_tmp%updateCMD.bat
)

exit /B 0

goto :eof




:CopyFiles
rem -- Обрабатываем секцию [FILES] файла update.ini
echo. > %dir_tmp%saveFILES.bat
echo. > %dir_tmp%updateFILES.bat
echo. > %dir_tmp%delFILES.bat
SET IsFILES=0
For /F "tokens=*" %%i In (%dir_hotcopy%update\update.ini) Do CALL :GetLineFILES "%%i"

echo %ERRORLEVEL%
CALL %dir_tmp%saveFILES.bat

echo %ERRORLEVEL%
CALL %dir_tmp%updateFILES.bat

echo %ERRORLEVEL%
CALL %dir_tmp%delFILES.bat

goto :eof



:GetLineFILES
IF %1 EQU "[CMD]" (SET IsFILES=2) ELSE (
  IF %1 EQU "[FILES]" (SET IsFILES=1) ELSE (CALL :PrintLineFILES %1)
)
goto :eof



:PrintLineFILES
IF %IsFILES% EQU 2 goto :eof
IF %IsFILES% EQU 0 goto :eof

rem -- добавляем команду (сохранить изменяемый файл для возможного последующего восстановления)
for /F "delims=>=- tokens=1,2*" %%i IN (%1) do CALL :PrintCorrectLineFILES "xcopy /F /R /Y" %%i %%j %dir_hotcopy%update\restore\ %dir_tmp%saveFILES.bat
rem -- добавляем обработку ошибок
echo IF NOT %%ERRORLEVEL%% EQU 0 SET STATUS=UPDATE_ERROR >> %dir_tmp%saveFILES.bat
echo echo Status: %%STATUS%% >> %dir_tmp%saveFILES.bat

rem -- добавляем команду (скопировать новый файл)
for /F "delims=>=- tokens=1,2*" %%i IN (%1) do CALL :PrintCorrectLineFILES "xcopy /F /R /Y" %%i %dir_hotcopy%update\ %%j %dir_tmp%updateFILES.bat
rem -- добавляем обработку ошибок
echo IF NOT %%ERRORLEVEL%% EQU 0 SET STATUS=UPDATE_ERROR >> %dir_tmp%updateFILES.bat
echo echo Status: %%STATUS%% >> %dir_tmp%updateFILES.bat

rem -- добавляем команду (удалить новый файл из каталога %dir_hotcopy%update)
for /F "delims=>=- tokens=1,2*" %%i IN (%1) do echo del /Q %dir_hotcopy%update\%%i >> %dir_tmp%delFILES.bat
rem -- добавляем обработку ошибок
echo IF NOT %%ERRORLEVEL%% EQU 0 SET STATUS=UPDATE_ERROR >> %dir_tmp%delFILES.bat
echo echo Status: %%STATUS%% >> %dir_tmp%delFILES.bat

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
