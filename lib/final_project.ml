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



let string_of_args (a: declArgs) = 
  let rec apply_args (lst:(string * string) list) (char1: string) (char2:string) (char3:string) = 
    match lst with 
    | [] -> ""
    | (v1, v2) :: vtl -> char1 ^ v1 ^ char2 ^ v2 ^ char3 ^ (apply_args vtl char1 char2 char3) in
  match a with
  | Variables v -> apply_args v "(" " : " ")"
  | VariantOf v -> apply_args v "\n|" " of " ""


let rec string_of_equality (eq:equality) =
  match eq with
  | Equality (e1, e2) -> (string_of_expression e1) ^ " = " ^ (string_of_expression e2)
  | Is equ -> " = " ^ (string_of_equality equ)

  let string_of_hint (h:hint) = 
    match h with 
    | None -> ""
    | Some h -> h

let string_of_declaration (d:declaration) = 
  match d with 
  | Prove (None, None, i,a,eq, h) -> "let " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h) (* Regular Declaration *)
  | Prove (Some p, None, i,a,eq, h) -> "let " ^ p ^ " " ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h) (*Declaration with (*prove*)*)
  | Prove (None, Some r, i,a,eq, h) -> "let " ^ r ^ (string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^ (string_of_hint h)  (*Recursive Declaration*)
  | Prove (Some p, Some r, i,a,eq, h) -> "let " ^ r ^ p ^ " " ^ "\n" ^(string_of_expression i) ^ " " 
      ^ (string_of_args a) ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h)(*Recursive Declaration with (*prove*)*)
  | Type (i, a) -> "type " ^ i ^ " = " ^  "\n" ^ (string_of_args a)
