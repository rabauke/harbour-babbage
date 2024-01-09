#pragma once

#include <QtGlobal>
#include <QString>
#include <QMetaType>
#include <QDataStream>


struct FormularyExpression {
  Q_GADGET

  Q_PROPERTY(QString expression MEMBER expression)
  Q_PROPERTY(QString description MEMBER description)

public:
  QString expression;
  QString description;
};


Q_DECLARE_METATYPE(FormularyExpression)


QDataStream &operator<<(QDataStream &out, const FormularyExpression &expression);
QDataStream &operator>>(QDataStream &in, FormularyExpression &expression);
