(* Abstract syntax *)

(* superName, className, category, instanceVarNames, messages *)
open Dict

type classDecls = ClassDecls of classDecl list

and classDecl = 
  { c_super : ident;
    c_name : ident;
    c_category : ident;
    c_instance_vars : ident list;
    c_messages : message list}

and ident = string

and name = 
  {x_name: ident;
   x_line: int;
   mutable x_def: def option }

and paramDecl =
  { x_selector : ident;
    x_varName : ident option;
   x_offset : int}

and param =
  { p_selector : ident;
    p_expr : expr option}

and message =
  { m_full_name : ident;
    m_params : paramDecl list;
    m_body : stmt;
    m_arg_count : int;
    }

and messageSend =
{ s_target : expr;
  s_full_name : ident;
  s_params : param list;
  s_arg_count : int}

and stmt = 
    Skip 
  | Seq of stmt list
  | Assign of expr * expr
  | Print of expr
  | Newline
  | IfStmt of expr * stmt * stmt  (*Not added yet*)
  | WhileStmt of expr * stmt      (*Not added yet*)
  | MessageSendVoid of messageSend
  | InitSendVoid of ident
  | Return of expr

  
and expr =
  Number of int             (* Constant (value) *)
    | Variable of name          (* Variable (name) *)
    | MessageSend of messageSend
    | InitSend of ident

and op = Plus | Minus | Times | Divide

let seq =
  function
      [] -> Skip                (* Use Skip in place of Seq [] *)
    | [s] -> s                  (* Don't use a Seq node for one element *)
    | ss -> Seq ss

let makeName x ln =
  { x_name = x; x_line = ln; x_def = None }

let makeParamDecl selector name = {x_selector = selector; x_varName = name; x_offset = -99}

let makeParam selector e = {p_selector = selector; p_expr = e}

let methodDeclID ps st = List.fold_right (fun p st -> p.x_selector ^ st) ps ""

let declNumArgs ps = List.fold_right (fun x n -> match x.x_varName with
    Some id -> n + 1
  | None -> n) ps 0

let methodID ps st = List.fold_right (fun p st -> p.p_selector ^ st) ps ""

let numArgs ps = List.fold_right (fun x n -> match x.p_expr with
      Some e -> n + 1
    | None -> n) ps 0

let makeClass sup name cat vars messages =
  {c_super = "rt/"^sup; c_name = name; c_category = cat; c_instance_vars = vars; c_messages = messages}

let makeMessage ps ss = 
  {m_full_name = methodDeclID ps ""; m_params = ps; m_body = ss; m_arg_count = declNumArgs ps }

let makeMessageSend e ps =
  {s_target = e; s_full_name = methodID ps ""; s_params = ps; s_arg_count = numArgs ps }

open Print


let fTail f xs =
  let g prf = List.iter (fun x -> prf "; $" [f x]) xs in fExt g

let fList f =
  function
      [] -> fStr "[]"
    | x::xs -> fMeta "[$$]" [f x; fTail(f) xs]


let fName x = fStr x.x_name

let fParamDecl x =
  match x.x_varName with
      Some n -> fMeta "ParamDecl_($, $)" [fStr x.x_selector; fStr n]
    | None -> fMeta "ParamDecl_($)" [fStr x.x_selector]

let rec fExpr =
  function
      Number n -> 
        fMeta "Number_$" [fNum n]
    | Variable x -> 
        fMeta "Variable_\"$\"" [fName x]
    | MessageSend s ->
        fMeta "MessageSend_($, $)" [fExpr s.s_target; fList(fParam) s.s_params]
    | InitSend c ->
        fMeta "InitSend_($)" [fStr c]

and fParam p =
  match p.p_expr with
      Some e -> fMeta "Param_($, $)" [fStr p.p_selector; fExpr e]
    | None -> fMeta "Param_($)" [fStr p.p_selector]

let rec fStmt =
  function
      Skip -> 
        fStr "Skip"
    | Seq ss -> 
        fMeta "Seq_$" [fList(fStmt) ss]
    | Assign (x, e) -> 
        fMeta "Assign_(\"$\", $)" [fExpr x; fExpr e]
    | Print e -> 
        fMeta "Print_($)" [fExpr e]
    | Newline -> 
        fStr "Newline"
    | IfStmt (e, s1, s2) ->
        fMeta "IfStmt_($, $, $)" [fExpr e; fStmt s1; fStmt s2]
    | WhileStmt (e, s) -> 
        fMeta "WhileStmt_($, $)" [fExpr e; fStmt s]
    | MessageSendVoid s ->
        fMeta "MessageSendVoid_($, $)" [fExpr s.s_target; fList(fParam) s.s_params]
    | InitSendVoid c ->
        fMeta "InitSendVoid_($)" [fStr c]
    | Return e ->
        fMeta "Return_($)" [fExpr e]

let fMessageDecl (m) = fMeta "MessageDecl_($,$)" [fList(fParamDecl) m.m_params; fStmt m.m_body]

let fClassDecl (c) = 
  fMeta "ClassDecl_($, $, $, $, $)" [fStr c.c_super; fStr c.c_name; fStr c.c_category; fList(fStr) c.c_instance_vars; fList(fMessageDecl) c.c_messages]
let print_tree fp (ClassDecls(cds)) = fgrindf fp "! " "$" [fList(fClassDecl) cds]

