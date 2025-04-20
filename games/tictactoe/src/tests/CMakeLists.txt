set(tests_tictactoe_src
    test-action_play.cc
    test-api.cc
    test-rules.cc
  )

add_executable(
  tests_tictactoe
  ${tests_tictactoe_src}
  )

target_link_libraries(
  tests_tictactoe
  PRIVATE
    GTest::gtest_main
    tictactoe
  )

target_include_directories(
    tests_tictactoe
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/>
        $<INSTALL_INTERFACE:/>
    )

gtest_discover_tests(tests_tictactoe)
