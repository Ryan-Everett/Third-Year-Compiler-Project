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

and lab = int

and loop = 
  { l_cond : expr;
    l_body : stmt;
    mutable l_lab_set : lab_set option}

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
  | Print of expr
  | Newline
  | IfStmt of expr * stmt * stmt
  | ExplicitWhileTrue of loop
  | MessageSendVoid of messageSend
  | InitSendVoid of ident
  | Return of expr

  
and expr =
      Number of int             (* Constant (value) *)
    | Boolean of int
    | Char of char
    | String of string
    (*| Block of block *)
    | Variable of name          (* Variable (name) *)
    | MessageSend of messageSend
    | InitSend of ident


and op = Plus | Minus | Times | Divide

(* seq -- neatly join a list of statements into a sequence *)
val seq : stmt list -> stmt

val makeLoop : expr -> stmt -> loop

val makeClass : ident -> ident -> ident -> ident list -> message list -> classDecl

val makeName : ident -> int -> name

val makeParamDecl : ident -> ident option -> localDecl

val makeLocalVarDecl : ident -> localDecl

val makeParam : ident -> expr option -> param

val makeMessage : localDecl list -> localDecl list -> stmt -> message

val makeMessageSend :  expr -> param list -> messageSend

val print_tree : out_channel -> classDecls -> unit

