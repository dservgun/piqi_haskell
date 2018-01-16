{
module Lexer where 
import PiqParser
}

%wrapper "basic"

$digit = 0-9 
$alpha = [a-zA-Z]
$underscore = \_
$backquote = \'
$eolU = \n
$eolW = [\r\n]
$space = \b
$tab = \t
$semicolon = [\;]
$openBrace = [\{]
$closeBrace = [\}]

tokens :- 
  $white+   ;
  $eolU      ;      
  $eolW      ;
  $semicolon        {\s -> TokenEol}
  "%".*             { \(s:rest) -> TokenComment rest }
  alias             { \s -> TokenAlias }
  int               { \s -> TokenType s }
  bool              { \s -> TokenType s }
  uint64            { \s -> TokenType s }
  message           { \s -> TokenMessage s}
  required          { \s -> TokenRequired s} 
  optional          { \s -> TokenOptional s}
  openBrace         { \s -> TokenOpenBrace s}
  closeBrace        { \s -> TokenCloseBrace s}
  $alpha [$alpha $digit]+ {\s -> TokenIdentifier s }

{
parse = parser . alexScanTokens
}