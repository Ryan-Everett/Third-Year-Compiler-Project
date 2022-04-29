(* |annotate| -- check tree for type errors and annotate with definitions *)
val annotate : Tree.classDecls -> unit

(* |Semantic_error| -- exception raised if error detected *)
exception Semantic_error of string * Print.arg list * int