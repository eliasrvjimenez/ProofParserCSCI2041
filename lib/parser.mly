%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token STAR
%token EOF
%token EQUALS

%start <expression list> main

%%

main:
    | e = expression EOF { [e] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i } (* TODO *)
    | e1 = expression; e2 = expression { Application (e1,e2) }
    | e1 = expression; EQUALS; e2=expression { Equation (e1, e2)}
    | LPAREN; STAR; c = expression ; STAR; RPAREN { Comment c }
    ;
