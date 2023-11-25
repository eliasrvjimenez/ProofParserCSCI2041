{ 
    open Parser
    exception SyntaxError of string
}

let newline = "\r" | "\n" | "\r\n"

rule token = parse
| [' ' '\t']  { token lexbuf } 
| ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '.' '-']+ as word 
    { match word with
    | "let" -> LET(word)
    | "rec" -> REC(word)
    | "type" -> TYPE(word)
    | "of" -> OF(word)
    | _ ->  IDENT(word) }  
| "(*prove*)" as proof{PROVE(proof)} 
| "(*hint: axiom *)" as axiom {AXIOM(axiom)}
(* | "(*hint: lemma " ^ ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '.' '-']+ ^" *)" as lemma {LEMMA(lemma)} 
| "(*hint: induction "^['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '.' '-']+ ^ " *)" as induction {IND(induction)} *)
| ':' {COLON}
| '(' {LPAREN}
| ')' {RPAREN}
| '=' {EQUALS}
| '|' {VERT}
|"(*" { comment 1 lexbuf }
| "*" {STAR}
| newline { Lexing.new_line lexbuf; token lexbuf}
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf))}
| eof { EOF }

and comment level = parse
| "*)" { if level > 1 then  comment (level - 1) lexbuf
         else token lexbuf}
| "(*" {comment (level + 1) lexbuf}
| newline {Lexing.new_line lexbuf; comment level lexbuf}
| eof {raise (SyntaxError ("Unterminated Comment, please add a *)")) }
| _ {comment level lexbuf}


