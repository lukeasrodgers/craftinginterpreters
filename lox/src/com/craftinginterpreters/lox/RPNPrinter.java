package com.craftinginterpreters.lox;

// Print out RPN notation for
class RPNPrinter implements Expr.Visitor<String> {
    String print(Expr expr) {
        return expr.accept(this);
    }

    public static void main(String[] args) {
        Expr expression = new Expr.Binary(
                new Expr.Binary(
                        new Expr.Literal(1),
                        new Token(TokenType.PLUS, "+", null, 1),
                        new Expr.Literal(2)
                ),
                new Token(TokenType.STAR, "*", null, 1),
                new Expr.Binary(
                        new Expr.Literal(4),
                        new Token(TokenType.MINUS, "-", null, 1),
                        new Expr.Literal(3)
                )
        );

        System.out.println(new RPNPrinter().print(expression));
    }

    @Override
    public String visitBinaryExpr(Expr.Binary expr) {
        return rpnify(expr.operator.lexeme, expr.left, expr.right);
    }

    @Override
    public String visitGroupingExpr(Expr.Grouping expr) {
        return rpnify("group", expr.expression);
    }

    @Override
    public String visitLiteralExpr(Expr.Literal expr) {
        if (expr.value == null) return "nil";
        return expr.value.toString();
    }

    @Override
    public String visitUnaryExpr(Expr.Unary expr) {
        return rpnify(expr.operator.lexeme, expr.right);
    }

    @Override
    public String visitVariableExpr(Expr.Variable expr) {
        return rpnify(expr.name.lexeme);
    }

    @Override
    public String visitAssignExpr(Expr.Assign expr) {
        return rpnify(expr.name.lexeme, expr);
    }

    @Override
    public String visitLogicalExpr(Expr.Logical expr) {
        return rpnify(expr.operator.lexeme, expr.left, expr.right);
    }

    private String rpnify(String name, Expr... exprs) {
        StringBuilder builder = new StringBuilder();


        for (Expr expr : exprs) {
            builder.append(expr.accept(this));
            builder.append(" ");
        }
        builder.append(name);


        return builder.toString();
    }
}
