%{
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

