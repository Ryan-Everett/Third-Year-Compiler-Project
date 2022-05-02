open Print 
open Jvm
open Tree 
open Dict 
(*Semantic analysis
  Assigns labels for paramaters and local vars.

  Since the language is dynamically typed we cannot check for type safety here

*)



(* |err_line| -- line number for error messages *)
let err_line = ref 1

let curr_lab = ref 1

(* |Semantic_error| -- exception raised if error detected *)
  exception Semantic_error of string * Print.arg list * int

(* |sem_error| -- issue error message by raising exception *)
let sem_error fmt args = 
  raise (Semantic_error (fmt, args, !err_line))

(* |add_def| -- add definition to env, give error if already declared *)
  let add_def d env =
    try define d env with 
      Exit -> sem_error "$ is already declared" [fStr d.d_tag]

(* |declare_inst_var| -- declare an instance variable *)
let declare_inst_var x off env =
  let d = { d_tag = x; d_kind = InstanceVarDef; d_off = off } in
    add_def d env

(* |declare_class_var| -- declare a class variable *)
let declare_class_var x off env =
  let d = { d_tag = x; d_kind = ClassVarDef; d_off = off } in
    add_def d env

(* |declare_local| -- declare a local *)
let declare_local x off env =
  let d = { d_tag = x; d_kind = LocalDef; d_off = off } in
    add_def d env

(* |declare_message| -- declare a message *)
let declare_message m env =
  let d = { d_tag = m.m_full_name; d_kind = MessageDef; d_off = -1} in
    add_def d env

(* |has_value| -- check if object is suitable for use in expressions *)
  let has_value d = 
    match d.d_kind with
        InstanceVarDef -> true 
      | ClassVarDef -> true
      | LocalDef -> true
      | _ -> false

(* |accum| -- fold_left with arguments swapped *)
let rec accum f xs a =
  match xs with
      [] -> a
    | y::ys -> accum f ys (f y a)

(* |lookup_def| -- find definition of a name, give error is none *)
let lookup_def x env =
  err_line := x.x_line;
  try let d = lookup x.x_name env in x.x_def <- Some d; d with 
    Not_found -> sem_error "$ is not declared" [fStr x.x_name]

let rec check_expr e env =
  match e with
      Number (x) -> 
        ()
    | Boolean (x) ->
        ()
    | String (x) ->
        ()
    | Array e ->
        check_expr e env;
    | ExplicitArray es ->
        List.iter (fun e -> check_expr e env) es
    | Char (x) ->
        ()
    | Variable (x) ->
        let d = lookup_def x env in
          if not (has_value d) then sem_error "$ is not a variable" [fStr x.x_name]
    | MessageSend s ->
        check_expr s.s_target env; check_params s.s_params env
    | Perform (e1, e2) ->
      check_expr e1 env; check_expr e2 env;
    | PerformWith (e1, e2, e3) ->
      check_expr e1 env; check_expr e2 env; check_expr e3 env;
    (* | PerformWithArgsVoid (e1, e2, e3, len) ->
      check_expr e1 env; check_expr e2 env; check_expr e3 env;
      match e3 with
        |ExplicitArray es ->
          len = List.length es
        | _ -> sem_error "Perform with args must have explicit array" *)
    | InitSend s ->
        ()

and check_params ps env =
  let check_param p =
    match p.p_expr with
        Some (e) -> check_expr e env
      | None -> () in
  List.map check_param ps; ()

let rec check_stmt s env =
  match s with
      Skip -> ()
    | Seq ss -> 
        List.iter (fun s -> check_stmt s env) ss
    | Assign (e1, e2) ->
        check_expr e1 env; check_expr e2 env
    | MessageSendVoid s-> 
        check_expr s.s_target env; check_params s.s_params env
    | PerformVoid (e1, e2) ->
        check_expr e1 env; check_expr e2 env;
    | PerformWithVoid (e1, e2, e3) ->
      check_expr e1 env; check_expr e2 env; check_expr e3 env;
    | InitSendVoid c ->
        () (*Maybe check if className is on classpath*)
    | ExplicitWhileTrue l -> 
        let l1 = !curr_lab in incr curr_lab;
          check_expr l.l_cond env; check_stmt l.l_body env; 
          let l2 = !curr_lab in incr curr_lab; 
          let l3 = !curr_lab in incr curr_lab;
          l.l_lab_set <- Some {l_lab1 = l1; l_lab2 = l2; l_lab3 = l3 }; ()
    | ExplicitIfTrue l ->
        check_expr l.l_cond env; check_stmt l.l_body env;
        let l1 = !curr_lab in incr curr_lab;
        l.l_lab_set <- Some{l_lab1 = l1; l_lab2 = l1; l_lab3 = l1;}
    | ExplicitIfTrueElse ie ->
      check_expr ie.ie_cond env; check_stmt ie.ie_ifStmt env;
      let l1 = !curr_lab in incr curr_lab;
      check_stmt ie.ie_elseStmt env;
      let l2 = !curr_lab in incr curr_lab;
      ie.ie_lab_set <- Some{l_lab1 = l1; l_lab2 = l2; l_lab3 = l1;}
    | Return e ->
        check_expr e env


let rec check_local_decls ps n env = 
  match ps with
      [] -> env
    | (::) (p, tail) -> match p.x_varName with
          Some v -> let env' = declare_local v n env in check_local_decls tail (n+1) env'
        | None -> check_local_decls tail n env


let check_message_decl m env =
  let env' = check_local_decls (List.append m.m_params m.m_locals) 1 env in
    check_stmt m.m_body env'

let rec check_message_decls mds env =  
  match mds with 
      [] -> env
    | md :: tail ->
        let env' = declare_message md env in
          check_message_decl md env;
          check_message_decls tail env'; env'

let check_var_decls vds env0 = 
  let rec loop ds n env = 
    match ds with
        [] -> env
      | h::tail ->
          if Char.code(h.[0]) <= Char.code('Z') then loop tail (n+1) (declare_class_var h n env)
          else loop tail (n+1) (declare_inst_var h n env)
      in loop vds 1 env0

let init_env = declare_local "self" 0 empty
let annotate_class c =
  let env = check_var_decls c.c_vars init_env in
    check_message_decls c.c_messages env

let annotate (ClassDecls(classes)) =
  List.map annotate_class classes; ()