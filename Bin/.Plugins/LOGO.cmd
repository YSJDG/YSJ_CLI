@echo off

::Entry Point
set Arg=l
if "%~1" neq "-p" exit /b
if "%~2" equ "%Arg_Help%" (
	echo. & echo [Show LOGO] v1.0
	echo Usage:
	echo %Arg_Plugins% %Arg%
)
if "%~2" neq "%Arg%" exit /b
if "%~3" equ "%Arg_EditScript%" (
    call %Editor% %~f0
    exit /b
)
set Arg=

::Main
echo.
echo  ██╗   ██╗███████╗     ██╗         ██████╗██╗     ██╗ 
echo  ╚██╗ ██╔╝██╔════╝     ██║        ██╔════╝██║     ██║ 
echo   ╚████╔╝ ███████╗     ██║        ██║     ██║     ██║ 
echo    ╚██╔╝  ╚════██║██   ██║        ██║     ██║     ██║ 
echo     ██║   ███████║╚█████╔╝███████╗╚██████╗███████╗██║ 
echo     ╚═╝   ╚══════╝ ╚════╝ ╚══════╝ ╚═════╝╚══════╝╚═╝ 