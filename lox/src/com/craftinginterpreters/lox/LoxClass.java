package com.craftinginterpreters.lox;

import java.util.Map;
import java.util.List;

public class LoxClass {
    final String name;

    LoxClass(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return name;
    }
}
