@echo off
setlIPl

set IP_STEPS=4
set IP_PSE=
set IP_ARCH=/x32
set IP_UNICODE=

:loopy
if "%1" == "/x64" goto set_x64
if "%1" == "/unicode" goto set_unicode
if "%1" == "/run" goto set_run
if "%1" == "/pause" goto set_pause
if "%1" == "/?" goto show_help
:shifty
shift
if "%1" == "" goto entry
goto loopy

:set_x64
set IP_ARCH=/x64
goto shifty

:set_unicode
set IP_UNICODE=/d UNICODE=1
goto shifty

:set_run
set IP_STEPS=5
goto shifty

:set_pause
set IP_PSE=pause
goto shifty

:show_help
echo.
echo This program will build the InPass proggie, resulting in the
echo "Out\InPass.exe" file. You will need to have GoAsm, GoLink and GoRC,
echo the GoTools by Jeremy Gordon in your path (http://www.godevtool.com/)
echo.
echo Switches are as follows:
echo (*) /x32     - builds a 32-bit (x86) variant of the program (default)
echo     /x64     - builds a 64 bit (AMD64) variant of the program
echo (*) /ansi    - builds a ANSI variant of the program (default)
echo     /unicode - builds a UNICODE version of the program
echo     /run     - executes the program after building it
echo     /pause   - pauses after the build/run steps
echo.

goto :EOF

:entry

echo.
echo Building InPass (/? for help):
echo.

if exist "Out" goto out_exists
mkdir Out

:out_exists
cd Out
echo Step #(1/%IP_STEPS%) CLEANUP
if exist "InPass.bin" del "InPass.bin"
if exist "InPass.bin" goto errcln
if exist "InPass.res" del "InPass.res"
if exist "InPass.res" goto errcln
if exist "InPass.obj" del "InPass.obj"
if exist "InPass.obj" goto errcln
if exist "InPass.exe" del "InPass.exe"
if exist "InPass.exe" goto errcln

cd ..\Src
echo Step #(2/%IP_STEPS%) RESOURCES
"GoRC.exe" /b /ni /r /fo "..\Out\InPass.res" "InPass.rc"
if errorlevel 1 goto errres

cd ..\Src
echo Step #(3/%IP_STEPS%) ASSEMBLY
"GoAsm.exe" /b /ni %IP_ARCH% %IP_UNICODE% /fo "..\Out\InPass.obj" "InPass.asm"
if errorlevel 1 goto errasm

cd ..\Out
echo Step #(4/%IP_STEPS%) LINKER
"GoLink.exe" /ni /fo "InPass.exe" /entry InPass_Entry "InPass.obj" "InPass.res" user32.dll kernel32.dll shell32.dll
if errorlevel 1 goto errlink

if "%IP_STEPS%" == "4" goto Bye

cd ..\Out
echo Step #(5/%IP_STEPS%) EXECUTION
start InPass Arg1 "Arg 2"
echo.
echo Contents of the arguments file:
echo.
type InPass.exe-Arguments.txt
goto Bye

:errcln
echo.
echo CLEANUP Error!
goto Bye

:errres
echo.
echo RESOURCES Error!
goto Bye

:errasm
echo.
echo ASSEMBLY Error!
goto Bye

:errlink
echo.
echo LINKER Error!
goto Bye

:Bye
cd ..
echo.
%IP_PSE%
