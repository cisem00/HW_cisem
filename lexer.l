
%option noyywrap

%{
// https://stackoverflow.com/questions/9611682/flexlexer-support-for-unicode/9617585#9617585
#include "parser.hpp"
#include "main.h"
#include <kiraz/token/Literal.h>
#include <kiraz/token/Operator.h>
static auto &colno = Token::colno;
using namespace token;
extern std::shared_ptr<Token> curtoken;
%}

%option yylineno

%%

[0-9]+   {colno += yyleng; curtoken = Token::New<Integer>(10, yytext); return L_INTEGER; }    

"+"  {colno += yyleng; curtoken = Token::New<OpPlus>(); return OP_PLUS; }   
"-"  {colno += yyleng; curtoken = Token::New<OpMinus>(); return OP_MINUS; }   
"*"  {colno += yyleng; curtoken = Token::New<OpMult>(); return OP_MULT; }   
"/"  {colno += yyleng; curtoken = Token::New<OpDivF>(); return OP_DIVF; }   
"("  {colno += yyleng; curtoken = Token::New<OpLparen>(); return OP_LPAREN; }   
")"  {colno += yyleng; curtoken = Token::New<OpRparen>(); return OP_RPAREN; }  

"import"          { colno += yyleng; curtoken = Token::New<KwImport>(); return KW_IMPORT; }
"func"            { colno += yyleng; curtoken = Token::New<KwFunc>(); return KW_FUNC; }
"if"              { colno += yyleng; curtoken = Token::New<KwIf>(); return KW_IF; }
"while"           { colno += yyleng; curtoken = Token::New<KwWhile>(); return KW_WHILE; }
"class"           { colno += yyleng; curtoken = Token::New<KwClass>(); return KW_CLASS; }
"let"            { colno += yyleng; curtoken = Token::New<KwLet>(); return KW_LET; }
"="              { colno += yyleng; curtoken = Token::New<OpAssign>(); return OP_ASSIGN; }
":"              { colno += yyleng; curtoken = Token::New<OpColon>(); return OP_COLON; }
","              { colno += yyleng; curtoken = Token::New<OpComma>(); return OP_COMMA; }


"{"               { colno += yyleng; curtoken = Token::New<OpLBrace>(); return OP_LBRACE; }
"}"               { colno += yyleng; curtoken = Token::New<OpRBrace>(); return OP_RBRACE; }

[_a-zA-Z][_a-zA-Z0-9]* { colno += yyleng; curtoken = Token::New<Identifier>(yytext); return IDENTIFIER; }
\"(\\.|[^\\"])*\"      { colno += yyleng; curtoken = Token::New<StringLiteral>(yytext); return L_STRING; }


[ \n\t]+ {colno += yyleng;}
.        {colno += yyleng; curtoken = Token::New<Rejected>(); return YYUNDEF; }