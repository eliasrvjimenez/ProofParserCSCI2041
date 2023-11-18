include Ast
module Parser = Parser
module Lexer = Lexer

let parse (s : string) : declaration list =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.token lexbuf in
  ast

let rec string_of_expression (e:expression) = 
  match e with 
  | Identifier i -> i
  | Application (e1,e2) ->  "(" ^ 
    (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2) ^ ")"
                  
let rec string_of_args (a: declArgs) = 
    match a with
    | [] -> ""
    | (ah1, ah2) :: atl ->  "(" ^ ah1 ^ ":" ^ ah2 ^ ") " ^ (string_of_args atl)
  
let rec string_of_equality (eq:equality) =
  match eq with
  | Equality (e1, e2) -> (string_of_expression e1) ^ " = " ^ (string_of_expression e2)
  | Is equ -> " = " ^ (string_of_equality equ)

let string_of_declaration (d:declaration) = 
  match d with 
  | Prove (None, None, i,a,eq, None) -> "let " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) (* Regular Declaration *)
  | Prove (Some p, None, i,a,eq, None) -> "let " ^ p ^ " " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) (*Declaration with (*prove*)*)
  | Prove (None, None, i, a, eq, Some ax) -> "let " ^ (string_of_expression i) ^ " " ^ 
  (string_of_args a) ^ (string_of_equality eq) ^ "\n"^ ax (*Declaration with (*hint: axiom*)*)
  | Prove (Some p, None, i, a, eq, Some ax) -> "let " ^ p ^ " " ^ (string_of_expression i) ^ 
    " " ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^ ax (*Declaration with both (*prove*) and (*hint: axiom*)*)
  | Prove (None, Some r, i,a,eq, None) -> "let " ^ r ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) (*Recursive Declaration*)
  | Prove (Some p, Some r, i,a,eq, None) -> "let " ^ r ^ p ^ " " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) (*Recursive Declaration with (*prove*)*)
  | Prove (None, Some r, i, a, eq, Some ax) -> "let " ^ r ^ (string_of_expression i) ^ " " ^ 
  (string_of_args a) ^ (string_of_equality eq) ^ "\n"^ ax (*Recursive Declaration with (*hint: axiom *) *)
  | Prove (Some p, Some r, i, a, eq, Some ax) -> "let " ^ r ^ p ^ " " ^ (string_of_expression i) ^ 
  " " ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^ ax
  
