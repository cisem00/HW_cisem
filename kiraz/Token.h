#ifndef KIRAZ_TOKEN_H
#define KIRAZ_TOKEN_H

#include "main.h"

#include <fmt/format.h>

class Token {
public:
    using Ptr = std::shared_ptr<Token>;
    using Cptr = std::shared_ptr<const Token>;

    Token(int id) : m_id(id) {}
    virtual ~Token();

    static auto New() {}

    virtual std::string as_string() const = 0;
    void print() { fmt::print("{}\n", as_string()); }

    template <typename T, typename... Args>
    static auto New(Args &&...args) {
        return std::make_shared<T>(std::forward<Args>(args)...);
    }

    static int colno;

    auto get_id() const { return m_id; }

private:
    int m_id;
};

class Rejected : public Token {
public:
    Rejected(const char *text) : Token(REJECTED), m_text(text) {}
    std::string as_string() const override { return fmt::format("REJECTED({})", m_text); }

private:
    std::string m_text;
};

// Anahtar kelimeler için bir örnek sınıf (KW_FUNC, KW_CLASS gibi)
class Keyword : public Token {
public:
    Keyword(int id, const std::string& text) : Token(id), m_text(text) {}
    std::string as_string() const override { return fmt::format("KEYWORD({})", m_text); }

private:
    std::string m_text;
};

// Operatörler için bir örnek sınıf
class Operator : public Token {
public:
    Operator(int id, const std::string& symbol) : Token(id), m_symbol(symbol) {}
    std::string as_string() const override { return fmt::format("OPERATOR({})", m_symbol); }

private:
    std::string m_symbol;
};

// Integer Literals
class IntegerLiteral : public Token {
public:
    IntegerLiteral(int value) : Token(L_INTEGER), m_value(value) {}
    std::string as_string() const override { return fmt::format("INTEGER({})", m_value); }

private:
    int m_value;
};

// String Literals
class StringLiteral : public Token {
public:
    StringLiteral(const std::string& text) : Token(L_STRING), m_text(text) {}
    std::string as_string() const override { return fmt::format("STRING(\"{}\")", m_text); }

private:
    std::string m_text;
};

// Tanımlayıcılar (Identifiers)
class Identifier : public Token {
public:
    Identifier(const std::string& name) : Token(IDENTIFIER), m_name(name) {}
    std::string as_string() const override { return fmt::format("IDENTIFIER({})", m_name); }

private:
    std::string m_name;
};

#endif // KIRAZ_TOKEN_H
