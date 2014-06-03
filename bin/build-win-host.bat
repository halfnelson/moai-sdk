:: Determine target directory and cmake generator
setlocal enableextensions
set libpath=%2
set hostroot=%3
set arg1=%1
if "%arg1%"=="" set arg1=vs2012
set generator=
if "%arg1%"=="vs2008" set generator=Visual Studio 9 2008
if "%arg1%"=="vs2010" set generator=Visual Studio 10
if "%arg1%"=="vs2012" set generator=Visual Studio 11
if "%arg1%"=="vs2013" set generator=Visual Studio 12
if "%generator%"=="" (
	@echo Unknown argument "%1". Valid values are vs2008, vs2010, vs2012, vs2013. Exiting.
	goto end
)
set cmakedir=%~dp0%..\cmake
mkdir %hostroot%
xcopy /e /d /y src\host-sdl\*.* %hostroot%

cd %hostroot%



cmake -G "%generator%" ^
-DBUILD_WINDOWS=true ^
-DHOST_ONLY=true ^
-DLIB_PATH="%libpath%" ^
-DHOST_ROOT="%hostroot%" ^
"%cmakedir%\host-sdl"

