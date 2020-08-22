import os
import strformat

import token_type, token, scanner

var c = paramCount()

type 
  Lox* = ref object of RootObj
    paramCount: int
    hadError: bool

var lox*: Lox
lox = Lox(paramCount: c, hadError: false)

proc run(lox: Lox, source: string) =
  var scanner: Scanner
  scanner = Scanner(source: source)
  var tokens: seq[Token] = scanner.scanTokens();
  
  for i in 0..<tokens.len:
    let t = tokens[i]
    echo t.toString()

proc runPrompt(lox: Lox) =
  while true:
    stdout.write "> "
    let line = readLine(stdin)
    if line == "":
      break
    lox.run(line)
    lox.hadError = false

proc runFile(lox: Lox, path: string) =
  let file = readFile(path)
  lox.run(file)
  if lox.hadError == true:
    discard os.exitStatusLikeShell(65)

if c > 1:
  echo "Usage: nlox [scrip]"
  discard os.exitStatusLikeShell(64)
elif c == 1:
  lox.runFile(os.commandLineParams()[0])
else:
  lox.runPrompt();

