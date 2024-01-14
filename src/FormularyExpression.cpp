#include "FormularyExpression.hpp"


FormularyExpression FormularyExpression::create(const QVariantMap &map) {
  FormularyExpression result;
  result.expression = map[QString("expression")].toString();
  result.description = map[QString("description")].toString();
  return result;
}


QDataStream &operator<<(QDataStream &out, const FormularyExpression &expression) {
  out << expression.expression << expression.description;
  return out;
}


QDataStream &operator>>(QDataStream &in, FormularyExpression &expression) {
  in >> expression.expression >> expression.description;
  return in;
}
