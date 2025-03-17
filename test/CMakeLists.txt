list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")

set(KN_CINTEROP_EXTRA_OPTS "-verbose")
include(CMakeKt)

set(PROJECT_LANGUAGES C)
set(CMAKE_C_STANDARD 11)

add_library("cmakekt-test-1" STATIC src/main.c)
target_include_directories("cmakekt-test-1" PRIVATE "include/lib0")
add_executable("cmakekt-test-executable-1" src/main.c)
target_include_directories("cmakekt-test-executable-1" PRIVATE "include/lib0")

add_library("cmakekt-test-2" STATIC src/main2.c)
target_include_directories("cmakekt-test-2" PRIVATE "include/lib1")
add_executable("cmakekt-test-executable-2" src/main2.c)
target_include_directories("cmakekt-test-executable-2" PRIVATE "include/lib1")