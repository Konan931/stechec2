set(rules_tests_src
  test-action.cc
  test-game-state-history.cc
  )

add_executable(
  rules_tests
  ${rules_tests_src}
  )

target_compile_definitions(rules_tests
    PRIVATE
        MODULE_COLOR=ANSI_COL_PURPLE
        MODULE_NAME="lib-rules-test"
)
target_link_libraries(
  rules_tests
  PRIVATE
    GTest::gtest_main
    stechec2
  )

gtest_discover_tests(rules_tests)
