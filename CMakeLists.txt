cmake_minimum_required(VERSION 3.16)

set(PROJECT_VERSION "2.0.0")
project(CMakeKt
    VERSION ${PROJECT_VERSION}
    DESCRIPTION "A CMake plugin for generating Kotlin/Native bindings"
    HOMEPAGE_URL "https://github.com/gmitch215/cmakekt"
)

# Testing
option(TEST_CMAKEKT "Enable CMakeKt tests" OFF)

if (TEST_CMAKEKT)
    add_subdirectory(test)
    enable_testing()
endif()