#include "parser.tab.c"
#include <lexer/lexer.hh>
#include <token/token.hh>
#include <memory>

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

std::vector<scarlet::token::Token> tokens;
size_t current_token_index = 0;

void get_tokens(std::string file_path){
    std::unique_ptr<scarlet::lexer::lexer> lexer = std::make_unique<scarlet::lexer::lexer>();
    lexer->set_file_path(std::move(file_path));
    lexer->tokenize();
    tokens = lexer->get_tokens();
    std::cout << "GOT THEM SWEET TOKENS :))))" << std::endl;
}

int yylex() {
    // Check if we've processed all tokens
    if (current_token_index >= tokens.size()) {
        return 0;  // Return 0 to indicate EOF
    }

    // Get current token
    scarlet::token::Token& current_token = tokens[current_token_index++];
    scarlet::token::TOKEN token_type = current_token.get_token();

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
            return -1;
    }
}

int main(){
    get_tokens("input.cc");

    yyparse();
    return 0;
}
