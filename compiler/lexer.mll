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
           ("vars$", VARNAMES) ; ("true", TRUE); ("perform$", PERFORM) ; (* ("withArguments$", WITHARGUMENTS) ; *)
          ("false", FALSE) ; ("init", INIT) ; ("new", NEW) ; ("new$", NEWWITHARG) ;
          ("whileTrue$", WHILETRUE) ; ("ifTrue$", IFTRUE) ; ("else$", ELSE) ; ("Array", ARRAY)]

(* |idtable| -- table of all identifiers seen so far *)
let idtable = Hashtbl.create 64

(* |simple_up_lookup| -- convert capital-starting string to keyword or identifier *)
let simple_up_lookup s = 
  try Hashtbl.find kwtable s with 
    Not_found -> 
      Hashtbl.replace idtable s ();
      GLOBIDENT s

(* |up_lookup| -- convert capital-starting string with a path to keyword or identifier *)
let up_lookup s = 
  try Hashtbl.find kwtable s with 
    Not_found -> 
      Hashtbl.replace idtable s ();
      PATHEDGLOBIDENT s

(* |up_lookup| -- convert non-capital-starting string to keyword or identifier *)
let low_lookup s = 
  try Hashtbl.find kwtable s with 
    Not_found -> 
      Hashtbl.replace idtable s ();
      IDENT s


(* |message_lookup| -- convert string to message *)
let message_lookup s =
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
let low_letter = ['a' - 'z']
let digit = ['0'-'9']

let q = '\''
let qq = '"'
let char1 = [^'\'']
let char2 = [^'"']
rule token = 
  parse
    | up_letter (letter | digit | '_')* as s
                        { simple_up_lookup s} (*Global names with no path, eg Colour *)
    | (((letter | digit | '_')+ '/')+ (up_letter (letter | digit | '_')*)) as s
                        { up_lookup s } (*Global names involving a path. eg examples/Main*)
    | low_letter (letter | digit | '_')* as s
                        { low_lookup s }
    | (letter (letter | digit | '_')* as s)":"
                        { message_lookup s }
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
    | "#"               { HASH }
    | "="               { EQUAL }
    | "+"               { PLUS }
    | "++"              { CONCAT }
    | "-"               { MINUS }
    | "*"               { TIMES }
    | "/"               { DIVIDE }
    | "%"               { MOD }
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
    | "`"               { comment lexbuf; token lexbuf }
    | "\n"              { incr currLine; token lexbuf }
    | _                 { BADTOK}
    | eof               { EOF }
    
and comment = 
  parse 
      "`"               { () }
    | "\n"              { incr currLine; token lexbuf; comment lexbuf }
    | _                 {comment lexbuf}