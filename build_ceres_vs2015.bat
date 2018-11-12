@echo off
set VSVAR=%VS140COMNTOOLS%vsvars32.bat
set VSNUM=2015
where /Q hg 2>&1 >NUL
if %ERRORLEVEL% == 1 (
	echo Please install mercurial before building ceres_solver.
	pause
	exit /b
)

md 3rdparty\include
md 3rdparty\lib\x64\Debug
md 3rdparty\lib\x64\Release
md 3rdparty\lib\x86\Debug
md 3rdparty\lib\x86\Release
md 3rdparty\bin\x64\Debug
md 3rdparty\bin\x64\Release
md 3rdparty\bin\x86\Debug
md 3rdparty\bin\x86\Release
::Visual Studio 2013
md 3rdparty\staticlib120\x64\Debug
md 3rdparty\staticlib120\x64\Release
md 3rdparty\staticlib120\x86\Debug
md 3rdparty\staticlib120\x86\Release
::Visual Studio 2015
md 3rdparty\staticlib140\x64\Debug
md 3rdparty\staticlib140\x64\Release
md 3rdparty\staticlib140\x86\Debug
md 3rdparty\staticlib140\x86\Release
::Visual Studio 2017
md 3rdparty\staticlib141\x64\Debug
md 3rdparty\staticlib141\x64\Release
md 3rdparty\staticlib141\x86\Debug
md 3rdparty\staticlib141\x86\Release



pushd %cd%
cd win\include
call :SafeRMDIR "Eigen"
call :SafeRMDIR "eigen-temp"
md eigen-temp
cd eigen-temp
hg clone https://bitbucket.org/eigen/eigen/
move eigen\Eigen ..\
call :SafeRMDIR "eigen-temp"
popd
call "%VSVAR%"
msbuild ceres-%VSNUM%.sln /p:Configuration=Debug /p:Platform=x64 /p:PlatformToolset=v140
msbuild ceres-%VSNUM%.sln /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v140

set HOME=ceres-windows
xcopy /Y "ceres-solver\include\*.*" ..\%HOME%\3rdparty\include\ /e /h /k 2>&1 >NUL
xcopy /Y "ceres-solver\config\ceres\internal\config.h" ..\%HOME%\3rdparty\include\ceres\internal\config.h /e /h /k 2>&1 >NUL
xcopy /Y "win\include\Eigen\*.*" ..\%HOME%\3rdparty\include\Eigen\ /e /h /k 2>&1 >NUL
xcopy /Y "x64\Release\ceres.lib" ..\%HOME%\3rdparty\lib\x64\Release 2>&1 >NUL
xcopy /Y "x64\Release\ceres.dll" ..\%HOME%\3rdparty\bin\x64\Release 2>&1 >NUL
xcopy /Y "x64\Debug\ceres.lib" ..\%HOME%\3rdparty\lib\x64\Debug 2>&1 >NUL
xcopy /Y "x64\Debug\ceres.dll" ..\%HOME%\3rdparty\bin\x64\Debug 2>&1 >NUL
pause
exit /b
::::::::::::::::::::::::::::::FUNCTION::::::::::::::::::::::::::::::
:SafeRMDIR
IF EXIST "%~1" (
	RMDIR /S /Q "%~1" 2>&1 >NUL
)
exit /b