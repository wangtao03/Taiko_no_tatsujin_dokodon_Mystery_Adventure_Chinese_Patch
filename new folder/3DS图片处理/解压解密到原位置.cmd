@echo off

set "path=%~dp0"

rem mkdir "bak"
rem mkdir "unLZX"

:LOOP
rem 文件名
set "name=%~n1"
rem 后缀名
set "exname=%~x1"
rem 完整文件名
set "fname=%~nx1"

rem 复制文件到备份目录
rem copy "%1" "bak\%fname%"

rem 判断文件类型
if "%exname%" == ".txp" (goto UNLXZ) else (goto UNCTPK)

:UNLXZ
"%path%tools\lzx" -d %1

:UNCTPK
"%path%tools\ctpktool" -evfd %1 %1.out

shift
if "%1" == "" ( goto BREAK)
goto LOOP

:BREAK