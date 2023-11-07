%{
    open Ast
%}
%token EOF
%token <declaration> IDENT
%token COLON
%token LPAREN
%token RPAREN

%start <Ast.declaration> prog

%%

prog:
    | d = declaration; EOF { d }
    ;

declaration:
    | i = IDENT { i } (* TODO *)
    ;