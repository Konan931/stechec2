set(utils_tests_src
  test-buffer.cc
  test-sandbox.cc
  )

add_executable(
  utils_tests
  ${utils_tests_src}
  )

target_compile_definitions(utils_tests
    PRIVATE
        MODULE_COLOR=ANSI_COL_PURPLE
        MODULE_NAME="lib-utils-test"
)

target_link_libraries(
  utils_tests
  PRIVATE
    GTest::gtest_main
    stechec2
  )

gtest_discover_tests(utils_tests)
