type ident = string

type codelab = int

(* |lab| -- last used code label *)
let lab = ref 0

(* |label| -- allocate a code label *)
let label () = incr lab; !lab

(* |def| -- definitions in environment *)
type def = 
  { d_tag : ident;              (* Name *)
    d_kind : def_kind;          (* Definition *)
    d_off : int }               (* Offset if local *)

and def_kind =
    InstanceVarDef              (* Instance variable *)
  | ClassVarDef                 (* Class variable *)
  | LocalDef                    (* Local variable/param *)
  | MessageDef                  (* Message declaration *)

type lab_set =
  { l_lab1 : int;
    l_lab2 : int;
    l_lab3 : int }

let find_def x k ds =
  let rec search =
    function
        [] -> raise Not_found
      | d::ds -> 
          if (x = d.d_tag && k = d.d_kind) then d else search ds in
  search ds

module IdMap = Map.Make(struct type t = ident  let compare = compare end)

type environment = Env of def list * def IdMap.t

let can f x = try f x; true with Not_found -> false

(* |define| -- add a definition *)
let define d (Env (b, m)) = 
  if can (find_def d.d_tag d.d_kind) b then raise Exit;
  Env (d::b, IdMap.add d.d_tag d m)

(* |lookup| -- find definition of an identifier *)
let lookup x (Env (b, m)) = IdMap.find x m

(* |empty| -- empty environment *)
let empty = Env ([], IdMap.empty)

(* |new_block| -- add new block *)
let new_block (Env (b, m)) = Env ([], m)
