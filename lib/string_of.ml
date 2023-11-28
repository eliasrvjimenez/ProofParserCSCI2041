include Ast
let rec string_of_expression (e:expression) = 
  match e with 
  | Identifier i -> i
  | Application (e1,e2) -> 
    (string_of_expression e1) ^ 
    " " ^ (string_of_expression e2)
  | ApplicationWithParentheses (e1,e2) -> "(" ^ (string_of_expression e1) ^ 
  " " ^ (string_of_expression e2) ^ ")" 
  | Tuple (e1, e2) -> (string_of_expression e1) ^ " * " ^ (string_of_expression e2)


let rec string_of_args (a: declArgs list) = 
  match a with
  | [] -> ""
  | ah :: atl -> (match ah with
                  | Variable (v1,v2) -> "(" ^ v1 ^ " : " ^ v2 ^ ") "
                  | VariantOf (v1,v2) -> "| " ^ (string_of_expression v1) ^ " of (" ^ (string_of_expression v2) ^ ")\n"
                  | Variant v -> "| " ^ (string_of_expression v) ^ "\n" ) ^ string_of_args atl


let string_of_equality (eq:equality) =
  match eq with
  | Equality (e1, e2) -> (string_of_expression e1) ^ " = " ^ (string_of_expression e2)

let string_of_hint (h:hint) = 
  match h with 
  | None -> ""
  | Some h -> h ^ "\n"

let string_of_declaration (d:declaration) = 
  match d with 
  | Prove (None, None, i,a,eq, h) -> "let " ^ i ^ " " 
      ^ (string_of_args a) ^ "= " ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h) (* Regular Declaration *)
  | Prove (Some p, None, i,a,eq, h) -> "let " ^ p ^ " " ^ i ^ " " 
      ^ (string_of_args a) ^ "= " ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h) (*Declaration with (*prove*)*)
  | Prove (None, Some r, i,a,eq, h) -> "let " ^ r ^ i ^ " " 
      ^ (string_of_args a) ^ "= " ^ (string_of_equality eq) ^ "\n" ^ (string_of_hint h)  (*Recursive Declaration*)
  | Prove (Some p, Some r, i,a,eq, h) -> "let " ^ r ^ p ^ " " ^ "\n" ^ i ^ " " 
      ^ (string_of_args a) ^ "= " ^ (string_of_equality eq) ^ "\n" ^(string_of_hint h)(*Recursive Declaration with (*prove*)*)
  | Type (i, a) -> "type " ^ i ^ "= " ^  "\n" ^ (string_of_args a)
  | Expression e -> string_of_expression e
