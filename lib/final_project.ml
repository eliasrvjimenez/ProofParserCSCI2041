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
  | Application (e1,e2) ->  
    (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2) ^ " \n"
                  
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
  | Prove (None, i,a,eq, None) -> "Let " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq)
  | Prove (Some p, i,a,eq, None) -> "Let " ^ p ^ " " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq)
  | Prove (Some p, i, a, eq, Some ax) -> "Let " ^ p ^ " " ^ (string_of_expression i) ^ " " ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^ ax
  | Prove (None, i, a, eq, Some ax) -> "Let " ^ (string_of_expression i) ^ " " ^ (string_of_args a) ^ (string_of_equality eq) ^ ax
  
