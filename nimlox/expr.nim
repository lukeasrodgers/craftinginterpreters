import token

type
  Visitor* = ref object of RootObj

type
  Expr* = ref object of RootObj
  Binary* = ref object of Expr
    left*: Expr
    operator*: Token
    right*: Expr
  Grouping* = ref object of Expr
    expression*: Expr
  Literal* = ref object of Expr
    case litKind*: LitKind
      of litString: strLiteral*: string
      of litFloat: floatLiteral*: float
      of nilLit: nilLiteral*: float
  Unary* = ref object of Expr
    operator*: Token
    right*: Expr

method visitBinaryExpr*(visitor: Visitor, expr: Binary) {.base.} =
  quit "to override"

method visitGroupingExpr*(visitor: Visitor, expr: Grouping) {.base} =
  quit "to override"

method visitLiteralExpr*(visitor: Visitor, expr: Literal) {.base} =
  quit "to override"

method visitUnaryExpr*(visitor: Visitor, expr: Unary) {.base} =
  quit "to override"

method accept*(expr: Expr) {.base.} =
  quit "to override"

method accept*(expr: Binary, visitor: Visitor) =
  visitor.visitBinaryExpr(expr)

method accept*(expr: Grouping, visitor: Visitor) =
  visitor.visitGroupingExpr(expr)

method accept*(expr: Literal, visitor: Visitor) =
  visitor.visitLiteralExpr(expr)

method accept*(expr: Unary, visitor: Visitor) =
  visitor.visitUnaryExpr(expr)
