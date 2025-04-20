cmake_minimum_required(VERSION 3.23)
project(tictactoe LANGUAGES CXX)

set(game_src
    src/rules.cc
    src/entry.cc
    src/interface.cc
    src/api.cc
    src/action_play.cc
    src/game_state.cc
)

find_package(Stechec2 REQUIRED)

if (BUILD_TESTING)
  find_package(GTest REQUIRED)
  include(CTest)
  include(GoogleTest)
  add_subdirectory(src/tests)
endif()

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
