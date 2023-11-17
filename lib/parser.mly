%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token STAR
%token EOF
%token EQUALS
%token COLON
%token <string>PROVE
%token <string>AXIOM
%token <string> LET

%start main
%type <declaration list> main
%type <expression> expression
%type <string> comment
%type <equality> equality
%type <declArgs> declArgs

%%

main:
    | d = declaration EOF { [d] }
declaration:
    | LET; p = expression; i = IDENT; a = declArgs; eq = equality { Prove (p, i, a, eq) }  
declArgs:
    | LPAREN; a1 = IDENT; COLON; a2 = IDENT; RPAREN { [(a1,a2)] }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i }
    | e1 = expression; e2 = expression { Application (e1, e2) }
    | p = PROVE { Proof (Some p) } 
    | a = AXIOM { Axiom (Some a) }
equality:
    | EQUALS; e=equality { Is e }
    | e1 = expression; EQUALS; e2=expression { Equality (e1, e2) }
comment:
    | LPAREN; STAR; c=comment; STAR; RPAREN { c }

%%
