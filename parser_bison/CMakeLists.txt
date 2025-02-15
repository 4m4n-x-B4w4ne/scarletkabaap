find_package(BISON REQUIRED)

set(PARSER_Y ${CMAKE_CURRENT_SOURCE_DIR}/parser.y)
set(PARSER_C ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c)
set(PARSER_H ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)

add_custom_command(
    OUTPUT ${PARSER_C} ${PARSER_H}
    COMMAND ${BISON_EXECUTABLE} -d ${PARSER_Y} -o ${PARSER_C}
    DEPENDS ${PARSER_Y}
    COMMENT "Generating parser files with Bison"
    VERBATIM
)

add_custom_target(run_bison ALL DEPENDS ${PARSER_C} ${PARSER_H})

# Add the generated file to sources
set(BISON_SOURCES
  main.cc
  ${PARSER_C}
)

add_executable(parser_bison ${BISON_SOURCES})
set_basic_compile_options(parser_bison)

target_include_directories(parser_bison PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

add_dependencies(
    parser_bison
    scarLexer
    scarRegex
    scarToken
  )

target_link_libraries(parser_bison PUBLIC scarRegex scarToken scarLexer)
