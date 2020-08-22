import token_type
import strformat

type Token* = ref object of RootObj
  `type`*: TokenType # wrap in ticks cuz type is keyword
  lexeme*: string
  literal*: string # wrong, should be Object .... what is this in nim?
  line*: int

# don't need to define toString on TokenType, cuz $ can handle enums
proc toString*(token: Token): string =
  return &"{$token.type} {token.lexeme} {token.literal}"

