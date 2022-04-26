open Dict 
open Tree 
open Jvm 
open Print
(* Code generation *)

let rec gen_expr c e =
  match e with
      MessageSend s -> 
        SEQ[gen_expr c s.s_target; gen_params c s.s_params; PCALL (s.s_full_name, s.s_arg_count)]
    | InitSend s -> 
        SEQ [NEW("rt/"^s); DUP; INIT("rt/"^s)]
    | Variable x -> 
      (match x.x_def with 
        Some d -> 
          (match d.d_kind with 
              InstanceVarDef -> SEQ [ALOAD 0; GETFIELD ("rt/"^c.c_category^"/"^c.c_name, x.x_name)]
            | ClassVarDef -> SEQ [GETSTATIC ("rt/"^c.c_category^"/"^c.c_name, x.x_name)]
            | LocalDef -> SEQ [ALOAD d.d_off]
          )
      )
    | Number x -> SEQ[LDCLASS "rt/Integer"; GETMETA; gen_num x; INITINT]
    | Boolean b -> SEQ[ NEW "rt/Boolean"; DUP; ICONST b; INITBOOL]
    | Char x ->
        SEQ [NEW "rt/Char"; DUP; BIPUSH (Char.code x); INITCHAR]
    | String x ->
        SEQ [NEW "rt/String"; DUP; LDC x; INITSTRING]
    | Array e ->
        SEQ [NEW "rt/Array"; DUP; gen_expr c e; INITARRAY ]
    | ExplicitArray es ->
        SEQ [NEW "rt/Array"; DUP;ICONST (List.length es); ANEWARRAY; gen_array_innards c es; INITARRAYEXPLICIT]
    | _ -> SEQ[]

and gen_num x = 
  if x < 6 then SEQ[ICONST x]
  else if x < 128 then SEQ[BIPUSH x]
  else SEQ[SIPUSH x]

and gen_array_innards c es =
  let curr_index = ref 0
    in SEQ(List.map (
      fun e -> let code = SEQ[DUP; gen_num !curr_index; gen_expr c e; AASTORE;]
                in incr curr_index;
                code;
      ) es)

and gen_param c p =
  match p.p_expr with
      Some e -> gen_expr c e
    | None -> SEQ[]

and gen_params c ps = SEQ (List.map (gen_param c) ps)

and gen_stmt c s =
  match s with 
      Skip -> NOP
    | Seq ss -> SEQ(List.map (gen_stmt c) ss)
    | Assign (Variable (x), e2) -> 
        (match x.x_def with 
          Some d -> 
            (match d.d_kind with 
                InstanceVarDef ->
                  SEQ[ ALOAD 0; gen_expr c e2; PUTFIELD("rt/"^c.c_category^"/"^c.c_name, x.x_name) ]
                | ClassVarDef -> 
                  SEQ [ gen_expr c e2; PUTSTATIC("rt/"^c.c_category^"/"^c.c_name, x.x_name)]
              | LocalDef -> 
                  SEQ [gen_expr c e2; ASTORE d.d_off]
          )
      )
    | MessageSendVoid s -> 
        SEQ[gen_expr c s.s_target; gen_params c s.s_params; PCALL (s.s_full_name, s.s_arg_count); POP]
    | InitSendVoid s -> 
        SEQ [NEW("rt/"^s); DUP; INIT("rt/"^s); POP]
    | PerformVoid (e1, e2) ->
        SEQ[gen_expr c e1; gen_expr c e2; PCALL ("makeString", 0); GETSTRINGCALL; PGET;gen_expr c e1; CALL 1; POP]
    | ExplicitWhileTrue s ->
      (match s.l_lab_set with
        Some l ->
          SEQ [GOTO l.l_lab2; LAB l.l_lab1;gen_stmt c s.l_body; LAB l.l_lab2; gen_expr c s.l_cond; GETBOOL; IFEQ l.l_lab3; GOTO l.l_lab1; LAB l.l_lab3; ]
      )
    | ExplicitIfTrue s ->
      (match s.l_lab_set with
        Some l ->
          SEQ [gen_expr c s.l_cond; GETBOOL; IFEQ l.l_lab1; gen_stmt c s.l_body; LAB l.l_lab1]
      )
    | ExplicitIfTrueElse s ->
      (match s.ie_lab_set with 
        Some l ->
          SEQ [gen_expr c s.ie_cond; GETBOOL; IFEQ l.l_lab1; gen_stmt c s.ie_ifStmt; GOTO l.l_lab2; LAB l.l_lab1; gen_stmt c s.ie_elseStmt; LAB l.l_lab2; ]
          )

    | Return e -> 
        SEQ [gen_expr c e; ARETURN;]

let gen_message_decl c m =
  if m.m_full_name = "init" then 
    SEQ [ INITSIG; SLIMIT 10; LLIMIT m.m_local_count; ALOAD 0; INIT c.c_super;
          gen_stmt c m.m_body; RETURN; ENDMETHOD]     
  else 
    SEQ [ METHODSIG(m.m_full_name, m.m_arg_count); SLIMIT 10; LLIMIT m.m_local_count;
          gen_stmt c m.m_body; ALOAD 0; ARETURN; ENDMETHOD]

let gen_var_decl vName =
  if vName.[0] <= 'Z' then SEQ [STATFIELD vName]
  else SEQ [FIELD vName]

let gen_class c =
  let fullClassName = "rt/" ^c.c_category ^ "/" ^ c.c_name in
    SEQ [ VERSION (55, 0); CLASS fullClassName; SUPER c.c_super; DECLARECONSTS;
          SEQ (List.map gen_var_decl c.c_instance_vars);
          SEQ (List.map (gen_message_decl c) c.c_messages); ENDCLASS]
let translate (ClassDecls(classes)) = 
  let translatedClasses = SEQ (List.map gen_class classes) in
  Jvm.output(translatedClasses)
