open Ast
module Substitution = struct
  type substitution = (string * expression)
  type subs_list = substitution list
  let empty = []
  let singleton x y = [(x,y)]
  let merge s1 s2 =
    match s1 with 
    | [] -> Some s2
    | _ -> Some s1
end

