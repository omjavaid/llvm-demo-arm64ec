# ARM64EC and x64 Interop Demo

This project demonstrates how to build and link an ARM64EC executable with an x64 DLL on Windows ARM64 devices. It serves as a proof of concept for cross-architecture interoperability using the ARM64EC technology.

## Repository

[GitHub Repository](https://github.com/PLACEHOLDER/arm64ec-x64-demo)

## Overview

The demo consists of a simple image processing application with two main components:
- An x64 DLL that provides basic image manipulation functions
- An ARM64EC executable that uses the x64 DLL

This demonstrates the ability to:
1. Build x64 libraries on ARM64 Windows
2. Create ARM64EC executables that consume x64 DLLs
3. Properly link and run cross-architecture binaries

## Prerequisites

- Windows 11 on ARM64 device
- Visual Studio 2022 (Community Edition or higher)
- CMake 3.15 or later
- Ninja build system
- LLVM/Clang (with clang-cl)

## Project Structure

```
.
├── include/
│   └── image_lib.h       # Library interface
├── src/
│   ├── image_lib.cpp     # x64 library implementation
│   └── main.cpp          # ARM64EC application
├── CMakeLists.txt        # Build configuration
├── build_x64.bat         # x64 library build script
└── build_arm64ec.bat     # ARM64EC application build script
```

## Building the Project

The build process is split into two steps to ensure proper environment setup for each architecture:

### 1. Building the x64 Library

Open a new terminal and run:
```batch
build_x64.bat
```

This will:
- Set up the x64 cross-compilation environment
- Build the image processing library as x64
- Verify the DLL architecture

### 2. Building the ARM64EC Application

Open a new terminal and run:
```batch
build_arm64ec.bat
```

This will:
- Set up the ARM64EC compilation environment
- Build the test application
- Copy the x64 DLL to the output directory
- Verify both binary architectures

## Output

After successful builds, you'll find:
- x64 Library: `build/x64/bin/image_lib.dll`
- ARM64EC Executable: `build/arm64ec/bin/image_test.exe`

The application will generate three test images:
- `gradient.ppm`: A color gradient
- `bright.ppm`: Brightness-adjusted gradient
- `gray.ppm`: Grayscale version

## Technical Details

### Build Environment Setup

The project uses specific Visual Studio environment scripts:
- For x64: `vcvarsarm64_x64.bat` - Sets up x64 cross-compilation
- For ARM64EC: `vcvarsarm64.bat` - Sets up native ARM64/ARM64EC compilation

### CMake Configuration

Key CMake settings:
- Uses `link.exe` instead of `lld-link` for ARM64EC compatibility
- Properly sets compiler targets for each architecture
- Manages library and executable dependencies

### Binary Verification

The build scripts verify the correct architecture of built binaries:
- ARM64EC executable shows as "8664 machine (x64) (ARM64X)" in dumpbin
- x64 DLL shows as "8664 machine (x64)"

## Common Issues

1. **Build Environment**: Each architecture must be built in a separate console with its own environment setup.
2. **Linker Selection**: ARM64EC binaries must use `link.exe`, not `lld-link`.
3. **DLL Location**: The x64 DLL must be in the same directory as the ARM64EC executable.

## References

- [ARM64EC Documentation](https://learn.microsoft.com/en-us/windows/arm/arm64ec)
- [Visual Studio ARM64 Development](https://learn.microsoft.com/en-us/windows/arm/visual-studio) 