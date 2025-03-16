cmake_minimum_required(VERSION 3.16)

set(PROJECT_VERSION "1.0.0")
project(CMakeKt
    VERSION ${PROJECT_VERSION}
    DESCRIPTION "A CMake plugin for generating Kotlin/Native bindings"
    HOMEPAGE_URL "https://github.com/gmitch215/cmakekt"
)

# Testing
add_subdirectory(test)
enable_testing()

# Installation
if(WIN32)
    if(CMAKE_SIZEOF_VOID_P MATCHES "8")
        set(CMAKE_INSTALL_DESTINATION "C:/Program Files/${CMAKE_PROJECT_NAME}")
    else()
        set(CMAKE_INSTALL_DESTINATION "C:/Program Files (x86)/${CMAKE_PROJECT_NAME}")
    endif()
elseif(APPLE)
    set(CMAKE_INSTALL_DESTINATION "/usr/local")
else()
    set(CMAKE_INSTALL_DESTINATION "/usr")
endif()

option(INSTALL_CMAKEKT "Install CMakeKt" ON)

if (INSTALL_CMAKEKT)
    install(FILES CMakeKt.cmake DESTINATION ${CMAKE_INSTALL_DESTINATION})
endif()

# Packaging
option(PACKAGE_CMDFX "Package ${PROJECT_NAME}" ON)

if (PACKAGE_CMDFX)
    set(CPACK_GENERATOR "ZIP;TGZ;7Z")
    set(CPACK_THREADS 0)
    set(CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/build/package")

    set(CPACK_PACKAGE_FILE_NAME "cmakekt-${PROJECT_VERSION}")

    set(CPACK_PACKAGE_CHECKSUM SHA256)

    include(CPack)
endif()