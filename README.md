How to run lox java stuff

1. `cd lox/out/production/lox`
2. `java com.craftinginterpreters.lox.<ClassName> <args>`

E.g. running lox source

1. store it in `lox/`
2. `cd lox/out/production/lox`
2. `java com.craftinginterpreters.lox.Lox ../../../script.lox`


To use the AST generator:


1. `cd lox/out/production/lox`
2. `java com.craftinginterpreters.tool.GenerateAst ../../../src/com/craftinginterpreters/lox`

Not sure why it has to be precisely from this folder, "cuz Java".
