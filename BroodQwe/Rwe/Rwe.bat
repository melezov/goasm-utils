@echo off
setlocal

set RWE_PSE=pause

:loopy
if "%1" == "/n" goto setpse
:shifty
shift
if "%1" == "" goto entry
goto loopy

:setpse
set RWE_PSE=
goto shifty

:entry

echo.
echo Building RWE:
echo.

if exist Rwe cd Rwe

echo Step #(1/3) CLEANUP
if exist "Rwe.obj" del "Rwe.obj"
if exist "Rwe.obj" goto errcln
if exist "Rwe.exe" del "Rwe.exe"
if exist "Rwe.exe" goto errcln

echo Step #(2/3) ASSEMBLY
"GoAsm.exe" /b /ni /fo "Rwe.obj" "Rwe.asm"
if errorlevel 1 goto errasm

echo Step #(3/3) LINKER
"GoLink.exe" /ni /entry RWE_Entry /fo "Rwe.exe" "Rwe.obj" user32.dll kernel32.dll
if errorlevel 1 goto errlink

goto Bye

:errcln
echo.
echo CLEANUP Error!
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
echo.
%RWE_PSE%
