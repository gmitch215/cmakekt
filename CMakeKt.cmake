# Check Variables
if (NOT DEFINED PROJECT_NAME)
    message(FATAL_ERROR "PROJECT_NAME must be defined")
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
        file(GLOB_RECURSE KN_DEFINITION_HEADERS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/include" "include/*.h")
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

    if (DEFINED RUNTIME_OUTPUT_DIRECTORY)
        set(KN_DEFINITION_LIBRARY_PATHS "${KN_DEFINITION_LIBRARY_PATHS} ${RUNTIME_OUTPUT_DIRECTORY}")
    endif()
endif()

## KN_DEFINITION_LIBRARIES
if (NOT DEFINED KN_DEFINITION_LIBRARIES)
    file(GLOB KN_DEFINITION_LIBRARIES RELATIVE "${CMAKE_CURRENT_BINARY_DIR}"
        "${CMAKE_CURRENT_BINARY_DIR}/*.a" 
        "${CMAKE_CURRENT_BINARY_DIR}/*.dylib" 
        "${CMAKE_CURRENT_BINARY_DIR}/*.so" 
        "${CMAKE_CURRENT_BINARY_DIR}/*.dll"
        "${CMAKE_CURRENT_BINARY_DIR}/*.lib"
    )
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

## KN_DEFINITION_FILE_OUTPUT
if (NOT DEFINED KN_DEFINITION_FILE_OUTPUT)
    set(KN_DEFINITION_FILE_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/build/cinterop/${PROJECT_NAME}.def")
endif()

## KN_CINTEROP_FILE_OUTPUT
if (NOT DEFINED KN_CINTEROP_FILE_OUTPUT)
    set(KN_CINTEROP_FILE_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/build/cinterop/${PROJECT_NAME}.klib")
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

## cinterop

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

file(WRITE ${KN_DEFINITION_FILE_OUTPUT} "${KN_DEFINITION_FILE_OUTPUT_CONTENT}")

### Create Command
if (DEFINED ENV{KOTLIN_NATIVE_HOME})
    set(KN_CINTEROP_COMMAND "$ENV{KOTLIN_NATIVE_HOME}/bin/cinterop")
else()
    set(KN_CINTEROP_COMMAND "cinterop")
endif()

add_custom_target(
    klib ALL
    COMMAND ${KN_CINTEROP_COMMAND} 
        -def ${KN_DEFINITION_FILE_OUTPUT} 
        -o ${KN_CINTEROP_FILE_OUTPUT} 
        ${KN_CINTEROP_EXTRA_OPTS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    BYPRODUCTS ${KN_DEFINITION_FILE_OUTPUT} ${KN_CINTEROP_FILE_OUTPUT}
    COMMENT "Generating Kotlin/Native bindings"
    VERBATIM
)

# install (maven local)
if (DEFINED ENV{M2_HOME})
    set(MAVEN_LOCAL "$ENV{M2_HOME}/repository")
else()
    set(MAVEN_LOCAL "$ENV{HOME}/.m2/repository")
endif()

if (NOT EXISTS "${MAVEN_LOCAL}")
    file(MAKE_DIRECTORY "${MAVEN_LOCAL}")
endif()

if (DEFINED ENV{MAVEN_HOME})
    set(MAVEN_COMMAND "$ENV{MAVEN_HOME}/bin/mvn")
else()
    set(MAVEN_COMMAND "mvn")
endif()

add_custom_target(
    "install-maven-local"
    COMMAND ${MAVEN_COMMAND} install:install-file 
        -Dfile=${KN_CINTEROP_FILE_OUTPUT} 
        -Ddescription=${PROJECT_DESCRIPTION}
        -DgroupId=${KN_INSTALL_GROUPID} 
        -DartifactId=${KN_INSTALL_ARTIFACTID} 
        -Dversion=${PROJECT_VERSION} 
        -Dpackaging=klib 
        -DlocalRepositoryPath=${MAVEN_LOCAL}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS klib
    COMMENT "Installing Kotlin/Native bindings to Maven Local"
    VERBATIM
)
install(CODE "
    execute_process(COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target install-maven-local)
")

# deploy (maven remote)
if (DEFINED MAVEN_REMOTE_URL AND DEFINED MAVEN_REMOTE_ID)
    add_custom_target(
        deploy-maven
        COMMAND ${MAVEN_COMMAND} deploy:deploy-file 
            -Durl=${MAVEN_REMOTE_URL}
            -DrepositoryId=${MAVEN_REMOTE_ID}
            -DgroupId=${KN_INSTALL_GROUPID} 
            -DartifactId=${KN_INSTALL_ARTIFACTID} 
            -Dversion=${PROJECT_VERSION} 
            -Dpackaging=klib 
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS klib
        COMMENT "Deploying Kotlin/Native bindings to Maven Repository"
        VERBATIM
    )
endif()