{
module PiqParser where 
import Data.Monoid((<>))
}

%name parser 
%name parse_message Message 
%name parse_alias Alias
%tokentype { Token } 
%error {parseError}

%token 
  alias   { TokenAlias }
  eol     { TokenEol }
  tokenType { TokenType aString } 
  message { TokenMessage }
  identifier { TokenIdentifier aString }
  openBrace { TokenOpenBrace } 
  closeBrace { TokenCloseBrace }
%% 

Statements : Statement {[$1]} | Statements eol Statement {$3 : $1}
Statement : Message {$1} | Alias {$1}
Message : message Identifier openBrace Fields closeBrace {makeMessage $2 $4}
Alias : alias Identifier TokenType {makeAlias $2 $3}
Identifier : identifier {$1}
TokenType : tokenType   { $1 }
Fields : Field {[$1]} | Fields eol Field { $3 : $1}
Field : identifier TokenType { makeField $1 $2}

{

makeMessage (TokenIdentifier aString) fields = 
  Message aString fields

makeAlias (TokenIdentifier aString) (TokenType bString) 
  = Alias (aString) (aString)

makeField (TokenIdentifier aString) (TokenType bString) 
  = Field aString bString

data TypeUnifier = 
  Message String [Field]
  | Alias String String deriving(Show)

type Name = String 
type FieldType = String
data Field = Field Name FieldType deriving (Show)
data Token = 
  TokenAlias  
  | TokenComment String 
  | TokenType String 
  | TokenIdentifier String
  | TokenRequired String 
  | TokenOptional String
  | TokenOpenBrace | TokenCloseBrace
  | TokenEol
  | TokenMessage
  deriving (Show)

parseError :: [Token] -> a 
parseError aToken = error $ "Parse error" <> (show aToken)

}