%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token STAR
%token EOF
%token EQUALS

%start main
%type <expression list> main
%type <expression> expression
%type <equality> equality

%%

main:
    | e = expression EOF { [e] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i } (* TODO *)
    | e1 = expression; e2 = expression { Application (e1, Tuple [e2]) }
equality:
    | eq1 = expression; EQUALS; eq2 = expression { Equality (eq1, eq2)}

%%
