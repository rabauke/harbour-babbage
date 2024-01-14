#include "Variable.hpp"


Variable Variable::create(const QVariantMap &map) {
  Variable result;
  result.name = map[QString("name")].toString();
  result.value = map[QString("value")].toDouble();
  result.is_protected = map[QString("is_protected")].toBool();
  return result;
}


QDataStream &operator<<(QDataStream &out, const Variable &variable) {
  out << variable.name << variable.value;
  return out;
}


QDataStream &operator>>(QDataStream &in, Variable &variable) {
  in >> variable.name >> variable.value;
  return in;
}
