include Ast

module Parser = Parser
module Lexer = Lexer

let parse (s: string): declaration list =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.token lexbuf in
  ast

let rec string_of_pattern (p: pattern) : string = 
  match p with 
  | Constructor (name, []) -> name
  | Constructor (name, patterns) -> name ^ " (" ^ (String.concat "," (List.map string_of_pattern patterns)) ^ ")"
  