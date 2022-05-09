open Dict 
open Tree 
open Jvm 
open Print
(* Code generation *)

let rec gen_expr c l e =
  match e with
      MessageSend s -> 
        SEQ[gen_expr c l s.s_target; gen_params c l s.s_params; PCALL (s.s_full_name, s.s_arg_count)]
    | InitSend s -> 
        SEQ [NEW("rt/"^s); DUP; INIT("rt/"^s)]
    | Perform (e1, e2) ->
        SEQ[gen_expr c l e1; DUP; ASTORE l; gen_expr c l e2; GETSTRINGCALL; PGET; ALOAD l; CALL 1;]
    | PerformWith (e1, e2, e3) ->
        SEQ[gen_expr c l e1; DUP; ASTORE l;gen_expr c l e2; GETSTRINGCALL; PGET; ALOAD l; gen_expr c l e3; CALL 2;]
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
        SEQ [NEW "rt/Array"; DUP; gen_expr c l e; INITARRAY ]
    | ExplicitArray es ->
        SEQ [NEW "rt/Array"; DUP;ICONST (List.length es); ANEWARRAY; gen_array_innards c l es; INITARRAYEXPLICIT]
    | _ -> SEQ[]

and gen_num x = 
  if x < 6 then ICONST x
  else if x < 128 then BIPUSH x
  else if x < 32768 then SIPUSH x
  else LDCINT x

and gen_array_innards c l es =
  let curr_index = ref 0
    in SEQ(List.map (
      fun e -> let code = SEQ[DUP; gen_num !curr_index; gen_expr c l e; AASTORE;]
                in incr curr_index;
                code;
      ) es)

and gen_param c l p =
  match p.p_expr with
      Some e -> gen_expr c l e
    | None -> SEQ[]

and gen_params c l ps = SEQ (List.map (gen_param c l) ps)

and gen_stmt c l s=
  match s with 
      Skip -> NOP
    | Seq ss -> SEQ(List.map (gen_stmt c l) ss)
    | Assign (Variable (x), e2) -> 
        (match x.x_def with 
          Some d -> 
            (match d.d_kind with 
                InstanceVarDef ->
                  SEQ[ ALOAD 0; gen_expr c l e2; PUTFIELD("rt/"^c.c_category^"/"^c.c_name, x.x_name) ]
                | ClassVarDef -> 
                  SEQ [ gen_expr c l e2; PUTSTATIC("rt/"^c.c_category^"/"^c.c_name, x.x_name)]
              | LocalDef -> 
                  SEQ [gen_expr c l e2; ASTORE d.d_off]
          )
      )
    | MessageSendVoid s -> 
        SEQ[gen_expr c l s.s_target; gen_params c l s.s_params; PCALL (s.s_full_name, s.s_arg_count); POP]
    | InitSendVoid s -> 
        SEQ [NEW("rt/"^s); INIT("rt/"^s)]
    | PerformVoid (e1, e2) ->
        SEQ[gen_expr c l e1; DUP; ASTORE l; gen_expr c l e2; GETSTRINGCALL; PGET; ALOAD l; CALL 1; POP]
    | PerformWithVoid (e1, e2, e3) ->
        SEQ[gen_expr c l e1; DUP; ASTORE l; gen_expr c l e2; GETSTRINGCALL; PGET; ALOAD l; gen_expr c l e3; CALL 2; POP]
    | ExplicitWhileTrue s ->
      (match s.l_lab_set with
        Some labs ->
          SEQ [GOTO labs.l_lab2; LAB labs.l_lab1;gen_stmt c l s.l_body; LAB labs.l_lab2; gen_expr c l s.l_cond; GETBOOL; IFEQ labs.l_lab3; GOTO labs.l_lab1; LAB labs.l_lab3; ]
      )
    | ExplicitIfTrue s ->
      (match s.l_lab_set with
        Some labs ->
          SEQ [gen_expr c l s.l_cond; GETBOOL; IFEQ labs.l_lab1; gen_stmt c l s.l_body; LAB labs.l_lab1]
      )
    | ExplicitIfTrueElse s ->
      (match s.ie_lab_set with 
        Some labs ->
          SEQ [gen_expr c l s.ie_cond; GETBOOL; IFEQ labs.l_lab1; gen_stmt c l s.ie_ifStmt; GOTO labs.l_lab2; LAB labs.l_lab1; gen_stmt c l s.ie_elseStmt; LAB labs.l_lab2; ]
          )
    | Return e -> 
        SEQ [gen_expr c l e; ARETURN;]

let gen_message_decl c m =
  if m.m_full_name = "init" then 
    SEQ [ INITSIG; SLIMIT 10; LLIMIT m.m_local_count; ALOAD 0; INIT c.c_super;
          gen_stmt c m.m_local_count m.m_body; RETURN; ENDMETHOD]     
  else 
    SEQ [ METHODSIG(m.m_full_name, m.m_arg_count); SLIMIT 10; LLIMIT m.m_local_count;
          gen_stmt c m.m_local_count m.m_body; ALOAD 0; ARETURN; ENDMETHOD]

let gen_var_decl vName =
  if vName.[0] <= 'Z' then SEQ [STATFIELD vName]
  else SEQ [FIELD vName]

let gen_class c =
  let fullClassName = "rt/" ^c.c_category ^ "/" ^ c.c_name in
    SEQ [ VERSION (55, 0); CLASS fullClassName; SUPER c.c_super; DECLARECONSTS;
          SEQ (List.map gen_var_decl c.c_vars);
          SEQ (List.map (gen_message_decl c) c.c_messages); ENDCLASS]
let translate (ClassDecls(classes)) = 
  let translatedClasses = SEQ (List.map gen_class classes) in
  Jvm.output(translatedClasses)
