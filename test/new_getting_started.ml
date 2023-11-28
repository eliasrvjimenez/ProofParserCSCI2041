(* testing to see that the prover can output ??? steps *)
let (*prove*) cf_idempotent (x : int) = (cf (cf x) = cf x)
let (*prove*) inv_involution (x : int) = (inv (inv x) = x)
let (*prove*) cf_inv_commute (x : int) = (cf (inv x) = inv (cf x))
(* okay let's assume these things instead,
   this should not be necessary since they were just proved,
   but with a broken prover it's better to be safe then sorry *)
let (*prove*) cf_idempotent (x : int) = (cf (cf x) = cf x)
(*hint: axiom *)
let (*prove*) inv_involution (x : int) = (inv (inv x) = x)
(*hint: axiom *)
let (*prove*) cf_inv_commute (x : int) = (cf (inv x) = inv (cf x))
(*hint: axiom *)
let (*prove*) cf_inv_property (h : int) = (cf (inv (cf (inv h))) = cf h)