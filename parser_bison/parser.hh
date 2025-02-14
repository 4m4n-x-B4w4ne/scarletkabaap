// parser.hh
#pragma once

#include "token.hh"
#include <string>
#include <vector>

// Declare external variables
extern std::vector<scarlet::token::Token> tokens;
extern size_t current_token_index;

// Declare the type for yylval
#define YYSTYPE std::string
extern YYSTYPE yylval;