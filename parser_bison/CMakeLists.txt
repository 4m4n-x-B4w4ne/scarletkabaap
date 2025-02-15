find_package(BISON REQUIRED)

set(BISON_SOURCES main.cc)

add_executable(parser_bison ${BISON_SOURCES})
set_basic_compile_options(parser_bison)

add_dependencies(
    parser_bison
    scarLexer
    scarRegex
    scarToken
  )

target_link_libraries(parser_bison PUBLIC scarRegex scarToken scarLexer)
