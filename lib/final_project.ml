include Ast

module Parser = Parser
module Lexer = Lexer

let rec string_of_expression (e:expression) = 
  match e with 
  | Identifier i -> i
  | Application (e1,e2) ->  
    "(" ^ (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2) ^ ")"
  | Tuple e  -> (match e with 
                | [] -> ""
                | eh :: [] -> string_of_expression eh
                | eh :: etl -> (string_of_expression eh) ^ " " ^ (string_of_expression (Tuple etl)))
