include Ast
include String_of
module Parser = Parser
module Lexer = Lexer

let parse (s : string) : declaration list =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.token lexbuf in
  ast

let parse2 (s : string) : expression =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main2 Lexer.token lexbuf in
  ast

let string_of_expression = String_of.string_of_expression

let string_of_args = String_of.string_of_args


let string_of_equality = String_of.string_of_equality

let string_of_hint = String_of.string_of_hint

let string_of_declaration = String_of.string_of_declaration

let string_of_simple_proof (d:declaration) = 
  match d with
  | Prove(_, _, i, _, eq, _) -> "Proof of " ^ i ^ ":\n" ^ 
          (match eq with 
            | Equality (e1, _) -> (string_of_expression e1)
          ) ^ "\n"
  | Type(_, _) -> "NO TYPE PROOFS YET."
  | Expression e -> string_of_expression e

let empty = []
let singleton x y = [(x,y)]

let merge s1 s2 = 
  match s1 with
  | [] -> Some s2 (*should be removable after case _ is fixed *)
  | _ -> Some s1 (*todo: fix*)

let rec test_for_var (v: string)  (vlst : string list) = 
  match vlst with
  | [] -> false
  | h :: tl -> if v = h then true else  test_for_var v tl

let rec match_expression v p e = 
  match p with 
  | Identifier x -> if test_for_var x v then 
    Some (singleton x e )
    else ( if p = e then Some empty else None)
  | Application (p1,p2) -> 
    (match e with
      | Application (e1, e2) -> 
        (match match_expression v p1 e1, match_expression v p2 e2 with
          | Some s1, Some s2 -> merge s2 s1
          | _ -> None )
      | ApplicationWithParentheses (e1, e2) -> 
        (match match_expression v p1 e1, match_expression v p2 e2 with
          | Some s1, Some s2 -> merge s2 s1
          | _ -> None )
      | _ -> None)
  | ApplicationWithParentheses (p1,p2) -> 
    (match e with
      | ApplicationWithParentheses (e1, e2) -> 
        (match match_expression v p1 e1, match_expression v p2 e2 with
          | Some s1, Some s2 -> merge s2 s1
          | _ -> None )
      | Application (e1, e2) -> 
        (match match_expression v p1 e1, match_expression v p2 e2 with
          | Some s1, Some s2 -> merge s2 s1
          | _ -> None )
      | _ -> None)
  | _ -> None


  let find x s = match s with
  | [] -> failwith "Not found (find was passed an empty list)"
  | [(k,v)] -> if x = k then v else failwith "Not found (find failed but the substitution being passed in really does not contain the variable)"
  | _ -> failwith "Find failed (key not found because this part of the find function is utterly broken)"


let rec substitute v s e = match e with
  | Identifier "x" -> find "x" s
  | Application (e1, e2) -> Application (substitute v s e1, substitute v s e2)
  | ApplicationWithParentheses (e1, e2) -> ApplicationWithParentheses (substitute v s e1, substitute v s e2)
  | _ -> e

let rec attempt_rewrite var lhs rhs exp =
  match match_expression var lhs exp with 
  | Some s -> Some (substitute var s rhs)
  | None -> (match exp with 
              | Application (e1, e2) -> (match attempt_rewrite var lhs rhs e2 with
                                          | None -> None (* todo: fix*)
                                          | Some e2' -> Some (Application (e1, e2')))
              | ApplicationWithParentheses (e1, e2) -> (match attempt_rewrite var lhs rhs e2 with
                                                        | None -> None (* todo: fix*)
                                                        | Some e2' -> Some (ApplicationWithParentheses (e1, e2')))
              | _ -> None (* not successful *)
              )

let rec perform_step r exp = match r with
 | (var, nm, lhs, rhs) :: _ :: rest -> 
  (match attempt_rewrite var lhs rhs exp with
    | Some e -> Some (nm, e) 
    | _ -> perform_step rest exp)
 | _ -> None

let rec perform_steps r exp = match perform_step r exp with
 | Some (nm, e) -> (nm, e) :: perform_steps [] e
 | None -> []

let rec prove r lhs rhs = 
  String_of.string_of_expression lhs :: 
  ( match perform_steps r lhs with 
    | (nm, e) :: _ -> (" = { " ^ nm ^  " }") :: prove r e rhs
    | [] -> if lhs = rhs then [] else " = {???}" :: [String_of.string_of_expression rhs])

let rec var_separator vars = 
  match vars with 
  | [] -> []
  | h :: tl -> (match h with
                | Variable (v1, _) -> v1
                | _ -> ""
              ) :: var_separator tl 
let rec prover r decls = 
  match decls with
  | Prove (_, _, nm,  vars, Equality (lhs, rhs), None) :: rest -> (* No hint, needs to be proved. *)
                                                                  prove r lhs rhs :: prover (((var_separator vars), nm, lhs, rhs) :: r) rest
  | Prove (_, _, nm, vars, Equality (lhs, rhs), _) :: rest -> (*Hint exists,  can be assumed.*) prover (((var_separator vars), nm, lhs, rhs) :: r) rest
  | _ :: rest -> prover r rest
  | [] -> []

let prover_main decls = 
  prover [] decls |> 
  List.map (String.concat "\n" ) |>
  String.concat "\n\n" |>
  print_endline