@ECHO OFF
SET BatPath = %~dp0

:InputPath
SET /p DataPath="�����뱾�� _data ��·��: "
IF not exist "%DataPath%" (
	ECHO �������·��������!
	GOTO InputPath
	)

:TitleMenu
cls
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO -          1.���ƽ�ѹ����ȡ ��Ϸģʽ �� .txp
ECHO -          2.���ƽ�ѹ����ȡ ����ģʽ �� .txp
ECHO -          3.���ѹ�������� ��Ϸģʽ �� .txp
ECHO -          4.���ѹ�������� ����ģʽ �� .txp
ECHO -          5.���ƽ�ѹ����ȡ UPDATA �� .txp
ECHO -          6.���ѹ�������� UPDATA �� .txp
ECHO -          7.���ƽ�ѹ����ȡ DLC �� .txp
ECHO -          8.���ѹ�������� DLC �� .txp
ECHO -          9.���ƽ�ѹ����ȡ �Զ� �� .txp
ECHO -          0.���ѹ�������� �Զ� �� .txp
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.

SET /p Menu="������Ҫִ�еĹ���: "
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
		ECHO "���ڴ����ļ�: %%~ni%%~xi"
		"%BatPath%tools\ctpktool.exe" -evfd "%BatPath%bak\%Key%\%%~ni%%~xi" "%BatPath%unLZX\%Key%\%%~ni%%~xi"
	)
)
echo "ȫ���ļ��Ѵ������!!"
PAUSE
GOTO TitleMenu

rem ==========================================================================

:RePackAndOverwrite
IF not exist "%BatPath%bak\%Key%" (
	ECHO "δ�ҵ������ļ���,��������!""
	PAUSE
	GOTO TitleMenu
)
IF not exist "%BatPath%unLZX\%Key%" (
	ECHO "δ�ҵ���ѹ�ļ���,��������!"
	PAUSE
	GOTO TitleMenu
)

FOR /f  %%i IN (%Key%.txt) DO (
	IF NOT exist "%BatPath%bak\%Key%\%%~ni%%~xi" (
		copy "%DataPath%%%~i" "%BatPath%bak\%Key%\%%~ni%%~xi"
	)
	IF exist "%BatPath%unLZX\%Key%\%%~ni%%~xi" (
	COPY "%BatPath%bak\%Key%\%%~ni%%~xi" "%BatPath%%%~ni%%~xi" >nul
	ECHO "���ڴ����ļ�: %%~ni%%~xi"
	"%BatPath%tools\ctpktool.exe" -ivfd  "%BatPath%%%~ni%%~xi" "%BatPath%unLZX\%Key%\%%~ni%%~xi"
	"%BatPath%tools\lzx.exe" -evb "%BatPath%%%~ni%%~xi" >nul
	IF not exist "%DataPath%%%~pi" ( mkdir "%DataPath%%%~pi" )
	MOVE /Y "%BatPath%%%~ni%%~xi" "%DataPath%%%i" >nul
	)
)
echo "ȫ���ļ��Ѵ������!!"
PAUSE
GOTO TitleMenu