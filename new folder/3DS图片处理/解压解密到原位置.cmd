@echo off

set "path=%~dp0"

rem mkdir "bak"
rem mkdir "unLZX"

:LOOP
rem �ļ���
set "name=%~n1"
rem ��׺��
set "exname=%~x1"
rem �����ļ���
set "fname=%~nx1"

rem �����ļ�������Ŀ¼
rem copy "%1" "bak\%fname%"

rem �ж��ļ�����
if "%exname%" == ".txp" (goto UNLXZ) else (goto UNCTPK)

:UNLXZ
"%path%tools\lzx" -d %1

:UNCTPK
"%path%tools\ctpktool" -evfd %1 %1.out

shift
if "%1" == "" ( goto BREAK)
goto LOOP

:BREAK