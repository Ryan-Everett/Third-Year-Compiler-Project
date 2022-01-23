open Print

(* |code| -- type of intermediate instructions *)
type code =
    VERSION of int * int                    (*JVM Class Version *)
  | CLASS of string                         (*Name of class "category/className" *)
  | SUPER of string                         (*Name of super "superCategory/super" *)
  | DECLARECONSTS                           (*Declare some Krakatau constants to make j file more readable *)
  | FIELD of string                         (*Variable decl with name *)
  | SMALLINTS                               (*Get the array of pre-loaded integers*)
  | INITSIG                                 (*Constructor signature *)
  | METHODSIG of string * int               (*Method signature (name, numArgs) *)
  | ENDMETHOD                               (*End method declaration *)
  | ENDCLASS                                (*End class declaration *)
  | NEW of string                           (*Make a new class (className) *)
  | DUP                                     (*Duplicate top operand of the stack*)
  | INIT of string                          (*Call to create and initialize class (className) *)
  | INITINT                                 (*Initialise rt/Integer*)
  | SLIMIT of int                           (*Limit stack size to n (CHECK THIS) *)
  | LLIMIT of int                           (*Limit local size to n (CHECK THIS) *)
  | ASTORE of int                           (*Store reference into local variable (location) *)
  | ALOAD of int                            (*Load reference from local variable (location) *)
  | AALOAD                                  (*Load reference from array *)
  | LDC of string                           (*Load constant string onto stack *)
  | LDCLASS of string                       (*Load class onto stack (className) *)
  | GETMETA                                 (*Get meta class of class on stack *)
  | DYNINIT                                 (*Create object with invoke dynamic *)
  (*| DYNINITINT                              (*Create Integer with invoke dynamic *)*)
  | PGET                                    (*Get method with [Target object, method name] on stack *)
  | PCALL of int                            (*Call method on object [method, target object, args] on stack (numArgs)*)
  | GETFIELD of string * string             (*Get instance variable (class, varName) *)
  | PUTFIELD of string * string             (*Write value on stack head to instance variable (class, varName) *)
  | POP                                     (*Pop head of stack *)
  | RETURN                                  (*Return from method *)
  | ARETURN                                 (*Return reference from method *)
  | STACKMAP                                (*Define a StackMapTable to please the jvm verifier *)
  | ICONST of int                           (*Constant Int in range [-1, 5] *)
  | BIPUSH of int                           (*Constant Int in range [-128, 127] *)
  | SIPUSH of int                           (*Constant Int in range [-32768, 32767] *)

  | SEQ of code list
  | NOP                                     (*Null operation*)

(* |canon| -- flatten a code sequence *)
let canon x =
  let rec accum x ys =
    match x with
        SEQ xs -> List.fold_right accum xs ys
      | _ -> x :: ys in
  SEQ (accum x [])

(* |repeatStr| -- return s repeated n times *)
let repeatStr n s = 
  let rec loop n st =
    if n = 0 then st else loop (n-1) (st^ s) in
      loop n ""


let rec fInst =
  let defbootclass = fStr "org/dynalang/dynalink/DefaultBootstrapper" in
  let statclass = fStr "org/dynalang/dynalink/beans/StaticClass" in
    let dynmeth = fMeta "Method $ publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;" [defbootclass; fStr"$"] in
    let getstatclass =  fMeta "Method $ forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;" [statclass] in
      function 
          VERSION (x, y) ->             fMeta ".version $ $" [fNum x; fNum y]
        | CLASS n ->                    fMeta ".class public super \"$\"" [fStr n]
        | SUPER n ->                    fMeta ".super \"$\"" [fStr n]
        | DECLARECONSTS ->              fMeta ".const [getstatcls] = $\n.const [dynmeth] = $" [getstatclass; dynmeth]
        | FIELD n ->                    fMeta ".field private \"$\" Lrt/Object;" [fStr n]
        | SMALLINTS ->                  fStr "getstatic Field rt/Integer smallInts [Lrt/Integer;"
        | INITSIG ->                    fStr  ".method public <init> : ()V"
        | METHODSIG (n, x) ->           fMeta ".method public \"$\" : ($)Lrt/Object;" [fStr n; fStr(repeatStr x "Lrt/Object;")]
        | ENDMETHOD ->                  fStr ".end method"
        | ENDCLASS ->                   fStr ".end class"
        | NEW n->                       fMeta "new $" [fStr n]
        | DUP ->                        fStr "dup"
        | INIT n ->                     fMeta "invokespecial Method $ <init> ()V" [fStr n]
        | INITINT ->                    fStr "invokespecial Method rt/Integer <init> (I)V"
        | SLIMIT x ->                   fMeta ".limit stack $" [fNum x]
        | LLIMIT x ->                   fMeta ".limit locals $" [fNum x]
        | ASTORE x ->                   fMeta "astore $" [fNum x]
        | ALOAD x ->                    fMeta "aload $" [fNum x]
        | AALOAD ->                     fStr "aaload"
        | LDC n ->                      fMeta "ldc \"$\"" [fStr n]
        | LDCLASS c ->                  fMeta "ldc Class \"$\"" [fStr c]
        | GETMETA ->                    fStr "invokestatic [getstatcls]"
        | DYNINIT ->                    fStr "invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;)Lrt/Object;" 
        (*| DYNINITINT ->                 fMeta "invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;I)Lrt/Object;" [dynmeth]*)
        | PGET ->                       fStr "invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:getMethod' (Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;" 
        | PCALL x ->                    fMeta "invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:call' (Ljava/lang/Object;Ljava/lang/Object;$)Lrt/Object;" [ fStr(repeatStr x "Lrt/Object;")]
        | GETFIELD (c, n) ->            fMeta "getfield Field \"$\" \"$\" Lrt/Object;" [fStr c; fStr n]
        | PUTFIELD (c, n) ->            fMeta "putfield Field \"$\" \"$\" Lrt/Object;" [fStr c; fStr n]
        | POP ->                        fStr "pop"
        | RETURN ->                     fStr "return"
        | ARETURN ->                    fStr "areturn"
        | STACKMAP ->                   fStr ".stack same"
        | ICONST x ->                   fMeta "iconst_$" [fNum x]
        | BIPUSH x ->                   fMeta "bipush $" [fNum x]
        | SIPUSH x ->                   fMeta "sipush $" [fNum x]
        | SEQ l ->                      fMeta "$\nSEQ" [fInst(List.hd l)]
        | NOP ->                        fStr""
        | _ ->                          fStr"NO INSTRUCTION FOUND"
let output code =
  match (canon code) with
    SEQ (ls) -> List.map (fun x -> printf "$\n" [fInst x]) ( ls); ()