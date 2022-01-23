open Print

let parse_equation s = 
  Parser.file Lexer.token (Lexing.from_string s)

let read_whole_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let main () =
  let dflag = ref 0 in 
  let fns = ref [] in
  let usage =  "Usage: compile [-d] file.txt" in
  Arg.parse 
    [("-d", Arg.Unit (fun () -> incr dflag), " Print the tree for debugging")]
    (function s -> fns := !fns @ [s]) usage;

  let translateFile in_file = 
    let in_chan = open_in in_file in
      Source.init in_file in_chan;
      !Lexer.currLine = 1;
      let lexbuf = Lexing.from_channel in_chan in
        let prog = try Parser.file Lexer.token lexbuf with
          Parsing.Parse_error -> 
            let tok = Lexing.lexeme lexbuf in
            Source.err_message "syntax error at token '$'" [fStr tok] !Lexer.currLine;
            exit 1 in
      if !dflag > 0 then Tree.print_tree stdout prog;
      Check.annotate prog;
      Jvmgen.translate prog in
  List.map translateFile !fns

let compile = main ()