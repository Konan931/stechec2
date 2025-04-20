set(stechec_replay_src
  main.cc
  replay.cc
  )

add_executable(
  stechec2-replay
  ${stechec_replay_src}
  )

target_compile_definitions(stechec2-replay
    PRIVATE
        MODULE_COLOR=ANSI_COL_RED
        MODULE_NAME="replay"
        MODULE_VERSION="${CMAKE_PROJECT_VERSION}"
)

target_link_libraries(
  stechec2-replay
  PRIVATE
    stechec2
  )

install(
  TARGETS
    stechec2-replay
  RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
