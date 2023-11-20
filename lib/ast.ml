type expression =
  | Identifier of string
  | Application of expression * expression

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs =
  | Variables of (string * string) list (* for declarations of type Prove *) 
  (* | Variant of string *)
  | VariantOf of (string * string) list (* for declarations of type Type *)

type hint = string option

type declaration = 
  | Prove of (string option * string option * string * declArgs * equality * hint) (* let rec ... = *)
  | Type of (string * declArgs) (* type ... = *)



