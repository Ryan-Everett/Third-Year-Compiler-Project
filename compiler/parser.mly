%{
open Tree
open Dict
%}
%token <Dict.ident>     IDENT MESSAGE
%token <int>            NUMBER
%token <float>
%token <char>           CHAR          
%token <string>         STRING
%token                  SUBCLASS CATEGORY VARNAMES PLUS MINUS TIMES DIVIDE
%token                  TIMES DIVIDE OPEN CLOSE EQUAL EOF BADTOK CONCAT
%token                  SEMI ASSIGN LPAR RPAR TRUE FALSE INIT NEW RETURN
                  
%type <Tree.classDecls>  file

%start                  file

%%

file :
      class_decls                         { ClassDecls ($1)}

class_decls :
      class_decl                          { [$1] }
    | class_decl class_decls              { $1 :: $2 };  
class_decl :
      IDENT SUBCLASS IDENT CATEGORY IDENT  var_names LPAR message_decls RPAR
                                          { makeClass $1 $3 $5 $6 $8 };

var_names:
      VARNAMES                            { [] };
    | VARNAMES idents                     { $2 };

idents :
      IDENT                               { [$1] }
    | IDENT idents                        { $1 :: $2 };

message_decls :
      message_decl                        { [$1] }
    | message_decl message_decls          { $1 :: $2 };

message_decl :
      param_decls block                   { makeMessage $1 $2 }
    | IDENT block                         { makeMessage [makeParamDecl $1 None] $2 }
    | INIT block                          { makeMessage [makeParamDecl "init" None] $2 };

param_decls :
      param_decl                          { [$1] }
    | param_decl param_decls              { $1 :: $2 };

param_decl :
    | MESSAGE                             { makeParamDecl $1 (None)}
    | MESSAGE IDENT                       { makeParamDecl $1 (Some $2) };

params :
      param                               { [$1] }
    | param params                        { $1 :: $2 };

param :
      MESSAGE                             { makeParam $1 None}
    | MESSAGE variable                    { makeParam $1 (Some $2) };
    | MESSAGE LPAR expr RPAR              { makeParam $1 (Some $3) };

block :
      LPAR stmts RPAR                     { $2 };

stmts :
      stmt_list                           { seq $1 };

stmt_list :
      stmt                                { [$1] }
    | stmt SEMI stmt_list                 { $1 :: $3 };

stmt :
      /* empty */                         { Skip }
    | variable EQUAL expr                 { Assign ($1, $3)}
    | factor params                       { MessageSendVoid (makeMessageSend $1 $2)}
    | factor IDENT                        { MessageSendVoid (makeMessageSend $1 [makeParam $2 (None)]) }
    | IDENT NEW                           { InitSendVoid ($1)};
    | RETURN expr                         { Return ($2)}

expr :
      expr2                               { $1 }
    | expr PLUS expr2                     { MessageSend (makeMessageSend $1 [makeParam "add$" (Some($3))]) }
    | expr MINUS expr2                    { MessageSend (makeMessageSend $1 [makeParam "minus$" (Some($3))]) }
    | expr CONCAT expr2                   { MessageSend (makeMessageSend $1 [makeParam "concat$" (Some($3))]) }
expr2 : 
      factor                              { $1 }
    | expr2 TIMES factor                  { MessageSend (makeMessageSend $1 [makeParam "mult$" (Some($3))]) }
    | expr2 DIVIDE factor                 { MessageSend (makeMessageSend $1 [makeParam "div$" (Some($3))]) }
    | factor params                       { MessageSend (makeMessageSend $1 $2)}
    | IDENT NEW                           { InitSend ($1)}; 

factor :
      factor2                             { $1 }
    | factor IDENT                        { MessageSend (makeMessageSend $1 [makeParam $2 (None)]) }

factor2 :
      variable                            { $1 }
    | MINUS factor2                       { MessageSend (makeMessageSend $2 [makeParam "minus" None]) }
    | LPAR expr RPAR                      { $2 };
variable :
    | name                                { Variable ($1) }
    | NUMBER                              { Number ($1) };
    | CHAR                                { Char ($1) }
    | STRING                              { String ($1) };

name :  
    IDENT                                 { makeName $1 !Lexer.currLine } ;
