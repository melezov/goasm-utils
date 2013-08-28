@echo off
setlocal

set BK_BLD=RELEASE
set BK_STP=6
set BK_PSE=pause

:loopy
if "%1" == "/d" goto setbld
if "%1" == "/e" goto setstp
if "%1" == "/n" goto setpse
:shifty
shift
if "%1" == "" goto entry
goto loopy

:setbld
set BK_BLD=DEBUG
goto shifty

:setstp
set BK_STP=7
goto shifty

:setpse
set BK_PSE=
goto shifty

:entry

echo.
echo Building BroodQwe (%BK_BLD%):
echo.

if not exist "Out" mkdir Out

cd Out
echo Step #(1/%BK_STP%) CLEANUP
if exist "BroodQwe.bin" del "BroodQwe.bin"
if exist "BroodQwe.bin" goto errcln
if exist "BroodQwe.res" del "BroodQwe.res"
if exist "BroodQwe.res" goto errcln
if exist "BroodQwe.obj" del "BroodQwe.obj"
if exist "BroodQwe.obj" goto errcln
if exist "BroodQwe.exe" del "BroodQwe.exe"
if exist "BroodQwe.exe" goto errcln

cd ..\Str
echo Step #(2/%BK_STP%) STR BINARIES
call "Str.bat" /n
if errorlevel 1 goto errstr
"Str.exe"
if errorlevel 1 goto errstr

cd ..\Res
echo Step #(3/%BK_STP%) RESOURCES
"GoRC.exe" /b /ni /r /fo "..\Out\BroodQwe.res" "BroodQwe.rc"
if errorlevel 1 goto errres

cd ..\Src
echo Step #(4/%BK_STP%) ASSEMBLY
"GoAsm.exe" /b /ni /d %BK_BLD%=1 /fo "..\Out\BroodQwe.obj" "BroodQwe.asm"
if errorlevel 1 goto errasm

cd ..\Out
echo Step #(5/%BK_STP%) LINKER
"GoLink.exe" /ni /fo "BroodQwe.exe" /entry BroodQwe_Entry "BroodQwe.obj" "BroodQwe.res" user32.dll kernel32.dll shell32.dll
if errorlevel 1 goto errlink

cd ..\Rwe
echo Step #(6/%BK_STP%) RWE SECTION FIX
call "Rwe.bat" /n
if errorlevel 1 goto errrwe
"Rwe.exe"
if errorlevel 1 goto errrwe

if "%BK_STP%" == "6" goto Bye
cd ..\Out
echo Step #(7/%BK_STP%) EXECUTING BroodQwe
start BroodQwe
goto Bye

:errcln
echo.
echo CLEANUP Error!
goto Bye

:errstr
echo.
echo STR BINARIES Error!
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

:errrwe
echo.
echo RWE SECTION FIX Error!
goto Bye

:Bye
cd ..
echo.
%BK_PSE%
