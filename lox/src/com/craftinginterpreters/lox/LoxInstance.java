package com.craftinginterpreters.lox;

import java.util.Map;
import java.util.HashMap;

public class LoxInstance {
    private LoxClass klass;

    LoxInstance(LoxClass klass) {
        this.klass = klass;
    }

    @Override
    public String toString() {
        return klass.name + " instance";
    }
}
