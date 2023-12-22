#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
#include <QtQmlIntegration>
#endif
#include "math_parser.hpp"


class Calculator : public QObject {
  Q_OBJECT
public:
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(AppModel)
#endif

  explicit Calculator(QObject *parent = nullptr);
  virtual ~Calculator();

  Q_INVOKABLE QVariantMap calculate(QString formula);
  Q_INVOKABLE void removeVariable(int);
  Q_INVOKABLE void clear();

  Q_PROPERTY(QVariantList variables READ getVariables NOTIFY variablesChanged)

signals:
  void variablesChanged();

private:
  QVariantList getVariables() const;
  void init_variables();

  math_parser::arithmetic_parser m_parser;
  math_parser::arithmetic_parser::var_map_t m_variables;

  static QString typeset(double x);
  static QString get_settings_path();
};
