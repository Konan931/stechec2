set(stechec_client_src
  main.cc
  client.cc
  )

add_executable(stechec2-client
  ${stechec_client_src}
  )

target_compile_definitions(stechec2-client
    PRIVATE
        MODULE_COLOR=ANSI_COL_YELLOW
        MODULE_NAME="client"
        MODULE_VERSION="${CMAKE_PROJECT_VERSION}"
)

target_link_libraries(stechec2-client
  PRIVATE
    stechec2
  )

install(
  TARGETS
    stechec2-client
  RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
