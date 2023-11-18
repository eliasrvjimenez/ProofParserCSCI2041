%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token EOF
%token EQUALS
%token COLON
%token <string> PROVE
%token <string> AXIOM
%token <string> LET
%token <string> REC

%start main
%type <declaration list> main
%type <expression> expression
%type <equality> equality
%type <declArgs> declArgs


%%

main:
    | d = list(declaration); EOF { d }
declaration:
    | LET; i = expression; a = declArgs; eq=equality { Prove (None, None, i,a,eq, None) } // Basic Declaration
    | LET; p = PROVE; i = expression; a = declArgs; eq = equality; { Prove (Some p, None, i, a, eq, None) } // Declaration with (*prove*)
    | LET; i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (None, None, i, a, eq, Some ax)} // Declaration with (*hint: axiom *)
    | LET; p = PROVE; i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (Some p, None, i, a, eq, Some ax)} // Declaration with both (*prove*) and (*hint: axiom*)
    | LET; r = REC; i = expression; a = declArgs; eq=equality { Prove (None, Some r, i,a,eq, None) } // Recursive Declaration
    | LET; r = REC; i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (None, Some r, i, a, eq, Some ax)} // Recursive Declaration with (*prove*)
    | LET; r = REC; p = PROVE; i = expression; a = declArgs; eq = equality; { Prove (Some p, Some r, i, a, eq, None) } // Recursive Declaration with (*hint: axiom *)
    | LET; r = REC; p = PROVE; i = expression; a= declArgs; eq = equality; ax = AXIOM { Prove (Some p, Some r, i, a, eq, Some ax)} // Recursive Declaration with both (*prove*) and (*hint: axiom*)
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
