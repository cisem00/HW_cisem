#include "Token.h"

// IntegerLiteral sınıfının tanımları
IntegerLiteral::IntegerLiteral(int value) : Token(L_INTEGER), m_value(value) {}

std::string IntegerLiteral::as_string() const {
    return fmt::format("INTEGER({})", m_value);
}

// StringLiteral sınıfının tanımları
StringLiteral::StringLiteral(const std::string& text) : Token(L_STRING), m_text(text) {}

std::string StringLiteral::as_string() const {
    return fmt::format("STRING(\"{}\")", m_text);
}

// Identifier sınıfının tanımları
Identifier::Identifier(const std::string& name) : Token(IDENTIFIER), m_name(name) {}

std::string Identifier::as_string() const {
    return fmt::format("IDENTIFIER({})", m_name);
}

// Keyword sınıfının tanımları
Keyword::Keyword(int id, const std::string& text) : Token(id), m_text(text) {}

std::string Keyword::as_string() const {
    return fmt::format("KEYWORD({})", m_text);
}

// Operator sınıfının tanımları
Operator::Operator(int id, const std::string& symbol) : Token(id), m_symbol(symbol) {}

std::string Operator::as_string() const {
    return fmt::format("OPERATOR({})", m_symbol);
}
