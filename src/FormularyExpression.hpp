#pragma once

#include <QtGlobal>
#include <QString>
#include <QMetaType>
#include <QDataStream>
#include <QVariantMap>


struct FormularyExpression {
  Q_GADGET

public:
  Q_PROPERTY(QString expression MEMBER expression)
  Q_PROPERTY(QString description MEMBER description)

  static FormularyExpression create(const QVariantMap &map);

  QString expression;
  QString description;
};


Q_DECLARE_METATYPE(FormularyExpression)


QDataStream &operator<<(QDataStream &out, const FormularyExpression &expression);
QDataStream &operator>>(QDataStream &in, FormularyExpression &expression);
