@echo off
::配置 
set YSJ_Version=1.0
set Dir_Root=%~dp0Bin\
set Dir_Plugins=%Dir_Root%.Plugins\
set Dir_Work=
set Name_Tools=tool
set ActiveCodePage=65001
set Editor=notepad
set Explorer=explorer
set Terminal=cmd
::命令行参数 
set Arg_Help=-h
set Arg_Install=-i
set Arg_Plugins=-p
set Arg_EditScript=-e
set Arg_Where=??
set Arg_ToolInfo=???
::不要随意修改 
set Script_AutoRun=%~dp0AutoRun.cmd
set Dir_Share=%Dir_Root%.Share\

::处理命令行参数 
if "%AutoRun_Complete%" neq "True" (
    call :FirstRun
) else if "%~1" equ "%Arg_Help%" (
	call :Help
) else if "%~1" equ "%Arg_Install%" (
	call :Install
) else if "%~1" equ "%Arg_Plugins%" (
	call :Plugins %*
) else if "%~1" equ "%Arg_Where%" (
	call %Explorer% %~dp0
) else if "%~1" equ "%Arg_EditScript%" (
	call %Editor% %~f0
) else (
	echo 未知操作！请输入 %~n0 %Arg_Help% 查看帮助 
)
exit /b

::Functions
:FirstRun
::首次运行 
if not exist "%Dir_Root%" mkdir "%Dir_Root%"
if not exist %Script_AutoRun% call :Install
call %Script_AutoRun%
if "%Dir_Work%" neq "" cd /d %Dir_Work%
if "%Terminal%" neq "" call %Terminal%
exit

:Help
::帮助信息 
echo YSJ_CLI v%YSJ_Version%
echo Usage: %~n0 [Options] [Arguments]
echo Options:
echo %Arg_Help% 显示帮助信息 
echo %Arg_Install% 安装工具、设置环境变量 
echo %Arg_EditScript% 编辑脚本 
echo %Arg_Plugins% [Arguments] 使用插件 
exit /b

:Install
::安装工具/设置环境变量 
rd /s /q %Dir_Share%
mkdir "%Dir_Share%"
if "%Path_Backup%" neq "" set "path=%Path_Backup%"
echo Installing...
(
	echo @echo off
	echo chcp %ActiveCodePage% ^> nul
	echo set "Path_Backup=%%path%%"
	echo set "path=%%~dp0;%%path%%"
	echo set "path=%%Dir_Share%%;%%path%%"
) > %Script_AutoRun%
setlocal enabledelayedexpansion
    for %%v in (File_Count Tool_Count ENV_Count Success_Count Error_Count) do set /a %%v=0
    ::遍历根目录，寻找安装配置文件 
    for /f "delims=" %%f in ('dir /s /b "%Dir_Root%*.%Name_Tools%"') do (
        set "File_Path=%%~dpf"
        set "File_Name=%%~nf"
        set /a File_Count+=1
        ::读取文件 
        set /a count=0
        for /l %%v in (1,1,3) do set line%%v=
        for /f "tokens=*" %%m in (%%f) do (
            set /a count+=1
            if !count! leq 3 set "line!count!=%%m"
        )
        ::获取到根目录的相对路径 
        for /l %%i in (0,1,50) do (
            if not "!Dir_Root:~%%i,1!"=="" (
                set File_Path=!File_Path:~1!
            )
        )
        ::修正第一行的特殊参数 
        set NotTools=
        if "!line1!" equ "addpath" (
            echo set "path=%%~dp0Bin\!File_Path!;%%path%%" >> !Script_AutoRun!
            set NotTools=True
        ) else if "!line1!" equ "dironly" (
            echo set "!line2!=%%~dp0Bin\!File_Path!" >> !Script_AutoRun!
            set NotTools=True
        ) else if "!line1!" equ "stronly" (
			echo set "!line2!=!line3!" >> !Script_AutoRun!
			set NotTools=True
        ) else if "!line1!" equ "setfull" (
			echo set "!line2!=%%~dp0Bin\!File_Path!!line3!" >> !Script_AutoRun!
			set NotTools=True
        ) else if "!line1!" equ "start /d" (
            set "line1=start /d %%~dp0..\!File_Path!"
        )
        ::启动脚本创建 
        if "!NotTools!" neq "True" (
            for /f "tokens=1" %%a in ("!line2!") do set "Exe_Check=%%a"
            if exist %Dir_Share%!File_Name!.cmd (
				::检查同名脚本是否已经创建 
                set /a Error_Count+=1
                echo Error: #!File_Count! [%%f] 同名脚本已创建 
            ) else if not exist %Dir_Root%!File_Path!!Exe_Check! (
				::检查目标文件是否存在 
                set /a Error_Count+=1
                echo Error: #!File_Count! [%%f] 目标文件不存在 
            ) else (
                ::格式化文件名（用于生成帮助信息） 
                set "Formated_Name=!File_Name!          "
                set "Formated_Name=!Formated_Name:~0,10!"
                ::创建脚本 
                set "Inside_Script=@if "%%~1" equ "%Arg_Where%" (call %Explorer% %%~dp0..\!File_Path!) else if "%%~1" equ "%Arg_ToolInfo%" (echo !Formated_Name!^^| !line3! ) else (!line1! %%~dp0..\!File_Path!!line2! %%*)"
                echo !Inside_Script! > %Dir_Share%!File_Name!.cmd
                set /a Success_Count+=1
                set /a Tool_Count+=1
            )
        ) else (
			set /a ENV_Count+=1
			set /a Success_Count+=1
        )
    )
    echo set "AutoRun_Complete=True" >> !Script_AutoRun!
    echo Install Completed
    echo Find: !File_Count! Success: !Success_Count! Error: !Error_Count!
    echo Tool: !Tool_Count! ENV: !ENV_Count!
endlocal
call %Script_AutoRun%
exit /b

:Plugins
::遍历插件文件夹 
for %%i in ("%Dir_Plugins%*.cmd") do (
	if "%~2" neq "" (
		call %%i %*
	) else (
		call %%i %Arg_Plugins% %Arg_Help%
	)
)
exit /b