@echo off

echo ****************************************************************
echo UASM REGRESSION TEST SUITE
echo ****************************************************************
echo .
echo .

SET ASMX=%1
if (%1)==() SET ASMX=..\..\x64\release\uasm64.exe
SET FCMP=..\fcmp.exe

if not exist result md result
cd result
del *.*

for %%f in (..\src\plain_bin\*.asm) do call :cmpbin %%f
for %%f in (..\src\pe64_bin\*.asm) do call :cmppebin %%f
for %%f in (..\src\win64\*.asm) do call :cmpwin64 %%f

cd ..
echo .
echo .
echo ****************************************************************
echo  REGRESSION TESTS COMPLETED
echo ****************************************************************
echo .
echo .
goto :end

:cmpbin
echo ****************************************************************
ECHO %1
echo ****************************************************************
echo .
echo .
%ASMX% -q -bin %1
%FCMP% %~n1.bin ..\exp\%~n1.exp
if errorlevel 1 goto end
del %~n1.bin
goto end

:cmppebin
echo ****************************************************************
ECHO %1
echo ****************************************************************
echo .
echo .
%ASMX% -q -bin -Fo %~n1.exe %1
%FCMP% %~n1.exe ..\exp\%~n1.exp
if errorlevel 1 goto end
del %~n1.exe
goto end

:cmpwin64
echo ****************************************************************
ECHO %1
echo ****************************************************************
echo .
echo .
%ASMX% -c -q -win64 -Zp8 %1
%FCMP% /O16 %~n1.obj ..\exp\%~n1.exp
if errorlevel 1 goto end
del %~n1.obj
goto end

:end
