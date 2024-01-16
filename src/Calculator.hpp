#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
#include <QtQmlIntegration>
#endif
#include "math_parser.hpp"
#include "VariablesListModel.hpp"


class Calculator : public QObject {
  Q_OBJECT
public:
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(Calculator)
#endif

  explicit Calculator(QObject *parent = nullptr);
  virtual ~Calculator();

  Q_INVOKABLE QVariantMap calculate(QString formula);
  Q_INVOKABLE QString typeset(QString formula) const;

  Q_PROPERTY(VariablesListModel *variables READ getVariables NOTIFY variablesChanged)

signals:
  void variablesChanged();

private:
  VariablesListModel *getVariables();
  void init_variables();

  math_parser::arithmetic_parser m_parser;
  math_parser::arithmetic_parser::var_map_t m_variables_map;
  VariablesListModel m_variables;

  static QString typeset_value(double x);
  static QString get_settings_path();
};
