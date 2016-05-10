#include "calculator.hpp"
#include "math_parser.hpp"
#include <limits>
#include <cmath>
#include <QtDebug>

calculator::calculator(QObject *parent) : QObject(parent) {
  V.insert("pi", std::atan(1.)*4);
}

QString calculator::calculate(QString formula) {
  double res=std::numeric_limits<double>::quiet_NaN();
  QString err;
  try {
    res=P.value(formula, V);
  }
  catch (std::exception &e) {
    qDebug() << e.what();
    err=e.what();
  }
  QString res_str=formula+"=";
  res_str=res_str.replace(" ", "").
      replace("+"," + ").
      replace("-"," − ").
      replace("*", " · ").
      replace("/", " / ").
      replace("=", " = ").
      replace("pi", "π").
      replace("sqrt", "√").
      replace("Gamma", "Γ") + (QString::number(res, 'g', 12).replace("-","−"));
  res_str.replace("inf", "∞");
  if (err!="")
    res_str+=" ("+err+")";
  return res_str;
}
