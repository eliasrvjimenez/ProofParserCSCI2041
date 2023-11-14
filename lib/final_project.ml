include Ast

module Parser = Parser
module Lexer = Lexer

let rec string_of_expression (e:expression) = 
  match e with 
  | Identifier i -> i
  | Application (e1,e2) ->  
    "(" ^ (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2) ^ ")"

let rec string_of_equation (e: equation) = 
  "( TODO )"
  

