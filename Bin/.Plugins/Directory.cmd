@echo off

::Entry Point
set Arg=d
if "%~1" neq "-p" exit /b
if "%~2" equ "%Arg_Help%" (
	echo. & echo [Change Directory] v1.0
	echo Usage:
	echo %Arg_Plugins% %Arg% [Options]
	echo Options:
	echo [1] %Dir_Work%
	echo [2] %Dir_Root%
	echo [3] %Dir_Share%
	echo [4] %UserProfile%
	echo [5] C:\Users\%UserName%\
)
if "%~2" neq "%Arg%" exit /b
if "%~3" equ "%Arg_EditScript%" (
    call %Editor% %~f0
    exit /b
)
set Arg=

::Main
if "%~3" equ "" (
	echo [1] %Dir_Work%
	echo [2] %Dir_Root%
	echo [3] %Dir_Share%
	echo [4] %UserProfile%
	echo [5] C:\Users\%UserName%\
	set /p Input=Enter a directory code: 
) else (
	set "Input=%~3"
)
if "%Input%" equ "1" cd /d %Dir_Work%
if "%Input%" equ "2" cd /d %Dir_Root%
if "%Input%" equ "3" cd /d %Dir_Share%
if "%Input%" equ "4" cd /d %UserProfile%
if "%Input%" equ "5" cd /d C:\Users\%UserName%\
set Input=