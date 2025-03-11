# ⚙️ cmakekt

> CMake plugin for Kotlin/Native Bindings

This repository contains the source code for **CMakeKt**, a CMake plugin to generate Kotlin/Native bindings from your C project. C++ projects are not supported by Kotlin/Native.

## Installation

You have a few options:

- Clone this repository and include the `CMakeKt.cmake` file in your project.

```bash
git clone https://github.com/gmitch215/cmakekt.git
cd cmakekt

# Run the install script, may require sudo
sudo cmake --build . --target install

# Alternatively, Copy the CMakeKt.cmake file to your project
cp CMakeKt.cmake /path/to/your/project
```

- Download an archive of the repository from the [releases page](https://github.com/gmitch215/cmakekt), extract it, and include the `CMakeKt.cmake` file in your project.

```bash
wget -O cmakekt.zip <url>

unzip cmakekt.zip
cd cmakekt

# Copy the CMakeKt.cmake file to your project
cp CMakeKt.cmake /path/to/your/project
```

- Copy the contents of the `CMakeKt.cmake` file and paste it into your project.

## Getting Started

Simply include the `CMakeKt.cmake` file in your CMake project and call the `include(CMakeKt)` function.

```cmake
include(CMakeKt)
```