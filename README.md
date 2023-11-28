# Proof Parser for CSCI 2041 #

### Created by Elias Vera-Jimenez & Dylan Ringer ###

What we have so far: 

--printback:
 - Parses through the entirety of getting_started.ml and moreproofs.ml
 - Can parse through our ast.ml, which means it can parse types, but not a constructor with more than 2 arguments.

--simple:
 - can generate something like: 
 ```ocaml 
 Proof of fooxy : 
    foo x y 
 ```
 but any of the actual proof steps still need to be implemented.

## Current Types:

So far in our ast we have:
 - expression with 4 constructors, 
   - Identifier, which is used for loose variables in an application or equality. 
   - Application, which is used for when there are two or more expressions with no other characters between them: `foo x`. 
   - ApplicationWithParentheses: pretty straight forward, Applications that are surrounded with parentheses. `(foo x)`.
   - Tuple, expressions with a `*` between them. used in type declarations.
 - equality with one constructor.
   - Equality, which takes two expressions. similar to application but when there is an equals sign between them (`foo x = x`) or in front of them (`= foo x`). 
 - declArgs, with 3 constructors.
   - Variable, which is two strings separated by a `:`, which looks like `(x : int)`.
   - Variant, which just takes an expression, is an identifier used in types. `| Constructor`
   - VariantOf, which is a variant with args. doens't work well with more than 2 args. `| Constructor of expression` or `| Constructor of expression * expression`.
 - hint, which is a type of string option, for hints. `(*hint: axiom *)`
 - declaration, which has 2 constructors. 
   - Prove, a declaration which takes 6 arguments. 2 string options, representing whether there is a `rec` and/or a  `(*prove*)`. a string representing the name of the declaration (`fooxy` in moreproofs.ml), declArgs list, which is a list of arguments `(x: int) .... `, an equality, since declarations equal something (`= foo x y = x` in moreproofs.ml), and a hint, which can either exist or not exist (`(* hint: ____*)`).
   - Type, for type declarations. takes a string representing the name (`expression` in ast.ml) and a declArgs list, which contains the constructors of the type. `| Constructor`, or `| Construtor of ....`. 
    