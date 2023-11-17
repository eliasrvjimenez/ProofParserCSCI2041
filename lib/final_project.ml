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
    "(" ^ (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2) ^ ") \n"
  | Proof p -> match p with
                | None -> ""
                | Some p -> p
  | Axiom a -> match a with 
                | None -> ""
                | Some a -> a
                  
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
  | Prove (p,i,a,eq) -> "Let " ^ (string_of_expression p) ^ (string_of_expression i) ^ " " 
  ^ (string_of_args a) ^ (string_of_equality eq)
  
