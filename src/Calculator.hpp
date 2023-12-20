#ifndef CALCULATOR_H

#define CALCULATOR_H

#include <QObject>
#include <QString>
#include <QStringList>
#include "math_parser.hpp"


class Calculator : public QObject {
  Q_OBJECT
  math_parser::arithmetic_parser P;
  math_parser::arithmetic_parser::var_map_t V;
  void init_variables();

  static QString typeset(double x);
  static QString get_settings_path();

public:
  explicit Calculator(QObject *parent = nullptr);
  virtual ~Calculator();

  Q_INVOKABLE QVariantMap calculate(QString formula);
  Q_INVOKABLE void removeVariable(int);
  Q_INVOKABLE void clear();
  Q_INVOKABLE QVariantList getVariables() const;

  Q_PROPERTY(QVariantList variables READ getVariables NOTIFY variablesChanged)

signals:
  void variablesChanged();

public slots:
};

#endif  // CALCULATOR_H
