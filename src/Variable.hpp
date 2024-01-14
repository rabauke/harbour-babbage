#pragma once

#include <QtGlobal>
#include <QString>
#include <QMetaType>
#include <QDataStream>
#include <QVariantMap>


struct Variable {
  Q_GADGET

public:
  Q_PROPERTY(QString name MEMBER name)
  Q_PROPERTY(double value MEMBER value)
  Q_PROPERTY(bool is_protected MEMBER is_protected)

  static Variable create(const QVariantMap &map);

  QString name;
  double value{0};
  bool is_protected{false};
};


Q_DECLARE_METATYPE(Variable)


QDataStream &operator<<(QDataStream &out, const Variable &variable);
QDataStream &operator>>(QDataStream &in, Variable &variable);
