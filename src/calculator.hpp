#ifndef CALCULATOR_H

#define CALCULATOR_H

#include <QObject>
#include <QString>
#include "math_parser.hpp"

class calculator : public QObject {
  Q_OBJECT
  math_parser::arithmetic_parser P;
  math_parser::arithmetic_parser::var_map_t V;
public:
  explicit calculator(QObject *parent = 0);
  Q_INVOKABLE QString calculate(QString formula);
  Q_INVOKABLE void clear();
  virtual ~calculator() { }

signals:

public slots:
};

#endif // CALCULATOR_H
