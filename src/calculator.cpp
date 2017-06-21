#include "calculator.hpp"
#include "math_parser.hpp"
#include <limits>
#include <cmath>
#include <QtDebug>
#include <QStringList>


QString typeset(double x) {
  return QString::number(x, 'g', 12).
      replace(QRegularExpression(R"(e[+](\d+))"), R"( · 10^\1)").
      replace(QRegularExpression(R"(e[-](\d+))"), R"( · 10^(−\1))").
      replace("-","−").
      replace("inf", "∞");
}

//---------------------------------------------------------------------

void calculator::init_variables() {
  V.insert("pi", std::atan(1.)*4);
  V.insert("e", std::exp(1.));
}

calculator::calculator(QObject *parent) : QObject(parent) {
  init_variables();
}

QVariantMap calculator::calculate(QString formula) {
  QString formula_plain=formula;
  formula_plain.replace("−", "-").
      replace("·", "*").
      replace("π", "pi").
      replace("√", "sqrt").
      replace("Γ", "Gamma").
      replace("γ", "gamma").
      replace(QRegularExpression(R"(\bdeg\b)"), "°");
  QRegularExpression assignment_regex(R"(^\s*([[:alpha:]]\w*)\s*=\s*(.*))");
  QRegularExpression formula_regex(R"(^\s*\S.*)");

  double res=std::numeric_limits<double>::quiet_NaN();
  QString err;
  try {
    auto match=assignment_regex.match(formula_plain);
    if (match.hasMatch()) {
      QString var_name=match.capturedRef(1).toString();
      if (var_name=="pi" or var_name=="e")
        throw std::runtime_error("protected variable");
      res=P.value(match.capturedRef(2).toString(), V);
      V[var_name]=res;
    } else
      res=P.value(formula_plain, V);
  }
  catch (std::exception &e) {
    err=e.what();
  }
  QString res_str=typeset(res);
  formula.replace(" ", "").
      replace("+"," + ").
      replace("−"," − ").
      replace("-"," − ").
      replace("·", " · ").
      replace("*", " · ").
      replace("/", " / ").
      replace("=", " = ").
      replace(",", ", ").
      replace(QRegularExpression(R"(\bdeg\b)"), "°").
      replace(QRegularExpression(R"(\bpi\b)"), "π").
      replace(QRegularExpression(R"(\bsqrt\b)"), "√").
      replace(QRegularExpression(R"(\bGamma\b)"), "Γ").
      replace(QRegularExpression(R"(\bgamma\b)"), "γ").
      replace("  ", " ").
      replace(QRegularExpression(R"(^\s*)"), "");
  QVariantMap res_map;
  res_map.insert("formula", formula);
  if (err.isEmpty())
    res_map.insert("result", res_str);
  else
    res_map.insert("result", res_str+" ("+err+")");
  return res_map;
}

void calculator::removeVariable(int i) {
  auto j=V.begin();
  std::advance(j, i);
  auto j_end=j;
  j_end++;
  V.erase(j, j_end);
}

void calculator::clear() {
  V.clear();
  init_variables();
}

QVariantList calculator::getVariables() const {
  QVariantList list;
  for (const auto &x: V) {
    QString value_str=typeset(x.second);
    QString name_str=x.first;
    if (name_str=="pi")
      name_str="π";
    list.append(name_str+" = "+value_str);
  }
  return list;
}
