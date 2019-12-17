@echo off



REM -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- НАСТРОЙКИ

REM Какую базу брать
set oracle_sid=p8440apr

REM Откуда
set db_bu_path_from=d:\databases\p8440apr

REM Куда
set db_bu_path_to=f:\databases\p8440apr



REM -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- КОД

REM Проверка
if not exist %db_bu_path_from% (
  echo Can't find source - %db_bu_path_from%
  goto ERROR
 )

if not exist %db_bu_path_to% (
  echo Can't find destination - %db_bu_path_to%! Will be created now!
  mkdir %db_bu_path_to%
 )

REM Останов базы
svrmgrl @shutdown.sql

REM Копирование
copy %db_bu_path_from%\*.* %db_bu_path_to%\*

REM Старт базы
svrmgrl @startup.sql

goto GOOD

:GOOD
 echo BackUp complete sucsessfully!
 goto END

:ERROR
 echo BackUp do not complete!
 goto END

:END
 pause