@echo off
cd "%~dp0"

:LOOP
if %1 == "" ( goto BREAK)
rem �ļ���
set "name=%~n1"
rem ��׺��
set "exname=.txp"
rem �����ļ���
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
