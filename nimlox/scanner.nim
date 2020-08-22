import token_type, token, errors
import strutils, typeinfo, tables

type
  Scanner* = ref object of RootObj
    source*: string
    tokens*: seq[Token]
    start: int
    current: int
    line: int

var keywords = initTable[string, TokenType]()
keywords["and"] = AND
keywords["class"] = CLASS
keywords["else"] = ELSE
keywords["false"] = FALSE
keywords["for"] = FOR
keywords["fun"] = FUN
keywords["if"] = IF
keywords["nil"] = NIL
keywords["or"] = OR
keywords["print"] = PRINT
keywords["return"] = RETURN
keywords["super"] = SUPER
keywords["this"] = THIS
keywords["true"] = TRUE
keywords["var"] = VAR
keywords["while"] = WHILE

proc isAtEnd(scanner: Scanner): bool =
  scanner.current >= scanner.source.len()
  
proc advance(scanner: Scanner): char =
  scanner.current += 1
  return scanner.source[scanner.current - 1]

proc addToken(scanner: Scanner, tt: TokenType, lit: Lit) =

  # echo "source: ", scanner.source
  # echo "source len: ", scanner.source.len
  # echo "start: ", scanner.start
  # echo "current: ", scanner.current
  let text: string = scanner.source[scanner.start..scanner.current-1]
  # echo "scanned ", text
  scanner.tokens.add(Token(type: tt, lexeme: text, literal: lit, line: scanner.line))

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

proc peekNext(scanner: Scanner): char =
  if scanner.current + 1 >= scanner.source.len:
    return '\0'
  return scanner.source[scanner.current + 1]

proc string(scanner: Scanner) =
  while scanner.peek() != '"' and not scanner.isAtEnd():
    if scanner.peek() == '\n':
      scanner.line += 1
    discard scanner.advance()

    # Unterminated string.
  if scanner.isAtEnd():
    error(scanner.line, "Unterminated string.")
    return

  # The closing ".
  discard scanner.advance()

  # Trim the surrounding quotes.
  let value = scanner.source[(scanner.start + 1)..(scanner.current - 2)]
  var lit: Lit
  lit = Lit(litKind: litString, strLiteral: value)
  scanner.addToken(STRING, lit)

proc isDigit(scanner: Scanner, c: char): bool =
  c >= '0' and c <= '9'

proc isAlpha(scanner: Scanner, c: char): bool =
  return (c >= 'a' and c <= 'z') or
           (c >= 'A' and c <= 'Z') or
            c == '_'

proc isAlphaNumeric(scanner: Scanner, c: char): bool =
  return scanner.isAlpha(c) or scanner.isDigit(c);

proc identifier(scanner: Scanner) =
  while scanner.isAlphaNumeric(scanner.peek()):
    discard scanner.advance()

  let text: string = scanner.source[scanner.start..(scanner.current - 1)]
  let tt: TokenType = if keywords.hasKey(text):
    keywords[text]
  else:
    IDENTIFIER

  let nilLit: Lit = LIt(litKind: nilLit, nilLiteral: 0.0)
  scanner.addToken(tt, nilLit)

proc number(scanner: Scanner) =
  while scanner.isDigit(scanner.peek()):
    discard scanner.advance()

  # Look for a fractional part.
  if (scanner.peek() == '.' and scanner.isDigit(scanner.peekNext())):
    # Consume the "."
    discard scanner.advance()

    while scanner.isDigit(scanner.peek()):
      discard scanner.advance()

  var lit: Lit
  lit = Lit(litKind: litFloat, floatLiteral: parseFloat(scanner.source[scanner.start..(scanner.current - 1)]))
  scanner.addToken(NUMBER, lit)


proc scanToken(scanner: Scanner) =
  let c: char = scanner.advance()
  let nilLit: Lit = LIt(litKind: nilLit, nilLiteral: 0.0)
  case c
  of '(': scanner.addToken(LEFT_PAREN, nilLit)
  of ')': scanner.addToken(RIGHT_PAREN, nilLit)
  of '{': scanner.addToken(LEFT_BRACE, nilLit)
  of '}': scanner.addToken(RIGHT_BRACE, nilLit)
  of ',': scanner.addToken(COMMA, nilLit)
  of '.': scanner.addToken(DOT, nilLit)
  of '-': scanner.addToken(MINUS, nilLit)
  of '+': scanner.addToken(PLUS, nilLit)
  of ';': scanner.addToken(SEMICOLON, nilLit)
  of '*': scanner.addToken(STAR, nilLit)
  of '!': scanner.addToken(if scanner.match('='): BANG_EQUAL else: BANG, nilLit)
  of '=': scanner.addToken(if scanner.match('='): EQUAL_EQUAL else: EQUAL, nilLit)
  of '<': scanner.addToken(if scanner.match('='): BANG_EQUAL else: LESS, nilLit)
  of '>': scanner.addToken(if scanner.match('='): LESS_EQUAL else: GREATER, nilLit)
  of '/':
    if scanner.match('/'):
      # A comment goes until the end of the line.
      while scanner.peek() != '\n' and not scanner.isAtEnd():
        discard scanner.advance()
    else:
      scanner.addToken(SLASH, nilLit)
  of ' ', '\r', '\t':
    discard
    # ignore whitespace
  of '\n':
    scanner.line += 1
  of '"':
    scanner.string()
  else:
    if scanner.isDigit(c):
      scanner.number()
    elif scanner.isAlpha(c):
      scanner.identifier()
    else:
      error(scanner.line, "Unexpected character.");

proc scanTokens*(scanner: Scanner): seq[Token] =
  while scanner.isAtEnd() == false:
    scanner.start = scanner.current
    scanner.scanToken()

  let lit: Lit = Lit(litKind: nilLit, nilLiteral: 0.0)
  scanner.tokens.add(Token(type: EOF, lexeme: "", literal: lit, line: scanner.line))
  return scanner.tokens
