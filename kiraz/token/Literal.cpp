#include "Literal.h"

namespace token {

// StringLiteral sınıfının yapıcı fonksiyonu
StringLiteral::StringLiteral(const std::string& text) : Token(L_STRING), m_text(text) {}

// IntegerLiteral sınıfının yapıcı fonksiyonu (eğer IntegerLiteral sınıfı da varsa)
IntegerLiteral::IntegerLiteral(int value) : Token(L_INTEGER), m_value(value) {}

} // namespace token
