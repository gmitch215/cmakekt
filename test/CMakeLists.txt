list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")
include(CMakeKt)

set(PROJECT_LANGUAGES C)
set(CMAKE_C_STANDARD 11)

file(GLOB SOURCES src/*.c)
add_library("cmakekt-test" SHARED ${SOURCES})
target_include_directories("cmakekt-test" PRIVATE "include")

add_executable("cmakekt-test-executable" ${SOURCES})
target_include_directories("cmakekt-test-executable" PRIVATE "include")