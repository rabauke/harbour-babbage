#include "constants.hpp"
#include "Calculator.hpp"
#include "math_parser.hpp"
#include <limits>
#include <cmath>
#include <QtDebug>
#include <QStringList>
#include <QSettings>
#include <QStandardPaths>
#include <QCoreApplication>


Calculator::Calculator(QObject *parent) : QObject(parent) {
  static const QRegularExpression variable_regex{R"(^[[:alpha:]]\w*$)"};

  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  const auto variables{settings.allKeys()};
  for (const auto &variable : variables) {
    if (variable_regex.match(variable).hasMatch()) {
      auto value{settings.value(variable)};
      bool success;
      const auto valueAsDouble{value.toDouble(&success)};
      if (success)
        V.insert(variable, valueAsDouble);
    }
  }
  settings.endGroup();

  init_variables();
}


Calculator::~Calculator() {
  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  settings.remove("");
  for (const auto &variable : V)
    settings.setValue(variable.first, variable.second);
  settings.endGroup();
  settings.sync();
}


void Calculator::init_variables() {
  V.insert("pi", constants::pi);
  V.insert("e", constants::e);
}


QVariantMap Calculator::calculate(QString formula) {
  static const QRegularExpression pi_regex{R"(\bpi\b)"};
  static const QRegularExpression sqrt_regex{R"(\bsqrt\b)"};
  static const QRegularExpression Gamma_regex{R"(\bGamma\b)"};
  static const QRegularExpression gamma_regex{R"(\bgamma\b)"};
  static const QRegularExpression leading_spaces_regex{R"(^\s*)"};
  static const QRegularExpression assignment_regex{R"(^\s*([[:alpha:]]\w*)\s*=\s*(.*))"};
  static const QRegularExpression binary_operator_regex{R"(([=+−·/]))"};

  QString formula_plain{formula};
  formula_plain.replace("−", "-")
      .replace("·", "*")
      .replace("π", "pi")
      .replace("√", "sqrt")
      .replace("Γ", "Gamma")
      .replace("γ", "gamma");
  double res{std::numeric_limits<double>::quiet_NaN()};
  QString error;
  QString var_name;
  try {
    auto match{assignment_regex.match(formula_plain)};
    if (match.hasMatch()) {
      var_name = match.capturedRef(1).toString();
      if (var_name == "pi" or var_name == "e")
        throw std::runtime_error{"protected variable"};
      res = P.value(match.capturedRef(2).toString(), V);
      V[var_name] = res;
      emit variablesChanged();
    } else
      res = P.value(formula_plain, V);
  } catch (std::exception &e) {
    error = e.what();
  }
  QString res_str{typeset(res)};
  formula.replace(" ", "")
      .replace("-", "−")
      .replace("*", "·")
      .replace(binary_operator_regex, " \\1 ")
      .replace(",", ", ")
      .replace(pi_regex, "π")
      .replace(sqrt_regex, "√")
      .replace(Gamma_regex, "Γ")
      .replace(gamma_regex, "γ")
      .replace(leading_spaces_regex, "")
      .replace("  ", " ");
  if (auto match{assignment_regex.match(formula)}; match.hasMatch())
    formula = match.capturedRef(2).toString();
  QVariantMap res_map;
  res_map.insert("formula", formula);
  res_map.insert("variable", var_name);
  res_map.insert("result", res_str);
  res_map.insert("error", error);
  return res_map;
}


void Calculator::removeVariable(int i) {
  if (i < 0 or static_cast<std::size_t>(i) >= V.size())
    return;
  auto j{V.begin()};
  std::advance(j, i);
  V.erase(j);
  emit variablesChanged();
}


void Calculator::clear() {
  V.clear();
  init_variables();
  emit variablesChanged();
}


QVariantList Calculator::getVariables() const {
  QVariantList list;
  for (const auto &x : V) {
    QString value_str{typeset(x.second)};
    QString name_str{x.first};
    if (name_str == "pi")
      name_str = "π";
    bool is_protected{name_str == "π" or name_str == "e"};
    QMap<QString, QVariant> map;
    map.insert("variable", name_str);
    map.insert("value", value_str);
    map.insert("protected", is_protected);
    list.append(map);
  }
  return list;
}


QString Calculator::typeset(double x) {
  static const QRegularExpression pos_exponent_regex{R"(e[+](\d+))"};
  static const QRegularExpression neg_exponent_regex{R"(e[-](\d+))"};

  return QString::number(x, 'g', 12)
      .replace(pos_exponent_regex, R"( · 10^\1)")
      .replace(neg_exponent_regex, R"( · 10^(−\1))")
      .replace("-", "−")
      .replace("inf", "∞");
}


QString Calculator::get_settings_path() {
  return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" +
         QCoreApplication::applicationName() + ".conf";
}
