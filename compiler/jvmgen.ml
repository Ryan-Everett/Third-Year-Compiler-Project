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
        SEQ [LDCLASS ("rt/"^s); GETMETA; DYNINIT]
    | Variable x -> 
      (match x.x_def with 
        Some d -> 
          (match d.d_kind with 
              VarDef -> SEQ [ALOAD 0; GETFIELD ("rt/"^c.c_category^"/"^c.c_name, x.x_name)]
            | LocalDef -> SEQ [ALOAD d.d_off]
          )
      )
    | Number x ->
        (*Small numbers are preallocated*)
        if x < 128 then SEQ[SMALLINTS; BIPUSH x; AALOAD]
        else SEQ[NEW "rt/Integer"; DUP; SIPUSH x; INITINT]
    | Boolean b -> SEQ[ NEW "rt/Boolean"; DUP; ICONST b; INITBOOL]
    | Char x ->
        SEQ[NEW "rt/Char"; DUP; BIPUSH (Char.code x); INITCHAR]
    | String x ->
        SEQ[NEW "rt/String"; DUP; LDC x; INITSTRING]
    | _ -> SEQ[]

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
                VarDef ->
                  SEQ[ ALOAD 0; gen_expr c e2;
                       PUTFIELD("rt/"^c.c_category^"/"^c.c_name, x.x_name) ]
              | LocalDef -> 
                  SEQ [gen_expr c e2; ASTORE d.d_off]
          )
      )
    | MessageSendVoid s -> 
        SEQ[gen_expr c s.s_target; gen_params c s.s_params; PCALL (s.s_full_name, s.s_arg_count); POP]
    | InitSendVoid s -> 
        SEQ [LDCLASS ("rt/"^s); GETMETA; DYNINIT; POP]
    | ExplicitWhileTrue s ->
      (match s.l_lab_set with
        Some l ->
          SEQ [GOTO l.l_lab2; LAB l.l_lab1;gen_stmt c s.l_body; LAB l.l_lab2; gen_expr c s.l_cond; GETBOOL; IFEQ l.l_lab3; GOTO l.l_lab1; LAB l.l_lab3; ]
      )
    | Return e -> 
        SEQ [gen_expr c e; ARETURN; STACKMAP]

let gen_message_decl c m =
  if m.m_full_name = "init" then 
    SEQ [ INITSIG; SLIMIT 10; LLIMIT m.m_local_count; ALOAD 0; INIT c.c_super;
          gen_stmt c m.m_body; RETURN; ENDMETHOD]     
  else 
    SEQ [ METHODSIG(m.m_full_name, m.m_arg_count); SLIMIT 10; LLIMIT m.m_local_count;
          gen_stmt c m.m_body; ALOAD 0; ARETURN; ENDMETHOD]

let gen_var_decl vName =
  SEQ [FIELD vName]

let gen_class c =
  let fullClassName = "rt/" ^c.c_category ^ "/" ^ c.c_name in
    SEQ [ VERSION (55, 0); CLASS fullClassName; SUPER c.c_super; DECLARECONSTS;
          SEQ (List.map gen_var_decl c.c_instance_vars);
          SEQ (List.map (gen_message_decl c) c.c_messages); ENDCLASS]
let translate (ClassDecls(classes)) = 
  let translatedClasses = SEQ (List.map gen_class classes) in
  Jvm.output(translatedClasses)
