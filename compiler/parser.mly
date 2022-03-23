%{
open Tree
open Dict
%}
%token <Dict.ident>     IDENT GLOBIDENT PATHEDGLOBIDENT MESSAGE BVAR
%token <int>            NUMBER
%token <float>
%token <char>           CHAR          
%token <string>         STRING
%token                  SUBCLASS CATEGORY VARNAMES PLUS MINUS TIMES DIVIDE WHILETRUE
%token                  TIMES DIVIDE OPEN CLOSE EQUAL EOF BADTOK CONCAT BAR
%token                  SEMI ASSIGN LPAR RPAR LBAR RBAR TRUE FALSE INIT NEW NEWWITHARG RETURN 
%token                  AND OR NOT LT LEQ EQ NEQ GEQ GT IFTRUE ELSE MOD HASH ARRAY
                  
%type <Tree.classDecls>  file

%start                  file

%%

file :
      class_decls                         { ClassDecls ($1)}

class_decls :
      class_decl                          { [$1] }
    | class_decl class_decls              { $1 :: $2 };  

class_decl :
      glob_ident SUBCLASS GLOBIDENT CATEGORY IDENT LPAR message_decls RPAR
                                          { makeClass $1 $3 $5 [] $7 }
    | glob_ident SUBCLASS GLOBIDENT CATEGORY IDENT var_names LPAR message_decls RPAR
                                          { makeClass $1 $3 $5 $6 $8 };

var_names:
      VARNAMES                            { [] }
    | VARNAMES var_idents                 { $2 };

var_idents :
      var_ident                           { [$1] }
    | var_ident var_idents                { $1 :: $2 };

var_ident :
      IDENT                               { $1 }
    | GLOBIDENT                           { $1 };

glob_ident :
      GLOBIDENT                           { $1 }
    | PATHEDGLOBIDENT                     { $1 };

message_decls :
      message_decl                        { [$1] }
    | message_decl message_decls          { $1 :: $2 };

message_decl :
      param_decls stmt_group              { makeMessage $1 [] $2 }
    | IDENT stmt_group                    { makeMessage [makeParamDecl $1 None] [] $2}
    | param_decls BAR local_var_decls BAR stmt_group    
                                          { makeMessage $1 $3 $5 }
    | IDENT BAR local_var_decls BAR stmt_group          
                                          { makeMessage [makeParamDecl $1 None] $3 $5 }
    | INIT stmt_group                     { makeMessage [makeParamDecl "init" None] [] $2 }
    | INIT BAR local_var_decls BAR stmt_group
                                          { makeMessage [makeParamDecl "init" None] $3 $5};

param_decls :
      param_decl                          { [$1] }
    | param_decl param_decls              { $1 :: $2 };

param_decl :
    | MESSAGE                             { makeParamDecl $1 (None)}
    | MESSAGE IDENT                       { makeParamDecl $1 (Some $2) };

local_var_decls :
      IDENT                               { [makeLocalVarDecl $1] }
    | IDENT local_var_decls               { (makeLocalVarDecl $1) :: $2 };

params :
      param                               { [$1] }
    | param params                        { $1 :: $2 };

param :
      MESSAGE                             { makeParam $1 None}
    | MESSAGE variable                    { makeParam $1 (Some $2) };
    | MESSAGE LPAR expr RPAR              { makeParam $1 (Some $3) };

stmt_group :
      LPAR stmts RPAR                     { $2 };

stmts :
      stmt_list                           { seq $1 };

stmt_list :
      stmt                                { [$1] }
    | stmt SEMI stmt_list                 { $1 :: $3 };

stmt :
      /* empty */                         { Skip }
    | variable EQUAL expr                 { Assign ($1, $3)}
    | exprB params                        { MessageSendVoid (makeMessageSend $1 $2)}
    | exprB IDENT                         { MessageSendVoid (makeMessageSend $1 [makeParam $2 (None)]) }
    | glob_ident NEW                      { InitSendVoid ($1)}
    | RETURN expr                         { Return ($2)}
    | expr WHILETRUE LBAR stmts RBAR      { ExplicitWhileTrue (makeBranch $1 $4)}
    | expr IFTRUE LBAR stmts RBAR         { ExplicitIfTrue (makeBranch $1 $4)}
    | expr IFTRUE LBAR stmts RBAR ELSE LBAR stmts RBAR
                                          { ExplicitIfTrueElse (makeIfElse $1 $4 $8)};

expr_list :
      expr                                { [$1] }
    | expr expr_list                      { $1 :: $2 };

expr :
      exprA                               { $1}

exprA:
      exprB                               { $1 }
    | exprB params                        { MessageSend (makeMessageSend $1 $2)}
    | exprB IDENT                         { MessageSend (makeMessageSend $1 [makeParam $2 (None)]) }
    | ARRAY NEWWITHARG exprB              { Array $3}

exprB:
      exprC                               { $1 }
    | exprB PLUS exprC                    { MessageSend (makeMessageSend $1 [makeParam "add$" (Some($3))]) }
    | exprB MOD exprC                     { MessageSend (makeMessageSend $1 [makeParam "mod$" (Some($3))]) }
    | exprB MINUS exprC                   { MessageSend (makeMessageSend $1 [makeParam "minus$" (Some($3))]) }
    | exprB CONCAT exprC                  { MessageSend (makeMessageSend $1 [makeParam "concat$" (Some($3))]) }
    | exprB OR exprC                      { MessageSend (makeMessageSend $1 [makeParam "or$" (Some($3))]) }

exprC : 
      exprD                               { $1 }
    | exprC TIMES exprD                   { MessageSend (makeMessageSend $1 [makeParam "mult$" (Some($3))]) }
    | exprC DIVIDE exprD                  { MessageSend (makeMessageSend $1 [makeParam "div$" (Some($3))]) }
    | exprC AND exprD                     { MessageSend (makeMessageSend $1 [makeParam "and$" (Some($3))]) }
    | glob_ident NEW                      { InitSend ($1)};

exprD :
      exprE                               { $1 }
    | exprD LT exprE                      { MessageSend (makeMessageSend $1 [makeParam "lt$" (Some($3))]) }
    | exprD LEQ exprE                     { MessageSend (makeMessageSend $1 [makeParam "leq$" (Some($3))]) }
    | exprD EQ exprE                      { MessageSend (makeMessageSend $1 [makeParam "eq$" (Some($3))]) }
    | exprD NEQ exprE                     { MessageSend (makeMessageSend $1 [makeParam "neq$" (Some($3))]) }
    | exprD GEQ exprE                     { MessageSend (makeMessageSend $1 [makeParam "geq$" (Some($3))]) }
    | exprD GT exprE                      { MessageSend (makeMessageSend $1 [makeParam "gt$" (Some($3))]) };

exprE :
      variable                            { $1 }
    | MINUS exprE                         { MessageSend (makeMessageSend $2 [makeParam "minus" None]) }
    | NOT exprE                           { MessageSend (makeMessageSend $2 [makeParam "not" None]) }
    | LPAR expr RPAR                      { $2 };

variable :
    | name                                { Variable ($1) }
    | HASH LPAR expr_list RPAR            { ExplicitArray ($3) }
    | NUMBER                              { Number ($1) }
    | CHAR                                { Char ($1) }
    | STRING                              { String ($1) }
    | TRUE                                { Boolean(1) }
    | FALSE                               { Boolean(0) };

name :  
      IDENT                               { makeName $1 !Lexer.currLine }
    | glob_ident                          { makeName $1 !Lexer.currLine };
