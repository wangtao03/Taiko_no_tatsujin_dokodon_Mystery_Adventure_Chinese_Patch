@ECHO OFF
SET BatPath = %~dp0

:InputPath
SET /p DataPath="请输入本体 _data 的路径: "
IF not exist "%DataPath%" (
	ECHO 所输入的路径不存在!
	GOTO InputPath
	)

:TitleMenu
cls
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO -          1.复制解压并提取 游戏模式 的 .txp
ECHO -          2.复制解压并提取 故事模式 的 .txp
ECHO -          3.打包压缩并覆盖 游戏模式 的 .txp
ECHO -          4.打包压缩并覆盖 故事模式 的 .txp
ECHO -          5.复制解压并提取 UPDATA 的 .txp
ECHO -          6.打包压缩并覆盖 UPDATA 的 .txp
ECHO -          7.复制解压并提取 DLC 的 .txp
ECHO -          8.打包压缩并覆盖 DLC 的 .txp
ECHO -          9.复制解压并提取 自定 的 .txp
ECHO -          0.打包压缩并覆盖 自定 的 .txp
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.

SET /p Menu="请输入要执行的功能: "
IF /i "%Menu%"=="1" GOTO SelectKey1
IF /i "%Menu%"=="2" GOTO SelectKey2
IF /i "%Menu%"=="3" GOTO SelectKey3
IF /i "%Menu%"=="4" GOTO SelectKey4
IF /i "%Menu%"=="5" GOTO SelectKey5
IF /i "%Menu%"=="6" GOTO SelectKey6
IF /i "%Menu%"=="7" GOTO SelectKey7
IF /i "%Menu%"=="8" GOTO SelectKey8
IF /i "%Menu%"=="9" GOTO SelectKey9
IF /i "%Menu%"=="0" GOTO SelectKey0

:SelectKey1
SET Key=game
GOTO CopyAndUnpack

:SelectKey2
SET Key=story
GOTO CopyAndUnpack

:SelectKey3
SET Key=game
GOTO RePackAndOverwrite

:SelectKey4
SET Key=story
GOTO RePackAndOverwrite

:SelectKey5
SET Key=updata
GOTO CopyAndUnpack

:SelectKey6
SET Key=updata
GOTO RePackAndOverwrite

:SelectKey7
SET Key=dlc
GOTO CopyAndUnpack

:SelectKey8
SET Key=dlc
GOTO RePackAndOverwrite

:SelectKey9
SET Key=temp
GOTO CopyAndUnpack

:SelectKey0
SET Key=temp
GOTO RePackAndOverwrite
rem ==========================================================================

:CopyAndUnpack
IF not exist "%BatPath%bak\%Key%" (
	md "%BatPath%bak\%Key%"
)
IF not exist "%BatPath%unLZX\%Key%" (
	md "%BatPath%unLZX\%Key%"
)

FOR /f  %%i IN (%Key%.txt) DO (
	IF exist "%DataPath%%%i" (
		COPY "%DataPath%%%i" "%BatPath%bak\%Key%\%%~ni%%~xi" >nul
		"%BatPath%tools\lzx.exe" -d "%BatPath%bak\%Key%\%%~ni%%~xi" >nul
		ECHO "正在处理文件: %%~ni%%~xi"
		"%BatPath%tools\ctpktool.exe" -evfd "%BatPath%bak\%Key%\%%~ni%%~xi" "%BatPath%unLZX\%Key%\%%~ni%%~xi"
	)
)
echo "全部文件已处理完成!!"
PAUSE
GOTO TitleMenu

rem ==========================================================================

:RePackAndOverwrite
IF not exist "%BatPath%bak\%Key%" (
	ECHO "未找到备份文件夹,操作结束!""
	PAUSE
	GOTO TitleMenu
)
IF not exist "%BatPath%unLZX\%Key%" (
	ECHO "未找到解压文件夹,操作结束!"
	PAUSE
	GOTO TitleMenu
)

FOR /f  %%i IN (%Key%.txt) DO (
	IF NOT exist "%BatPath%bak\%Key%\%%~ni%%~xi" (
		copy "%DataPath%%%~i" "%BatPath%bak\%Key%\%%~ni%%~xi"
	)
	IF exist "%BatPath%unLZX\%Key%\%%~ni%%~xi" (
	COPY "%BatPath%bak\%Key%\%%~ni%%~xi" "%BatPath%%%~ni%%~xi" >nul
	ECHO "正在处理文件: %%~ni%%~xi"
	"%BatPath%tools\ctpktool.exe" -ivfd  "%BatPath%%%~ni%%~xi" "%BatPath%unLZX\%Key%\%%~ni%%~xi"
	"%BatPath%tools\lzx.exe" -evb "%BatPath%%%~ni%%~xi" >nul
	IF not exist "%DataPath%%%~pi" ( mkdir "%DataPath%%%~pi" )
	MOVE /Y "%BatPath%%%~ni%%~xi" "%DataPath%%%i" >nul
	)
)
echo "全部文件已处理完成!!"
PAUSE
GOTO TitleMenu