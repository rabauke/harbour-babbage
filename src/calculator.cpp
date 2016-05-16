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
  QRegularExpression assignment_regex(R"(^\s*([[:alpha:]]\w*)\s*=\s*(.*))");
  QRegularExpression formula_regex(R"(^\s*\S.*)");

  double res=std::numeric_limits<double>::quiet_NaN();
  QString err;
  try {
    auto match=assignment_regex.match(formula_plain);
    if (match.hasMatch()) {
      QString var_name=match.capturedRef(1).toString();
      V[var_name]=res;
      res=P.value(match.capturedRef(2).toString(), V);
      V[var_name]=res;
    } else
      res=P.value(formula_plain, V);
  }
  catch (std::exception &e) {
    err=e.what();
  }
  QString res_str=QString::number(res, 'g', 12);
  res_str.replace(QRegularExpression(R"(e[+](\d+))"), R"( · 10^\1)").
      replace(QRegularExpression(R"(e[-](\d+))"), R"( · 10^(−\1))").
      replace("-","−").
      replace("inf", "∞");
  QString formula_tt=formula+" = "+res_str;
  formula_tt.replace(" ", "").
      replace("+"," + ").
      replace("−"," − ").
      replace("-"," − ").
      replace("·", " · ").
      replace("*", " · ").
      replace("/", " / ").
      replace("=", " = ").
      replace(",", ", ").
      replace(QRegularExpression(R"(\bpi\b)"), "π").
      replace(QRegularExpression(R"(\bsqrt\b)"), "√").
      replace(QRegularExpression(R"(\bGamma\b)"), "Γ").
      replace("  ", " ").
      replace(QRegularExpression(R"(^\s*)"), "");
  if (err.isEmpty())
    return formula_tt;
  else
    return formula_tt+" ("+err+")";
}


void calculator::clear() {
  V.clear();
  V.insert("pi", std::atan(1.)*4);
}
