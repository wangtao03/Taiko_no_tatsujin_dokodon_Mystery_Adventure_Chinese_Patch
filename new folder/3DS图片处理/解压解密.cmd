@echo off

mkdir "%~dp0\bak"
mkdir ""%~dp0\unLZX"
set "path=%~dp0"
:LOOP

set "name=%~n1"
set "exname=%~x1"
set "fname=%~nx1"

copy %1 "%path%bak\%fname%"

rem 判断文件类型
if "%exname%" == ".txp" (goto UNLXZ) else (goto UNCTPK)

:UNLXZ
"%path%tools\lzx.exe" -d "%path%bak\%fname%"

:UNCTPK
"%path%tools\ctpktool.exe" -evfd "%path%bak\%fname%" "%path%unlzx\%fname%"


shift
if "%1" == "" ( goto BREAK)
goto LOOP

:BREAK
