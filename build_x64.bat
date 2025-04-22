@echo off
setlocal enabledelayedexpansion

:: Create build directory
if not exist build\x64 mkdir build\x64

:: Setup x64 environment
echo Setting up x64 environment...
call "c:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsarm64_amd64.bat"
if errorlevel 1 goto error

:: Build x64 library
echo Building x64 library...
pushd build\x64
cmake -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_SYSTEM_NAME=Windows ^
    -DCMAKE_C_COMPILER_TARGET=x86_64-pc-windows-msvc ^
    -DCMAKE_CXX_COMPILER_TARGET=x86_64-pc-windows-msvc ^
    -DBUILD_ARM64EC=OFF ^
    ..\..
if errorlevel 1 goto error
cmake --build .
if errorlevel 1 goto error

:: Verify DLL architecture
echo Verifying x64 DLL architecture...
dumpbin /headers bin\image_lib.dll | findstr "machine" | findstr "x64"
if errorlevel 1 (
    echo Error: DLL is not x64 architecture
    goto error
)
popd

echo x64 library build completed successfully!
goto :eof

:error
echo Build failed!
exit /b 1 