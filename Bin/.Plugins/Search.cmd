@echo off

::Entry Point
set Arg=f
if "%~1" neq "-p" exit /b
if "%~2" equ "%Arg_Help%" (
	echo. & echo [Search Tools] v1.0
	echo Usage:
	echo %Arg_Plugins% %Arg% [Tool Name]
)
if "%~2" neq "%Arg%" exit /b
if "%~3" equ "%Arg_EditScript%" (
    call %Editor% %~f0
    exit /b
)
set Arg=

::Main
setlocal enabledelayedexpansion
::Print Header
echo Command   ^| Explanation
::Print Tools
for %%i in ("%Dir_Share%*%~3*.cmd") do (
	call %%i %Arg_ToolInfo%
)
endlocal
exit /b