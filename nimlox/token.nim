import token_type
import strformat

type LitKind* = enum
  litString,
  litFloat,
  nilLit

type Lit* = object
  case litKind*: LitKind
  of litString: strLiteral*: string
  of litFloat: floatLiteral*: float
  of nilLit: nilLiteral*: float

type Token* = object
  `type`*: TokenType # wrap in ticks cuz type is keyword
  lexeme*: string
  literal*: Lit
  line*: int

# don't need to define toString on TokenType, cuz $ can handle enums
proc toString*(token: Token): string =
  return &"{$token.type} {token.lexeme}"

