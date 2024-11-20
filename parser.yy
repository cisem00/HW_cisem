%{
#include "main.h"
#include "lexer.h"

#include <kiraz/ast/Operator.h>
#include <kiraz/ast/Literal.h>
#include <kiraz/token/Literal.h>

int yyerror(const char *msg);
extern std::shared_ptr<Token> curtoken;
extern int yylineno;
%}

%token    REJECTED

%token OP_LPAREN
%token OP_RPAREN

%token OP_PLUS
%token OP_MINUS
%token OP_DIVF
%token OP_MULT


%token L_INTEGER
%token KW_IMPORT
%token KW_FUNC
%token KW_IF
%token KW_WHILE
%token KW_CLASS
%token OP_LBRACE
%token OP_RBRACE
%token IDENTIFIER
%token L_STRING
%token KW_LET
%token OP_ASSIGN
%token OP_COLON
%token OP_COMMA


%left OP_PLUS OP_MINUS
%left OP_MULT OP_DIVF

%%

stmt:
      OP_LPAREN stmt OP_RPAREN             { $$ = $2; }
    | addsub
    | KW_FUNC IDENTIFIER OP_LPAREN param_list OP_RPAREN OP_LBRACE stmt_list OP_RBRACE
                                             { $$ = Node::add<FuncNode>($2, $4, $7); }
    | KW_LET IDENTIFIER OP_ASSIGN expr     { $$ = Node::add<LetNode>($2, $4); }
    | KW_CLASS IDENTIFIER OP_LBRACE stmt_list OP_RBRACE
                                             { $$ = Node::add<ClassNode>($2, $4); }
    ;

addsub:
      muldiv
    | stmt OP_PLUS stmt { $$ = Node::add<ast::OpAdd>($1, $3); }
    | stmt OP_MINUS stmt { $$ = Node::add<ast::OpSub>($1, $3); }
    ;

muldiv:
      posneg
    | stmt OP_MULT stmt { $$ = Node::add<ast::OpMul>($1, $3); }
    | stmt OP_DIVF stmt { $$ = Node::add<ast::OpDiv>($1, $3); }
    ;

posneg:
      L_INTEGER     { $$ = Node::add<ast::Integer>(curtoken); }
    | OP_PLUS stmt  { $$ = Node::add<ast::SignedNode>(OP_PLUS, $2);  }
    | OP_MINUS stmt { $$ = Node::add<ast::SignedNode>(OP_MINUS, $2); }
    ;    

param_list:
      /* boş parametre listesi */
    | IDENTIFIER OP_COLON IDENTIFIER       { $$ = Node::add<ParamNode>($1, $3); }
    | param_list OP_COMMA IDENTIFIER OP_COLON IDENTIFIER
                                             { $$ = Node::add<ParamList>($1, Node::add<ParamNode>($3, $5)); }
    ;

stmt_list:
      stmt
    | stmt_list stmt                       { $$ = Node::add<StmtList>($1, $2); }
    ;

expr:
      L_INTEGER                            { $$ = Node::add<IntegerNode>(curtoken); }
    | L_STRING                             { $$ = Node::add<StringNode>(curtoken); }
    | IDENTIFIER                           { $$ = Node::add<IdentifierNode>(curtoken); }
    | expr OP_PLUS expr                    { $$ = Node::add<OpAdd>($1, $3); }
    | expr OP_MINUS expr                   { $$ = Node::add<OpSub>($1, $3); }
    | expr OP_MULT expr                    { $$ = Node::add<OpMul>($1, $3); }
    | expr OP_DIVF expr                    { $$ = Node::add<OpDiv>($1, $3); }
    ;


%%

int yyerror(const char *s) {
    if (curtoken) {
        fmt::print("** Parser Error at {}:{} at token: {}\n",
            yylineno, Token::colno, curtoken->as_string());
    }
    else {
        fmt::print("** Parser Error at {}:{}, null token\n",
            yylineno, Token::colno);
    }
    Token::colno = 0;
    Node::reset_root();
    return 1;
}
