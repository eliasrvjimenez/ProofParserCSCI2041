%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token EOF

%start <expression list> main

%%

main:
    | e = expression EOF { [e] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i } (* TODO *)
    | e1 = expression; e2 = expression { Application (e1,e2) }
    ;
