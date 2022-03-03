type ident = string

type codelab = int

val label : unit -> codelab

(* |def| -- definitions in environment *)
type def = 
  { d_tag : ident;              (* Name *)
    d_kind : def_kind;          (* Definition *)
    d_level : int;              (* Nesting level *)
    d_lab : string;             (* Label if global *)
    d_off : int }               (* Offset if local *)

and def_kind =
    VarDef                      (* Variable *)
  | LocalDef                    (* Parameter *)
type environment

type lab_set =
  { l_lab1 : int;
    l_lab2 : int;
    l_lab3 : int }

(* |define| -- add a definition, raise Exit if already declared *)
val define : def -> environment -> environment

(* |lookup| -- search an environment or raise Not_found *)
val lookup : ident -> environment -> def

(* |new_block| -- add new block to top of environment *)
val new_block : environment -> environment

(* |empty| -- initial empty environment *)
val empty : environment
