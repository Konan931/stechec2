set(lib_sources
    utils/dll.cc
    utils/log.cc
    utils/np.cc

    net/socket.cc
    net/server-socket.cc
    net/client-socket.cc
    net/message.cc

    rules/actions.cc
    rules/client-messenger.cc
    rules/replay-messenger.cc
    rules/server-messenger.cc
    rules/rules.cc
    rules/options.cc
  )

set(lib_headers
    net/client-socket.hh
    net/message.hh
    net/server-socket.hh
    net/socket.hh

    rules/action.hh
    rules/actions.hh
    rules/api.hh
    rules/client-messenger.hh
    rules/config.hh
    rules/game-state-history.hh
    rules/game-state.hh
    rules/messenger.hh
    rules/options.hh
    rules/player.hh
    rules/replay-messenger.hh
    rules/rules.hh
    rules/server-messenger.hh
    rules/types.hh

    utils/buffer.hh
    utils/dll.hh
    utils/log.hh
    utils/np.hh
    utils/sandbox.hh
    utils/sandbox.inl
)

add_library(
    stechec2
    SHARED
        ${lib_sources}
  )

add_library(Stechec2::Stechec2 ALIAS stechec2)

set_target_properties(stechec2 PROPERTIES EXPORT_NAME Stechec2)
target_sources(stechec2
    PUBLIC FILE_SET HEADERS
    BASE_DIRS . FILES ${lib_headers}
)

get_target_property(hdrs stechec2 HEADER_SET)

target_compile_definitions(stechec2
    PRIVATE
        MODULE_COLOR=ANSI_COL_PURPLE
        MODULE_NAME="lib"
)

target_link_libraries(
    stechec2
    PUBLIC
        gflags
    PRIVATE
        cppzmq
    )

target_include_directories(
    stechec2
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/>
        $<INSTALL_INTERFACE:/>
    )

if (BUILD_TESTING)
    add_subdirectory(rules/tests)
    add_subdirectory(utils/tests)
endif()

install(
  TARGETS
    stechec2
  EXPORT
    stechec2-targets
  RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  FILE_SET HEADERS
    )
