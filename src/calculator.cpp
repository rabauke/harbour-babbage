#include "calculator.hpp"
#include "math_parser.hpp"
#include <limits>
#include <cmath>
#include <QtDebug>

calculator::calculator(QObject *parent) : QObject(parent) {
  V.insert("pi", std::atan(1.)*4);
}

QString calculator::calculate(QString formula) {
  QString formula_plain=formula;
  formula_plain.replace("−", "-").
      replace("·", "*").
      replace("π", "pi").
      replace("√", "sqrt").
      replace("Γ", "Gamma");
  double res=std::numeric_limits<double>::quiet_NaN();
  QString err;
  try {
    res=P.value(formula_plain, V);
  }
  catch (std::exception &e) {
    qDebug() << e.what();
    err=e.what();
  }
  QString formula_tt=formula;
  formula_tt.replace(" ", "").
      replace("+"," + ").
      replace("−"," − ").
      replace("-"," − ").
      replace("·", " · ").
      replace("*", " · ").
      replace("/", " / ").
      replace("=", " = ").
      replace("pi", "π").
      replace("sqrt", "√").
      replace("Gamma", "Γ");
  QString res_str=QString::number(res, 'g', 12);
  res_str.replace(QRegularExpression("e[+](\\d+)"), " · 10^\\1").
      replace(QRegularExpression("e[-](\\d+)"), " · 10^(−\\1)").
      replace("-","−").
      replace("inf", "∞");
  if (err.isEmpty())
    return formula_tt+" = "+res_str;
  else
    return formula_tt+" = "+res_str+" ("+err+")";
}
