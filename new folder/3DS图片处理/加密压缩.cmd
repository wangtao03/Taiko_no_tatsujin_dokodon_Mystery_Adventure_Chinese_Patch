@echo off
cd %~dp0

set "path=%~dp0"

:LOOP
if %1 == "" ( goto BREAK)
rem �ļ���
set "name=%~n1"
rem ��׺��
set "exname=%~x1"
rem �����ļ���
set "fname=%~nx1"


if exist "%path%bak\%fname%" (copy "%path%bak\%fname%" "%fname%") else (
echo %fname% >> Error.txt
shift
goto LOOP
)

"%path%tools\ctpktool" -ivfd "%fname%" %1
"%path%tools\lzx" -evb "%fname%"

shift
goto LOOP

:BREAK

pause