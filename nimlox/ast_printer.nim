import expr, token_type, token, strutils
import typeinfo

type
  AstPrinter = ref object of Visitor

method parenthesize(astPrinter: AstPrinter, name: string, exprs: varargs[Expr]): string

# need to use --multimethods:on for this to work :/
method print(astPrinter: AstPrinter, expr: Expr): string {.base.} =
  quit "to override"

method print(astPrinter: AstPrinter, expr: Binary): string =
  astPrinter.parenthesize(expr.operator.lexeme, expr.left, expr.right)

method print(astPrinter: AstPrinter, expr: Grouping): string =
  astPrinter.parenthesize("group", expr.expression)

method print(astPrinter: AstPrinter, expr: Literal): string =
  case expr.litKind
  of litString: return expr.strLiteral
  of litFloat: return expr.floatLiteral.formatFloat() # NB! you can call strLiteral here and compiler will not complain
  of nilLit: return ""

method print(astPrinter: AstPrinter, expr: Unary): string =
  astPrinter.parenthesize(expr.operator.lexeme, expr.right);

# see note about multimethods
method parenthesize(astPrinter: AstPrinter, name: string, exprs: varargs[Expr]): string =
  var s = "("
  s.add(name)
  for expr in items(exprs):
    s.add(" ")
    s.add(astPrinter.print(expr))
  s.add(")")
  s

let nilLit: Lit = Lit(litKind: nilLit, nilLiteral: 0.0)
let ttm = Token(type: TokenType.MINUS, lexeme: "-", literal: nilLit, line: 1)
let nlit: Literal = Literal(floatLiteral: 123, litKind: litFloat)
let unary: Unary = Unary(operator: ttm, right: nlit)
let tt = Token(type: TokenType.STAR, lexeme: "*", literal: nilLit, line: 1)
let g: Grouping = Grouping(expression: Literal(floatLiteral: 45.67, litKind: litFloat))

let b: Binary = Binary(left: unary, operator: tt, right: g)

let ap: AstPrinter = AstPrinter()
echo ap.print(b)
