#ifndef CALCULATOR_H

#define CALCULATOR_H

#include <QObject>
#include <QString>
#include <QStringList>
#include "math_parser.hpp"

QString typeset(double x);

class calculator : public QObject {
  Q_OBJECT
  math_parser::arithmetic_parser P;
  math_parser::arithmetic_parser::var_map_t V;
  void init_variables();

public:
  explicit calculator(QObject *parent = 0);
  Q_INVOKABLE QVariantMap calculate(QString formula);
  Q_INVOKABLE void removeVariable(int);
  Q_INVOKABLE void clear();
  Q_INVOKABLE QVariantList getVariables() const;
  virtual ~calculator() {}

signals:

public slots:
};

#endif  // CALCULATOR_H
