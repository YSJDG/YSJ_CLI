@echo off

::Entry Point
set Arg=s
if "%~1" neq "-p" exit /b
if "%~2" equ "%Arg_Help%" (
	echo. & echo [System Tools] v1.0
	echo Usage:
	echo %Arg_Plugins% %Arg% [Options]
	echo Options:
	echo [1] Edit environment variables
	echo [2] Control Panel
	echo [3] Regedit
	echo [4] Recyclebin folder
	echo [5] Startup folder
	echo [6] Start Menu folder
)
if "%~2" neq "%Arg%" exit /b
if "%~3" equ "%Arg_EditScript%" (
    call %Editor% %~f0
    exit /b
)
set Arg=

::Main
if "%~3" equ "" (
	echo.
	echo [1] Edit environment variables
	echo [2] Control Panel
	echo [3] Regedit
	echo [4] Recyclebin folder
	echo [5] Startup folder
	echo [6] Start Menu folder
	set /p Input=Enter a operate code: 
) else (
	set "Input=%~3"
)
if "%Input%" equ "1" start /i rundll32 sysdm.cpl,EditEnvironmentVariables
if "%Input%" equ "2" start /i control
if "%Input%" equ "3" start /i regedit
if "%Input%" equ "4" start /i %Explorer% "shell:recyclebinfolder"
if "%Input%" equ "5" start /i %Explorer% "shell:startup"
if "%Input%" equ "6" start /i %Explorer% "shell:Start Menu"
set Input=