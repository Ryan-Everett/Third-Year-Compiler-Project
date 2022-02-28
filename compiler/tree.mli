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
    m_arg_count : int}

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
  | IfStmt of expr * stmt * stmt
  | WhileStmt of expr * stmt
  | MessageSendVoid of messageSend
  | InitSendVoid of ident
  | Return of expr

  
and expr =
      Number of int             (* Constant (value) *)
    | Char of char
    | String of string
    | Variable of name          (* Variable (name) *)
    | MessageSend of messageSend
    | InitSend of ident


and op = Plus | Minus | Times | Divide

(* seq -- neatly join a list of statements into a sequence *)
val seq : stmt list -> stmt

val makeClass : ident -> ident -> ident -> ident list -> message list -> classDecl

val makeName : ident -> int -> name

val makeParamDecl : ident -> ident option -> paramDecl

val makeParam : ident -> expr option -> param

val makeMessage : paramDecl list -> stmt -> message

val makeMessageSend :  expr -> param list -> messageSend

val print_tree : out_channel -> classDecls -> unit

