(* |token| -- scan the next token *)
val token : Lexing.lexbuf -> Parser.token

val currLine : int ref
