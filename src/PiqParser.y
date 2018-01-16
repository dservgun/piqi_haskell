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
  tokenType { TokenType aString} 
  message {TokenMessage aString}
  identifier { TokenIdentifier aString }

%% 
Statements : Statement {[$1]} | Statements eol Statement {$3 : $1}
Statement : Message {$1} | Alias {$1}
Message : message Identifier {makeMessage $2}
Alias : alias Identifier TokenType {makeAlias $2 $3}
Identifier : identifier {$1}
TokenType : tokenType   { $1}

{

makeMessage (TokenIdentifier aString) = 
  Message aString

makeAlias (TokenIdentifier aString) (TokenType bString) 
  = Alias (aString) (aString)

data TypeUnifier = 
  Message String  
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
  | TokenOpenBrace String
  | TokenCloseBrace String
  | TokenEol
  | TokenMessage String
  deriving (Show)

parseError :: [Token] -> a 
parseError aToken = error $ "Parse error" <> (show aToken)

}