%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token STAR
%token EOF
%token EQUALS
%token <string> AXIOM
%token <string> LET

%start main
%type <expression list> main
%type <expression> expression

%%

main:
    | e = expression EOF { [e] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i } (* TODO *)
    | e1 = expression; e2 = expression { Application (e1, e2) } 

%%
