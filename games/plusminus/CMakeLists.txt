cmake_minimum_required(VERSION 3.23)
project(plusminus LANGUAGES CXX)

set(game_src
    src/rules.cc
    src/entry.cc
    src/interface.cc
    src/api.cc
    src/action_guess.cc
    src/game_state.cc
)

find_package(Stechec2 REQUIRED)

add_library(
    ${PROJECT_NAME}
    SHARED
        ${game_src}
  )

target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        MODULE_COLOR=ANSI_COL_YELLOW
        MODULE_NAME="rules"
)

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC
        Stechec2::Stechec2
    )

target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/>
        $<INSTALL_INTERFACE:/>
    )

install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(FILES ${PROJECT_NAME}.yml DESTINATION share/stechec2/${PROJECT_NAME})
