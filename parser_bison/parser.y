%language "C++"

%{
#include <string>
#include "token/token.hh"
#include "lexer/lexer.hh"

// Declare the type for yylval
#define YYSTYPE std::string
extern YYSTYPE yylval;

// Declare your lexer's token vector and current position
extern std::vector<scarlet::token::Token> tokens;
extern size_t current_token_index;

int yylex();
void yyerror(const char* s);
%}

%token IDENTIFIER CONSTANT
%token INT STATIC EXTERN VOID
%token RETURN IF ELSE DO WHILE FOR BREAK CONTINUE
%token OPEN_PARANTHESES CLOSE_PARANTHESES OPEN_BRACE CLOSE_BRACE
%token SEMICOLON COLON COMMA QUESTION_MARK
%token TILDE HYPHEN PLUS ASTERISK FORWARD_SLASH PERCENT_SIGN
%token ASSIGNMENT
%token NOT LAND LOR
%token EQUAL NOTEQUAL LESSTHAN GREATERTHAN LESSTHANEQUAL GREATERTHANEQUAL

/* Operator precedence and associativity */
%precedence THEN
%precedence ELSE

%right ASSIGNMENT
%right COLON
%right QUESTION_MARK
%left LOR
%left LAND
%left EQUAL NOTEQUAL
%left LESSTHAN GREATERTHAN LESSTHANEQUAL GREATERTHANEQUAL
%left PLUS HYPHEN
%left ASTERISK FORWARD_SLASH PERCENT_SIGN
%precedence UNARY_MINUS UNARY_NOT UNARY_TILDE

%%

/* Rest of your grammar rules remain the same */
program
    : /* empty */
    | program declaration
    ;

declaration
    : variable_declaration
    | function_declaration
    ;

variable_declaration
    : specifiers IDENTIFIER SEMICOLON
    | specifiers IDENTIFIER ASSIGNMENT exp SEMICOLON
    ;

function_declaration
    : specifiers IDENTIFIER OPEN_PARANTHESES param_list CLOSE_PARANTHESES SEMICOLON
    | specifiers IDENTIFIER OPEN_PARANTHESES param_list CLOSE_PARANTHESES block
    ;

specifiers
    : specifier
    | specifiers specifier
    ;

specifier
    : INT
    | STATIC
    | EXTERN
    ;

param_list
    : VOID
    | INT IDENTIFIER param_list_tail
    ;

param_list_tail
    : /* empty */
    | COMMA INT IDENTIFIER param_list_tail
    ;

block
    : OPEN_BRACE CLOSE_BRACE
    | OPEN_BRACE block_items CLOSE_BRACE
    ;

block_items
    : block_item
    | block_items block_item
    ;

block_item
    : statement
    | declaration
    ;

for_init
    : variable_declaration
    | SEMICOLON
    | exp SEMICOLON
    ;

statement
    : RETURN exp SEMICOLON
    | exp SEMICOLON
    | IF OPEN_PARANTHESES exp CLOSE_PARANTHESES statement %prec THEN
    | IF OPEN_PARANTHESES exp CLOSE_PARANTHESES statement ELSE statement
    | block
    | BREAK SEMICOLON
    | CONTINUE SEMICOLON
    | WHILE OPEN_PARANTHESES exp CLOSE_PARANTHESES statement
    | DO statement WHILE OPEN_PARANTHESES exp CLOSE_PARANTHESES SEMICOLON
    | FOR OPEN_PARANTHESES for_init exp_opt SEMICOLON exp_opt CLOSE_PARANTHESES statement
    | SEMICOLON
    ;

exp_opt
    : /* empty */
    | exp
    ;

exp
    : factor
    | HYPHEN exp %prec UNARY_MINUS
    | TILDE exp %prec UNARY_TILDE
    | NOT exp %prec UNARY_NOT
    | exp PLUS exp
    | exp HYPHEN exp
    | exp ASTERISK exp
    | exp FORWARD_SLASH exp
    | exp PERCENT_SIGN exp
    | exp LAND exp
    | exp LOR exp
    | exp EQUAL exp
    | exp NOTEQUAL exp
    | exp LESSTHAN exp
    | exp LESSTHANEQUAL exp
    | exp GREATERTHAN exp
    | exp GREATERTHANEQUAL exp
    | exp ASSIGNMENT exp
    | exp QUESTION_MARK exp COLON exp
    ;

factor
    : CONSTANT
    | IDENTIFIER
    | OPEN_PARANTHESES exp CLOSE_PARANTHESES
    | IDENTIFIER OPEN_PARANTHESES CLOSE_PARANTHESES
    | IDENTIFIER OPEN_PARANTHESES argument_list CLOSE_PARANTHESES
    ;

argument_list
    : exp
    | argument_list COMMA exp
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

std::vector<scarlet::token::Token> tokens;
size_t current_token_index = 0;

int yylex() {
    // Check if we've processed all tokens
    if (current_token_index >= tokens.size()) {
        return 0;  // Return 0 to indicate EOF
    }

    // Get current token
    scarlet::token::Token& current_token = tokens[current_token_index++];
    scarlet::token::TOKEN token_type = current_token.get_token();
    
    // If token has a value, store it in yylval
    if (auto value = current_token.get_value()) {
        yylval = *value;
    } else {
        yylval = "";
    }

    // Map your token types to Bison token types
    switch (token_type) {
        case scarlet::token::TOKEN::IDENTIFIER:
            return IDENTIFIER;
        case scarlet::token::TOKEN::CONSTANT:
            return CONSTANT;
        case scarlet::token::TOKEN::INT:
            return INT;
        case scarlet::token::TOKEN::STATIC:
            return STATIC;
        case scarlet::token::TOKEN::EXTERN:
            return EXTERN;
        case scarlet::token::TOKEN::VOID:
            return VOID;
        case scarlet::token::TOKEN::RETURN:
            return RETURN;
        case scarlet::token::TOKEN::IF:
            return IF;
        case scarlet::token::TOKEN::ELSE:
            return ELSE;
        case scarlet::token::TOKEN::DO:
            return DO;
        case scarlet::token::TOKEN::WHILE:
            return WHILE;
        case scarlet::token::TOKEN::FOR:
            return FOR;
        case scarlet::token::TOKEN::BREAK:
            return BREAK;
        case scarlet::token::TOKEN::CONTINUE:
            return CONTINUE;
        case scarlet::token::TOKEN::OPEN_PARANTHESES:
            return OPEN_PARANTHESES;
        case scarlet::token::TOKEN::CLOSE_PARANTHESES:
            return CLOSE_PARANTHESES;
        case scarlet::token::TOKEN::OPEN_BRACE:
            return OPEN_BRACE;
        case scarlet::token::TOKEN::CLOSE_BRACE:
            return CLOSE_BRACE;
        case scarlet::token::TOKEN::SEMICOLON:
            return SEMICOLON;
        case scarlet::token::TOKEN::COLON:
            return COLON;
        case scarlet::token::TOKEN::QUESTION_MARK:
            return QUESTION_MARK;
        case scarlet::token::TOKEN::TILDE:
            return TILDE;
        case scarlet::token::TOKEN::HYPHEN:
            return HYPHEN;
        case scarlet::token::TOKEN::PLUS:
            return PLUS;
        case scarlet::token::TOKEN::ASTERISK:
            return ASTERISK;
        case scarlet::token::TOKEN::FORWARD_SLASH:
            return FORWARD_SLASH;
        case scarlet::token::TOKEN::PERCENT_SIGN:
            return PERCENT_SIGN;
        case scarlet::token::TOKEN::ASSIGNMENT:
            return ASSIGNMENT;
        case scarlet::token::TOKEN::NOT:
            return NOT;
        case scarlet::token::TOKEN::LAND:
            return LAND;
        case scarlet::token::TOKEN::LOR:
            return LOR;
        case scarlet::token::TOKEN::EQUAL:
            return EQUAL;
        case scarlet::token::TOKEN::NOTEQUAL:
            return NOTEQUAL;
        case scarlet::token::TOKEN::LESSTHAN:
            return LESSTHAN;
        case scarlet::token::TOKEN::GREATERTHAN:
            return GREATERTHAN;
        case scarlet::token::TOKEN::LESSTHANEQUAL:
            return LESSTHANEQUAL;
        case scarlet::token::TOKEN::GREATERTHANEQUAL:
            return GREATERTHANEQUAL;
        case scarlet::token::TOKEN::COMMA:
            return COMMA;
        default:
            return UNKNOWN;
    }
}