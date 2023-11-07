type declaration =
  | Constructor of declaration
  | Identity of string 
  | LeftParen
  | RightParen
  | Colon

type pattern = 
  | Constructor