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

- Copy the contents of the `CMakeKt.cmake` file and paste it into your project.

## Getting Started

Simply include the `CMakeKt.cmake` file in your CMake project and call the `include(CMakeKt)` function.

```cmake
include(CMakeKt)
```

The plugin will create a `klib` target that is enabled by default. It will create a `.klib` file in `build/cinterop/` that you can include in your Kotlin project.

You can learn how to configure the plugin using the documentation [here](https://docs.gmitch215.dev/cmakekt/).

## Troubleshooting

### `/bin/sh: 1: cinterop: not found`

You need to add the `cinterop` and `run_konan` paths to your `PATH` environment variable. You can do this by adding the following to your `.bashrc` or `.zshrc` file.

```bash
# kotlin-native
export KOTLIN_NATIVE_HOME="/opt/kotlin-native/kotlin-native-2.1.10"
export PATH="$PATH:$KOTLIN_NATIVE_HOME/bin"
```

If you are prepending `sudo` to the cmake command, you need to create a symantic link so `sudo` can find the command.

```bash
sudo ln -s $KOTLIN_NATIVE_HOME/bin/cinterop /usr/local/bin/cinterop
sudo ln -s $KOTLIN_NATIVE_HOME/bin/run_konan /usr/local/bin/run_konan
sudo ln -s $KOTLIN_NATIVE_HOME/bin/kotlinc-native /usr/local/bin/kotlinc-native
```

### `Operation not permitted`

Prepend `sudo` to the cmake command.

```bash
sudo cmake --build .
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
