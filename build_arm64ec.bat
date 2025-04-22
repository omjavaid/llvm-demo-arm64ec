@echo off
setlocal enabledelayedexpansion

:: Check if x64 library exists
if not exist build\x64\lib\image_lib.lib (
    echo Error: x64 library not found. Please run build_x64.bat first.
    exit /b 1
)

:: Create build directory
if not exist build\arm64ec mkdir build\arm64ec

:: Setup ARM64EC environment
echo Setting up ARM64EC environment...
call "c:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsarm64.bat"
if errorlevel 1 goto error

:: Build ARM64EC application
echo Building ARM64EC application...
pushd build\arm64ec
cmake -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_SYSTEM_NAME=Windows ^
    -DCMAKE_C_COMPILER_TARGET=arm64ec-pc-windows-msvc ^
    -DCMAKE_CXX_COMPILER_TARGET=arm64ec-pc-windows-msvc ^
    -DBUILD_ARM64EC=ON ^
    ..\..
if errorlevel 1 goto error
cmake --build .
if errorlevel 1 goto error

:: Copy x64 DLL to ARM64EC executable directory
echo Copying x64 DLL to ARM64EC executable directory...
copy /Y ..\x64\bin\image_lib.dll bin\
if errorlevel 1 goto error

:: Verify executable and DLL architectures
echo Verifying binary architectures...

echo Checking ARM64EC executable...
dumpbin /headers bin\image_test.exe | findstr "machine" | findstr "ARM64X"
if errorlevel 1 (
    echo Error: Executable is not ARM64EC architecture
    goto error
)

echo Checking x64 DLL...
dumpbin /headers bin\image_lib.dll | findstr "machine" | findstr "x64"
if errorlevel 1 (
    echo Error: DLL is not x64 architecture
    goto error
)

popd

echo ARM64EC application build completed successfully!
echo Both executable ^(ARM64EC/ARM64X^) and DLL ^(x64^) verified.
goto :eof

:error
echo Build failed!
exit /b 1 