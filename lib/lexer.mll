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
    | _ ->  IDENT(word) }  
| "(*prove*)" as proof{PROVE(proof)} 
| "(*hint: axiom *)" as axiom {AXIOM(axiom)}
| ':' {COLON}
| '(' {LPAREN}
| ')' {RPAREN}
| '=' {EQUALS}
|"(*" { comment lexbuf }
| newline { Lexing.new_line lexbuf; token lexbuf}
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf))}
| eof { EOF }

and comment = parse
| "*)" {token lexbuf}
| "(*" {comment lexbuf}
| newline {Lexing.new_line lexbuf; comment lexbuf}
| eof {raise (SyntaxError ("Unterminated Comment, please add a *)")) }
| _ {comment lexbuf}


