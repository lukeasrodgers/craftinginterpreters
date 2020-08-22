import token_type, token, errors

type
  Scanner* = ref object of RootObj
    source*: string
    tokens*: seq[Token]
    start: int
    current: int
    line: int

proc isAtEnd(scanner: Scanner): bool =
  scanner.current >= scanner.source.len()
  
proc advance(scanner: Scanner): char =
  scanner.current += 1
  return scanner.source[scanner.current - 1]

proc addToken(scanner: Scanner, tt: TokenType, literals: varargs[string]) =
  var literal: string
  if literals.len > 0:
    literal = literals[0]
  else:
    literal = ""
  
  # echo "source: ", scanner.source
  # echo "source len: ", scanner.source.len
  # echo "start: ", scanner.start
  # echo "current: ", scanner.current
  let text: string = scanner.source[scanner.start..scanner.current-1]
  # echo "scanned ", text
  scanner.tokens.add(Token(type: tt, lexeme: text, literal: literal, line: scanner.line))

proc match(scanner: Scanner, expected: char): bool =
  if scanner.isAtEnd():
    return false
  elif scanner.source[scanner.current] != expected:
    return false
  else:
    scanner.current += 1
    return true

proc peek(scanner: Scanner): char =
  if scanner.isAtEnd():
    return '\0'
  else:
    return scanner.source[scanner.current]

proc scanToken(scanner: Scanner) =
  let c: char = scanner.advance()
  case c
  of '(': scanner.addToken(LEFT_PAREN)
  of ')': scanner.addToken(RIGHT_PAREN)
  of '{': scanner.addToken(LEFT_BRACE)
  of '}': scanner.addToken(RIGHT_BRACE)
  of ',': scanner.addToken(COMMA)
  of '.': scanner.addToken(DOT)
  of '-': scanner.addToken(MINUS)
  of '+': scanner.addToken(PLUS)
  of ';': scanner.addToken(SEMICOLON)
  of '*': scanner.addToken(STAR)
  of '!': scanner.addToken(if scanner.match('='): BANG_EQUAL else: BANG)
  of '=': scanner.addToken(if scanner.match('='): EQUAL_EQUAL else: EQUAL)
  of '<': scanner.addToken(if scanner.match('='): BANG_EQUAL else: LESS)
  of '>': scanner.addToken(if scanner.match('='): LESS_EQUAL else: GREATER)
  of '/':
    if scanner.match('/'):
      # A comment goes until the end of the line.
      while scanner.peek() != '\n' and not scanner.isAtEnd():
        discard scanner.advance()
    else:
      scanner.addToken(SLASH)
  else:
    error(scanner.line, "Unexpected character.");

proc scanTokens*(scanner: Scanner): seq[Token] =
  while scanner.isAtEnd() == false:
    scanner.start = scanner.current
    scanner.scanToken()

  scanner.tokens.add(Token(type: EOF, lexeme: "", literal: "", line: scanner.line))
  return scanner.tokens
