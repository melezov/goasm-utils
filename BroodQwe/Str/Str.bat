@echo off
setlocal

set STR_PSE=pause

:loopy
if "%1" == "/n" goto setpse
:shifty
shift
if "%1" == "" goto entry
goto loopy

:setpse
set STR_PSE=
goto shifty

:entry

echo.
echo Building STR:
echo.

if exist Str cd Str

echo Step #(1/3) CLEANUP
if exist "Str.obj" del "Str.obj"
if exist "Str.obj" goto errcln
if exist "Str.exe" del "Str.exe"
if exist "Str.exe" goto errcln

echo Step #(2/3) ASSEMBLY
"GoAsm.exe" /b /ni /fo "Str.obj" "Str.asm"
if errorlevel 1 goto errasm

echo Step #(3/3) LINKER
"GoLink.exe" /ni /entry STR_Entry /fo "Str.exe" "Str.obj" user32.dll kernel32.dll
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
%STR_PSE%
