@echo off
cd "%~dp0"

:LOOP
if %1 == "" ( goto BREAK)
rem 文件名
set "name=%~n1"
rem 后缀名
set "exname=.txp"
rem 完整文件名
set "fname=%~dp1%name%"


if exist "%fname%" (
"%~dp0tools\ctpktool" -ivfd "%fname%" %1
"%~dp0tools\lzx" -evb "%fname%"
) else (
echo %fname% >> Error.txt
)

shift
goto LOOP

:BREAK
