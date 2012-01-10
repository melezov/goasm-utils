@echo off
setlocal

set OCA_STEPS=4
set OCA_PSE=
set OCA_ARCH=/x32
set OCA_UNICODE=

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
set OCA_ARCH=/x64
goto shifty

:set_unicode
set OCA_UNICODE=/d UNICODE=1
goto shifty

:set_run
set OCA_STEPS=5
goto shifty

:set_pause
set OCA_PSE=pause
goto shifty

:show_help
echo.
echo This program will build the OutCmdArg proggie, resulting in the
echo "Out\OutCmdArg.exe" file. You will need to have GoAsm, GoLink and GoRC,
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
echo Building OutCmdArg (/? for help):
echo.

if exist "Out" goto out_exists
mkdir Out

:out_exists
cd Out
echo Step #(1/%OCA_STEPS%) CLEANUP
if exist "OutCmdArg.bin" del "OutCmdArg.bin"
if exist "OutCmdArg.bin" goto errcln
if exist "OutCmdArg.res" del "OutCmdArg.res"
if exist "OutCmdArg.res" goto errcln
if exist "OutCmdArg.obj" del "OutCmdArg.obj"
if exist "OutCmdArg.obj" goto errcln
if exist "OutCmdArg.exe" del "OutCmdArg.exe"
if exist "OutCmdArg.exe" goto errcln

cd ..\Src
echo Step #(2/%OCA_STEPS%) RESOURCES
"GoRC.exe" /b /ni /r /fo "..\Out\OutCmdArg.res" "OutCmdArg.rc"
if errorlevel 1 goto errres

cd ..\Src
echo Step #(3/%OCA_STEPS%) ASSEMBLY
"GoAsm.exe" /b /ni %OCA_ARCH% %OCA_UNICODE% /fo "..\Out\OutCmdArg.obj" "OutCmdArg.asm"
if errorlevel 1 goto errasm

cd ..\Out
echo Step #(4/%OCA_STEPS%) LINKER
"GoLink.exe" /ni /fo "OutCmdArg.exe" /entry OutCmdArg_Entry "OutCmdArg.obj" "OutCmdArg.res" user32.dll kernel32.dll shell32.dll
if errorlevel 1 goto errlink

if "%OCA_STEPS%" == "4" goto Bye

cd ..\Out
echo Step #(5/%OCA_STEPS%) EXECUTION
start OutCmdArg Arg1 "Arg 2"
echo.
echo Contents of the arguments file:
echo.
type OutCmdArg.exe-Arguments.txt
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
%OCA_PSE%