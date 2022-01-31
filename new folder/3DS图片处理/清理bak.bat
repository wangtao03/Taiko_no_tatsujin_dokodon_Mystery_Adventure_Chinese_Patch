@echo off & setlocal EnableDelayedExpansion

for /f "delims=" %%i in ('"dir /a/s/b/on bak\*.txp"') do (

set file=%%~nxi

if not exist "unLZX\!file!" ( del bak\!file!)

)
