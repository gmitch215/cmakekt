# Check Variables
if (NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "PROJECT_NAME must be defined")
endif()

# Normalize install Paths
if (CMAKE_MINOR_VERSION GREATER_EQUAL 31)
    cmake_policy(SET CMP0177 NEW)
endif()

# Prevent MSVC Compiler
if (WIN32 AND CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    message(FATAL_ERROR "Kotlin/Native does not support MSVC compiler. Please use MinGW with the \"MinGW Makefiles\" CMake generator.")
endif()

# Define Variables

## KN_CURRENT_ARCHITECTURE
set(KN_CURRENT_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})

if (KN_CURRENT_ARCHITECTURE STREQUAL "AMD64" OR KN_CURRENT_ARCHITECTURE STREQUAL "x86_64")
    set(KN_CURRENT_ARCHITECTURE "x64")
elseif (KN_CURRENT_ARCHITECTURE STREQUAL "aarch64")
    set(KN_CURRENT_ARCHITECTURE "arm64")
endif()

## KN_CURRENT_OS
set(KN_CURRENT_OS ${CMAKE_SYSTEM_NAME})

if (KN_CURRENT_OS STREQUAL "Windows" OR WIN32)
    set(KN_CURRENT_OS "mingw")
elseif (KN_CURRENT_OS STREQUAL "Darwin" OR KN_CURRENT_OS STREQUAL "macOS" OR APPLE)
    set(KN_CURRENT_OS "macos")
else()
    set(KN_CURRENT_OS "linux") # default to linux
endif()

## KN_CURRENT_TARGET
set(KN_CURRENT_TARGET "${KN_CURRENT_OS}_${KN_CURRENT_ARCHITECTURE}")

## KN_DEFINITION_HEADERS
if (NOT DEFINED KN_DEFINITION_HEADERS)
    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/include")
        file(GLOB_RECURSE KN_DEFINITION_HEADERS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/include" "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
        string(REPLACE ";" " " KN_DEFINITION_HEADERS "${KN_DEFINITION_HEADERS}")
    else()
        set(KN_DEFINITION_HEADERS "")
    endif()
endif()

## KN_DEFINITION_MODULES
if (NOT DEFINED KN_DEFINITION_MODULES)
    set(KN_DEFINITION_MODULES "")
endif()

## KN_DEFINITION_HEADER_FILTER
if (NOT DEFINED KN_DEFINITION_HEADER_FILTER)
    set(KN_DEFINITION_HEADER_FILTER "")
endif()

## KN_DEFINITION_PACKAGE
if (NOT DEFINED KN_DEFINITION_PACKAGE)
    string(TOLOWER "${PROJECT_NAME}" KN_DEFINITION_PACKAGE)
endif()

## KN_DEFINITION_COMPILEROPTS
if (NOT DEFINED KN_DEFINITION_COMPILEROPTS)
    if (DEFINED CMAKE_C_FLAGS)
        set(KN_DEFINITION_COMPILEROPTS "${CMAKE_C_FLAGS}")
    elseif (DEFINED CMAKE_OBJC_FLAGS)
        set(KN_DEFINITION_COMPILEROPTS "${CMAKE_OBJC_FLAGS}")
    else()
        set(KN_DEFINITION_COMPILEROPTS "")
    endif()

    set(KN_DEFINITION_COMPILEROPTS "${KN_DEFINITION_COMPILEROPTS} -I${CMAKE_CURRENT_SOURCE_DIR}/include")
    string(STRIP "${KN_DEFINITION_COMPILEROPTS}" KN_DEFINITION_COMPILEROPTS)
endif()

## KN_DEFINITION_LINKEROPTS
if (NOT DEFINED KN_DEFINITION_LINKEROPTS)
    if (DEFINED CMAKE_C_FLAGS)
        set(KN_DEFINITION_LINKEROPTS "${CMAKE_C_FLAGS}")
    elseif (DEFINED CMAKE_OBJC_FLAGS)
        set(KN_DEFINITION_LINKEROPTS "${CMAKE_OBJC_FLAGS}")
    else()
        set(KN_DEFINITION_LINKEROPTS "")
    endif()

    set(KN_DEFINITION_LINKEROPTS "${KN_DEFINITION_LINKEROPTS} -L${CMAKE_CURRENT_BINARY_DIR}")
    string(STRIP "${KN_DEFINITION_LINKEROPTS}" KN_DEFINITION_LINKEROPTS)
endif()

## KN_DEFINITION_LIBRARY_PATHS
if (NOT DEFINED KN_DEFINITION_LIBRARY_PATHS)
    set(KN_DEFINITION_LIBRARY_PATHS "${CMAKE_CURRENT_BINARY_DIR}")

    if (DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
        set(KN_DEFINITION_LIBRARY_PATHS "${KN_DEFINITION_LIBRARY_PATHS} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    endif()

    if (DEFINED CMAKE_CONFIGURATION_TYPES)
        foreach(CONFIGURATION_TYPE IN ITEMS ${CMAKE_CONFIGURATION_TYPES})
            set(KN_DEFINITION_LIBRARY_PATHS "${KN_DEFINITION_LIBRARY_PATHS} ${CMAKE_CURRENT_BINARY_DIR}/${CONFIGURATION_TYPE}")
        endforeach()
    endif()
endif()

## KN_DEFINITION_LIBRARIES
if (NOT DEFINED KN_DEFINITION_LIBRARIES)
    set(KN_DEFINITION_LIBRARIES "")
    string(REPLACE " " ";" KN_DEFINITION_LIBRARY_PATHS_LIST "${KN_DEFINITION_LIBRARY_PATHS}")

    foreach(LIBRARY_PATH IN ITEMS ${KN_DEFINITION_LIBRARY_PATHS_LIST})
        file(GLOB KN_DEFINITION_LIBRARIES_RELATIVE RELATIVE "${LIBRARY_PATH}" "${LIBRARY_PATH}/*.a")

        list(APPEND KN_DEFINITION_LIBRARIES ${KN_DEFINITION_LIBRARIES_RELATIVE})
    endforeach()
    list(REMOVE_DUPLICATES KN_DEFINITION_LIBRARIES)

    string(REPLACE ";" " " KN_DEFINITION_LIBRARIES "${KN_DEFINITION_LIBRARIES}")
endif()

## KN_DEFINITION_EXTRA
if (NOT DEFINED KN_DEFINITION_EXTRA)
    set(KN_DEFINITION_EXTRA "")
endif()

## KN_CINTEROP_EXTRA_OPTS
if (NOT DEFINED KN_CINTEROP_EXTRA_OPTS)
    set(KN_CINTEROP_EXTRA_OPTS "")
endif()

## KN_CINTEROP_FOLDER
if (NOT DEFINED KN_CINTEROP_FOLDER)
    set(KN_CINTEROP_FOLDER "${CMAKE_CURRENT_BINARY_DIR}/cinterop")
endif()

## KN_PROJECT_VERSION
if (NOT DEFINED KN_PROJECT_VERSION)
    set(KN_PROJECT_VERSION "${PROJECT_VERSION}")
endif()

## KN_INSTALL_GROUPID
if (NOT DEFINED KN_INSTALL_GROUPID)
    set(KN_INSTALL_GROUPID "${KN_DEFINITION_PACKAGE}")
endif()

## KN_INSTALL_ARTIFACTID
if (NOT DEFINED KN_INSTALL_ARTIFACTID)
    set(KN_INSTALL_ARTIFACTID "${PROJECT_NAME}")
endif()

# Targets

# cinterop & maven
if (DEFINED ENV{KOTLIN_NATIVE_HOME})
    set(KN_CINTEROP_COMMAND "$ENV{KOTLIN_NATIVE_HOME}/bin/cinterop")
else()
    set(KN_CINTEROP_COMMAND "cinterop")
endif()

if (DEFINED ENV{M2_HOME})
    set(MAVEN_LOCAL "$ENV{M2_HOME}/repository")
else()
    # read if custom maven local repository is set
    find_file(MAVEN_SETTINGS
        NAMES settings.xml
        PATHS "$ENV{HOME}/.m2" "$ENV{USERPROFILE}/.m2"
        NO_DEFAULT_PATH
    )

    if(MAVEN_SETTINGS)
        file(READ "${MAVEN_SETTINGS}" MAVEN_SETTINGS_CONTENT)
        string(REGEX MATCH "<localRepository>([^<]+)</localRepository>" _ "${MAVEN_SETTINGS_CONTENT}")
    
        if(CMAKE_MATCH_1)
            set(MAVEN_LOCAL "${CMAKE_MATCH_1}")
        endif()
    endif()

    # otherwise, use default maven local repository
    if (NOT DEFINED MAVEN_LOCAL)
        if(WIN32)
            set(MAVEN_LOCAL "$ENV{USERPROFILE}/.m2/repository")
        else()
            set(MAVEN_LOCAL "$ENV{HOME}/.m2/repository")
        endif()
    endif()
endif()

if (NOT EXISTS "${MAVEN_LOCAL}")
    file(MAKE_DIRECTORY "${MAVEN_LOCAL}")
endif()

if (DEFINED ENV{MAVEN_HOME})
    set(MAVEN_COMMAND "$ENV{MAVEN_HOME}/bin/mvn")
else()
    set(MAVEN_COMMAND "mvn")
endif()

function(add_klib_binary target)
    ### Generate File Content
    set(KN_DEFINITION_FILE_OUTPUT_CONTENT "### Generated by CMakeKt ###\n")

    if (NOT KN_DEFINITION_HEADERS STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nheaders = ${KN_DEFINITION_HEADERS}"
        )
    endif()

    if (NOT KN_DEFINITION_MODULES STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nmodules = ${KN_DEFINITION_MODULES}"
        )
    endif()

    if (NOT KN_DEFINITION_HEADER_FILTER STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nheaderFilter = ${KN_DEFINITION_HEADER_FILTER}"
        )
    endif()

    if (NOT KN_DEFINITION_PACKAGE STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\npackage = ${KN_DEFINITION_PACKAGE}"
        )
    endif()

    if (NOT KN_DEFINITION_COMPILEROPTS STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\ncompilerOpts = ${KN_DEFINITION_COMPILEROPTS}"
        )
    endif()

    if (NOT KN_DEFINITION_LINKEROPTS STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nlinkerOpts = ${KN_DEFINITION_LINKEROPTS}"
        )
    endif()

    if (NOT KN_DEFINITION_LIBRARIES STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nstaticLibraries = ${KN_DEFINITION_LIBRARIES}"
        )
    endif()

    if (NOT KN_DEFINITION_LIBRARY_PATHS STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\nlibraryPaths = ${KN_DEFINITION_LIBRARY_PATHS}"
        )
    endif()

    if (NOT KN_DEFINITION_EXTRA STREQUAL "")
        set(KN_DEFINITION_FILE_OUTPUT_CONTENT 
            "${KN_DEFINITION_FILE_OUTPUT_CONTENT}\n---\n${KN_DEFINITION_EXTRA}"
        )
    endif()

    set(KN_DEFINITION_FILE_OUTPUT "${KN_CINTEROP_FOLDER}/${target}/${target}.def")
    set(KN_CINTEROP_FILE_OUTPUT "${KN_CINTEROP_FOLDER}/${target}/${target}.klib")
    file(WRITE ${KN_DEFINITION_FILE_OUTPUT} "${KN_DEFINITION_FILE_OUTPUT_CONTENT}")

    add_custom_command(TARGET ${target}
        POST_BUILD
        COMMAND ${KN_CINTEROP_COMMAND} 
            -def ${KN_DEFINITION_FILE_OUTPUT} 
            -o ${KN_CINTEROP_FILE_OUTPUT} 
            ${KN_CINTEROP_EXTRA_OPTS}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        BYPRODUCTS ${KN_DEFINITION_FILE_OUTPUT} ${KN_CINTEROP_FILE_OUTPUT}
        COMMENT "Generating Kotlin/Native bindings ${target}.klib"
        VERBATIM
    )

    ### Install to Maven Local Repository
    string(REGEX REPLACE "[-_ ]+" "" KN_INSTALL_GROUPID_REAL "${KN_INSTALL_GROUPID}.${target}")
    string(REPLACE "." "/" KN_INSTALL_GROUPID_PATH "${KN_INSTALL_GROUPID_REAL}")

    set(KN_MAVEN_INSTALL_PATH "${MAVEN_LOCAL}/${KN_INSTALL_GROUPID_PATH}/${KN_INSTALL_ARTIFACTID}/${KN_PROJECT_VERSION}")
    set(KN_MAVEN_POM_FILE_PATH "${KN_CINTEROP_FOLDER}/${target}/pom.xml")
    set(KN_MAVEN_POM_FILE_CONTENT "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">
    <!-- Generated by CMakeKt -->
    <modelVersion>4.0.0</modelVersion>
    <groupId>${KN_INSTALL_GROUPID_REAL}</groupId>
    <artifactId>${KN_INSTALL_ARTIFACTID}</artifactId>
    <version>${KN_PROJECT_VERSION}</version>
    <name>${PROJECT_NAME}</name>
    <description>${PROJECT_DESCRIPTION}</description>
    <url>${PROJECT_HOMEPAGE_URL}</url>
</project>")
    file(WRITE "${KN_MAVEN_POM_FILE_PATH}" "${KN_MAVEN_POM_FILE_CONTENT}")
    
    install(FILES "${KN_CINTEROP_FILE_OUTPUT}" DESTINATION "${KN_MAVEN_INSTALL_PATH}" RENAME "${KN_INSTALL_ARTIFACTID}-${KN_PROJECT_VERSION}.klib")
    install(FILES "${KN_MAVEN_POM_FILE_PATH}" DESTINATION "${KN_MAVEN_INSTALL_PATH}" RENAME "${KN_INSTALL_ARTIFACTID}-${KN_PROJECT_VERSION}.pom")
endfunction()

function(add_klib_binaries targets)
    foreach(target IN LISTS targets)
        add_klib_binary(${target})
    endforeach()
endfunction()

# deploy (maven remote)
function(add_maven_deployment target remote id)
    add_custom_command(TARGET ${target} 
        POST_BUILD
        COMMAND ${MAVEN_COMMAND} deploy:deploy-file
            -Dfile=${target}/${target}.klib
            -DpomFile=${target}/pom.xml
            -Durl=${remote}
            -DrepositoryId=${id}
            -Dpackaging=klib 
        WORKING_DIRECTORY ${KN_CINTEROP_FOLDER}
        COMMENT "Deploying ${target}.klib to Maven Repository"
        VERBATIM
    )
endfunction()
