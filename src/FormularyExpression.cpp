#include "FormularyExpression.hpp"

QDataStream &operator<<(QDataStream &out, const FormularyExpression &expression) {
  out << expression.expression << expression.description;
  return out;
}


QDataStream &operator>>(QDataStream &in, FormularyExpression &expression) {
  in >> expression.expression >> expression.description;
  return in;
}
