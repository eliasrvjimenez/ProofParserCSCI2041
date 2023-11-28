%{
    open Ast
%}
%token <string> IDENT
%token LPAREN
%token RPAREN
%token EOF
%token EQUALS
%token COLON
%token VERT
%token STAR
%token <string> TYPE
%token <string> OF
%token <string> PROVE
%token <string> AXIOM
// %token <string> LEMMA
// %token <string> IND
%token <string> LET
%token <string> REC

%start main
%type <declaration list> main
%type <expression> expression
%type <equality> equality
%type <declArgs> declArgs
%type <hint> hint


%%

main:
    | d = list(declaration); EOF { d }
declaration:
    // Prove of (string option * string option * expression * declArgs * equality * hint)
    | LET; i = IDENT; a = list(declArgs); eq=equality { Prove (None, None, i,a,eq, None) } // Basic Declaration
    | LET; p = PROVE; i = IDENT; a = list(declArgs); eq = equality; { Prove (Some p, None, i, a, eq, None) } // Declaration with (*prove*)
    | LET; i = IDENT; a= list(declArgs); eq = equality; h = hint { Prove (None, None, i, a, eq, h)} // Declaration with (*hint: axiom *)
    | LET; p = PROVE; i = IDENT; a= list(declArgs); eq = equality; h = hint { Prove (Some p, None, i, a, eq, h)} // Declaration with both (*prove*) and (*hint: axiom*)
    | LET; r = REC; i = IDENT; a = list(declArgs); eq=equality { Prove (None, Some r, i,a,eq, None) } // Recursive Declaration
    | LET; r = REC; i = IDENT; a= list(declArgs); eq = equality; h= hint { Prove (None, Some r, i, a, eq, h)} // Recursive Declaration with (*prove*)
    | LET; r = REC; p = PROVE; i = IDENT; a = list(declArgs); eq = equality; { Prove (Some p, Some r, i, a, eq, None) } // Recursive Declaration with (*hint: axiom *)
    | LET; r = REC; p = PROVE; i = IDENT; a= list(declArgs); eq = equality; h = hint { Prove (Some p, Some r, i, a, eq, h)} // Recursive Declaration with both (*prove*) and (*hint: axiom*)
    | TYPE; i = IDENT; EQUALS; a = list(declArgs); { Type (i, a)}
declArgs:
    | LPAREN; v1 = IDENT; COLON; v2 = IDENT; RPAREN  { Variable (v1,v2) }
    | v = expression  { Variant v }
    | VERT; v = expression  { Variant v }
    | VERT; v1 = expression; OF; LPAREN; v2 = expression; RPAREN { VariantOf (v1,v2) }
    | VERT; v1 = expression; OF; v2 = expression { VariantOf (v1, v2) }
expression:
    | LPAREN; e = expression ; RPAREN { e }
    | i = IDENT { Identifier i }
    | e1 = expression; e2 = expression { Application (e1, e2) }
    | LPAREN; e1 = expression; e2 = expression; RPAREN { ApplicationWithParentheses (e1,e2)}
    | e1 = expression; STAR;  e2 = expression { Tuple (e1, e2) }
equality:
    | EQUALS; e1 = expression; EQUALS; e2=expression { Equality (e1, e2) }
    | e1 = expression; EQUALS; e2=expression { Equality (e1, e2) }
    | LPAREN; e1 = expression; EQUALS; e2=expression; RPAREN { Equality (e1,e2) }
    | EQUALS; LPAREN; e1 = expression; EQUALS; e2=expression; RPAREN { Equality (e1,e2) }
hint:
    | a = AXIOM { Some a }
    // | l = LEMMA { Some l }
    // | i = IND { Some i }
;
