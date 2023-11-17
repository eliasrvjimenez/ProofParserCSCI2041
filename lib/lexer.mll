{ 
    open Parser
    exception SyntaxError of string
}

let newline = '\r' | '\n' | "\r\n"

rule token = parse
| [' ' '\t']  { token lexbuf } 
| newline { Lexing.new_line lexbuf; token lexbuf } 
| ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '.' ]+ as word 
    { match word with
    | "let" -> LET(word)
    | _ ->  IDENT(word) }  
| "(*hint: axiom *)" {AXIOM}
| "(*prove*)" {PROVE}
| ':' {COLON}
| '(' {LPAREN}
| ')' {RPAREN}
| '*' {STAR}
| '=' {EQUALS}
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf))}
| eof { EOF }


