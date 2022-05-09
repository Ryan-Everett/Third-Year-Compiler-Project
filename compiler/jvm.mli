(* |code| -- type of intermediate instructions *)
type code =
    VERSION of int * int                    (*JVM Class Version *)
  | CLASS of string                         (*Name of class "category/className" *)
  | SUPER of string                         (*Name of super "superCategory/super" *)
  | DECLARECONSTS                           (*Declare some Krakatau constants to make j file more readable *)
  | FIELD of string                         (*Variable decl with name *)
  | STATFIELD of string                     (*Static variable decl with name *)
  | SMALLINTS                               (*Get the array of pre-loaded integers*)
  | INITSIG                                 (*Constructor signature *)
  | METHODSIG of string * int               (*Method signature (name, numArgs) *)
  | ENDMETHOD                               (*End method declaration *)
  | ENDCLASS                                (*End class declaration *)
  | NEW of string                           (*Make a new class (className) *)
  | DUP                                     (*Duplicate top operand of the stack*)
  | INIT of string                          (*Call to create and initialize class (className) *)
  | INITINT                                 (*Initialise rt/Integer*)
  | INITBOOL                                (*Initialise rt/Boolean*)
  | INITCHAR                                (*Initialise rt/Char*)
  | INITSTRING                              (*Initialise rt/String*)
  | INITARRAY                               (*Initialise rt/Array*)
  | INITARRAYEXPLICIT                       (*Initialise explicit rt/Array*)
  | SLIMIT of int                           (*Limit stack size to n (CHECK THIS) *)
  | LLIMIT of int                           (*Limit local size to n (CHECK THIS) *)
  | ASTORE of int                           (*Store reference into local variable (location) *)
  | ALOAD of int                            (*Load reference from local variable (location) *)
  | AASTORE                                 (*Store into reference array*)
  | AALOAD                                  (*Load reference from array *)
  | LDC of string                           (*Load constant string onto stack *)
  | LDCINT of int                           (*Load constant int onto stack *)
  | LDCLASS of string                       (*Load class onto stack (className) *)
  | GETMETA                                 (*Get meta class of class on stack*)
  | DYNINIT                                 (*Create object with invoke dynamic *)
  | PGET                                    (*Get method with [Target object, method name] on stack *)
  | PCALL of string * int                   (*Call method on object [target object, args] on stack (methodID, numArgs)*)
  | CALL of int                             (*Call method on object [methodName, args] on stack numArgs*)
  | GETSTRINGCALL                           (*Call $GetStringForPerform$ on a rt/String object *)
  | GETFIELD of string * string             (*Get instance variable (class, varName) *)
  | GETSTATIC of string * string            (*Get class variable (class, varName) *)
  | PUTFIELD of string * string             (*Write value on stack head to instance variable (class, varName) *)
  | PUTSTATIC of string * string            (*Write value on stack head to class variable (class, varName) *)
  | POP                                     (*Pop head of stack *)
  | RETURN                                  (*Return from method *)
  | ARETURN                                 (*Return reference from method *)
  | ICONST of int                           (*Constant Int in range [-1, 5] *)
  | BIPUSH of int                           (*Constant Int in range [-128, 127] *)
  | SIPUSH of int                           (*Constant Int in range [-32768, 32767] *)
  | IFEQ of int                             (*Branch to lab if value on stack is not equal to 0 *)
  | GOTO of int                             (*Unconditional branch *)
  | LAB of int                              (*Declare label *)
  | GETBOOL                                 (*Get the java boolean stored within a rt/Boolean *)
  | ANEWARRAY                               (*Create array of rt/Object *)
  | SEQ of code list
  | NOP                                     (*Null operation*)


val output : code -> unit