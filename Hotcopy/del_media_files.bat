@rem Удаляем медиа файлы...

@set host=%COMPUTERNAME%

@echo %host% >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
@echo
@echo start %date% %time% >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
@echo
@echo Удаляем медиа файлы с диска C:\ >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

del c:\*.wma  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.mp3  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.mp4  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.mpg  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.mpeg /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.mkv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.avi  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.3gp  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.vob  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.wmv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.flv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del c:\*.m2ts  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

@echo Удаляем медиа файлы с диска D:\ >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

del d:\*.wma  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.mp3  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.mp4  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.mpg  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.mpeg /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.mkv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.avi  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.3gp  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.vob  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.wmv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.flv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del d:\*.m2ts  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

@rem Проверка USB диска 
@if exist E:\HotCopy\backup\*.* (goto noskip_usb) else (goto skip_usb)

:noskip_usb
@echo Удаляем медиа файлы с диска E:\ >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

del e:\*.wma  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.mp3  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.mp4  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.mpg  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.mpeg /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.mkv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.avi  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.3gp  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.vob  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.wmv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.flv  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log
del e:\*.m2ts  /q /f /s >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

:skip_usb

@echo finish %date% %time% >> c:\hotcopy\delmediafiles_KMINB1_%host%.log

move /y c:\hotcopy\delmediafiles*.log c:\aremote\nb\out\