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
          ("false", FALSE) ; ("init", INIT) ; ("new", NEW)]

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
  let m = (String.sub s 0 ((String.length s) - 1)) ^ "$" in (*Replace : with $ *)
    try Hashtbl.find kwtable m with 
      Not_found -> 
        Hashtbl.replace idtable m ();
        MESSAGE m


(* |get_vars| -- get list of identifiers in the program *)
let get_vars () = 
  Hashtbl.fold (fun k () ks -> k::ks) idtable []


let currLine = ref 1

}

let letter = ['A'-'Z''a'-'z']
let up_letter = ['A'-'Z']
let digit = ['0'-'9']

rule token = 
  parse
      letter (letter | digit | '_' | '/')* as s
                        { lookup s }
    | letter (letter | digit | '_')*":" as s
                        { messagelookup s }
    | digit+ as s
                        { NUMBER (int_of_string s) }
    | "["               { LPAR }
    | "]"               { RPAR }
    | "="               { EQUAL }
    | "+"               { PLUS }
    | "-"               { MINUS }
    | "*"               { TIMES }
    | "/"               { DIVIDE }
    | ";"               { SEMI }
    | "^"               { RETURN }
    | [' ''\t']+        { token lexbuf }
    | "\n"              { incr currLine; token lexbuf}
    | eof               { EOF }
    