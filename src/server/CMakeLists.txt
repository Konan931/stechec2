set(stechec_server_src
  main.cc
  server.cc
  )

add_executable(
  stechec2-server
  ${stechec_server_src}
  )

target_compile_definitions(stechec2-server
    PRIVATE
        MODULE_COLOR=ANSI_COL_RED
        MODULE_NAME="server"
        MODULE_VERSION="${CMAKE_PROJECT_VERSION}"
)

target_link_libraries(
  stechec2-server
  PRIVATE
    stechec2
  )

install(
  TARGETS
    stechec2-server
  RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
