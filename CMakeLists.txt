cmake_minimum_required(VERSION 3.23)

project(Stechec VERSION 2.0.0 LANGUAGES CXX)

option(BUILD_GAMES "Build game directory")

set(CMAKE_CXX_STANDARD 17)
add_compile_options(
  -Wall
  -Wextra
  -Wpedantic
  )

include(CTest)
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(CMakeFindDependencyMacro)

set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/Stechec2)

if (BUILD_TESTING)
  find_package(GTest REQUIRED)
  include(GoogleTest)
endif()

find_package(cppzmq REQUIRED)
find_package(gflags REQUIRED)

add_subdirectory(src/lib)
add_subdirectory(src/client)
add_subdirectory(src/server)
add_subdirectory(src/replay)

if (BUILD_GAMES)
    add_subdirectory(games/tictactoe)
    add_subdirectory(games/plusminus)
endif()

install(EXPORT stechec2-targets
    FILE
        Stechec2Targets.cmake
    NAMESPACE
        Stechec2::
    DESTINATION
        ${INSTALL_CONFIGDIR}
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/Stechec2ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/Stechec2Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/Stechec2Config.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/Stechec2Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/Stechec2ConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)

export(EXPORT stechec2-targets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/Stechec2Targets.cmake
    NAMESPACE Stechec2::)

export(PACKAGE Stechec2)
