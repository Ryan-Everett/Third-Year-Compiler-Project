(* Abstract syntax *)

(* superName, className, category, instanceVarNames, messages *)
open Dict

type classDecls = ClassDecls of classDecl list

and classDecl = 
  { c_super : ident;
    c_name : ident;
    c_category : ident;
    c_vars : ident list;
    c_messages : message list}

and ident = string

and lab = int

and branch = 
  { l_cond : expr;
    l_body : stmt;
    mutable l_lab_set : lab_set option}

and ifElse = 
  { ie_cond : expr;
    ie_ifStmt : stmt;
    ie_elseStmt : stmt;
    mutable ie_lab_set : lab_set option}

and name = 
  {x_name: ident;
   x_line: int;
   mutable x_def: def option }

and localDecl =
  { x_selector : ident;
    x_varName : ident option;
    x_offset : int}

and param =
  { p_selector : ident;
    p_expr : expr option}

and message =
  { m_full_name : ident;
    m_params : localDecl list;
    m_locals : localDecl list;
    m_body : stmt;
    m_arg_count : int;
    m_local_count : int;
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
(*| BlockAssign of expr * block *)
  | ExplicitWhileTrue of branch
  | ExplicitIfTrue of branch
  | ExplicitIfTrueElse of ifElse
  | MessageSendVoid of messageSend
  | PerformVoid of expr * expr
  | PerformWithVoid of expr * expr * expr
  (* | PerformWithArgsVoid of expr * expr * expr * (int option) *)
  | InitSendVoid of ident
  | Return of expr

  
and expr =
      Number of int             (* Constant (value) *)
    | Boolean of int
    | Char of char
    | String of string
    | Array of expr
    | ExplicitArray of expr list
    | Variable of name          (* Variable (name) *)
    | MessageSend of messageSend
    | Perform of expr * expr
    | PerformWith of expr * expr * expr
    (* | PerformWithArgs of expr * expr * expr * (int option) *)
    | InitSend of ident

(* seq -- neatly join a list of statements into a sequence *)
val seq : stmt list -> stmt

val makeBranch : expr -> stmt -> branch

val makeIfElse : expr -> stmt -> stmt -> ifElse

val makeClass : ident -> ident -> ident -> ident list -> message list -> classDecl

val makeName : ident -> int -> name

val makeParamDecl : ident -> ident option -> localDecl

val makeLocalVarDecl : ident -> localDecl

val makeParam : ident -> expr option -> param

val makeMessage : localDecl list -> localDecl list -> stmt -> message

val makeMessageSend :  expr -> param list -> messageSend

val print_tree : out_channel -> classDecls -> unit

