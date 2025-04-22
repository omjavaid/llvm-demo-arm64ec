cmake_minimum_required(VERSION 3.15)

# Force using link.exe instead of lld-link
set(CMAKE_LINKER link.exe)
set(CMAKE_CXX_LINKER_EXECUTABLE link.exe)
set(CMAKE_C_LINKER_EXECUTABLE link.exe)

project(ImageProcessing)

# Set C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Check build type
if(NOT DEFINED BUILD_ARM64EC)
    set(BUILD_ARM64EC OFF)
endif()

if(BUILD_ARM64EC)
    # ARM64EC executable only
    add_executable(image_test
        src/main.cpp
    )

    target_include_directories(image_test
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

    # Link against the x64 import library
    target_link_libraries(image_test
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/build/x64/lib/image_lib.lib
    )

else()
    # x64 library only
    add_library(image_lib SHARED
        src/image_lib.cpp
    )

    target_include_directories(image_lib
        PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

    target_compile_definitions(image_lib
        PRIVATE
            IMAGE_LIB_EXPORTS
    )
endif() 