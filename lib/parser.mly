%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
// %token STAR
%token EOF
%token EQUALS
%token COLON
%token <string> PROVE
%token <string> AXIOM
%token <string> LET

%start main
%type <declaration list> main
%type <expression> expression
%type <equality> equality
%type <declArgs> declArgs


%%

main:
    | d = declaration EOF { [d] }
declaration:
    | LET; p = PROVE; i = expression; a = declArgs; eq = equality; { Prove (Some p, i, a, eq, None) }
    | LET; i = expression; a = declArgs; eq=equality { Prove (None, i,a,eq, None) }
    | LET; p = PROVE; i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (Some p, i, a, eq, Some ax)}  
    | LET;  i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (None, i, a, eq, Some ax)}  
declArgs:
    | LPAREN; a1 = IDENT; COLON; a2 = IDENT; RPAREN { [(a1,a2)] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i }
    | e1 = expression; e2 = expression { Application (e1, e2) }
equality:
    | EQUALS; e=equality { Is e }
    | LPAREN; e1 = expression; EQUALS; e2=expression; RPAREN { Equality (e1, e2) }
;
