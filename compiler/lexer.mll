{
open Parser 
open Lexing

(* |make_hash| -- create hash table from list of pairs *)
let make_hash n ps =
  let t = Hashtbl.create n in
  List.iter (fun (k, v) -> Hashtbl.add t k v) ps;
  t

(* |kwtable| -- a little table to recognize keywords *)
let kwtable = 
    make_hash 64
        [ ("subclass$", SUBCLASS); ("category$", CATEGORY);
          ("vars$", VARNAMES) ; ("true", TRUE);
          ("false", FALSE) ; ("init", INIT) ; ("new", NEW) ; ("whileTrue$", WHILETRUE)]

(* |idtable| -- table of all identifiers seen so far *)
let idtable = Hashtbl.create 64

(* |lookup| -- convert string to keyword or identifier *)
let lookup s = 
  try Hashtbl.find kwtable s with 
    Not_found -> 
      Hashtbl.replace idtable s ();
      IDENT s

(* |message_lookup| -- convert string to message *)
let messagelookup s =
  let m = s ^ "$" in
    try Hashtbl.find kwtable m with 
      Not_found -> 
        Hashtbl.replace idtable m ();
        MESSAGE m

(* |block_var_lookup| -- convert string to message *)
let block_var_lookup s =
    try Hashtbl.find kwtable s with 
      Not_found -> 
        Hashtbl.replace idtable s ();
        BVAR s

(* |get_vars| -- get list of identifiers in the program *)
let get_vars () = 
  Hashtbl.fold (fun k () ks -> k::ks) idtable []


let currLine = ref 1

}

let letter = ['A'-'Z''a'-'z']
let up_letter = ['A'-'Z']
let digit = ['0'-'9']

let q = '\''
let qq = '"'
let char1 = [^'\'']
let char2 = [^'"']
rule token = 
  parse 
    | letter (letter | digit | '_' | '/')* as s
                        { lookup s }
    | (letter (letter | digit | '_')* as s)":"
                        { messagelookup s }
    | ":"(letter (letter | digit | '_')* as s)
                        { block_var_lookup s}
    | digit+ as s
                        { NUMBER (int_of_string s) }
    | q (char1 as c) q  { CHAR c }
    | q q q q           { CHAR '\'' }
    | qq ((char2 | qq qq)* as s) qq
                        { STRING s }
    | "("               { LPAR }
    | ")"               { RPAR }
    | "["               { LBAR }
    | "]"               { RBAR }
    | "="               { EQUAL }
    | "+"               { PLUS }
    | "++"              { CONCAT }
    | "-"               { MINUS }
    | "*"               { TIMES }
    | "/"               { DIVIDE }
    | "&&"              { AND }
    | "!"               { NOT }
    | "||"              { OR }
    | "<"               { LT }
    | "<="              { LEQ }
    | ">"               { GT }
    | ">="              { GEQ }
    | "=="              { EQ }
    | "!="              { NEQ }
    | ";"               { SEMI }
    | "^"               { RETURN }
    | "|"               { BAR }
    | [' ''\t']+        { token lexbuf }
    | "\n"              { incr currLine; token lexbuf}
    | eof               { EOF }
    