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

  init_variables();
  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  const auto variables{settings.allKeys()};
  for (const auto &variable : variables) {
    if (variable_regex.match(variable).hasMatch()) {
      auto value{settings.value(variable)};
      bool success;
      const auto valueAsDouble{value.toDouble(&success)};
      if (success)
        m_variables.add(Variable{variable, valueAsDouble, false});
    }
  }
  settings.endGroup();
}


Calculator::~Calculator() {
  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  settings.remove("");
  for (const auto &variable : m_variables)
    settings.setValue(variable.name, variable.value);
  settings.endGroup();
  settings.sync();
}


QVariantMap Calculator::calculate(QString formula) {
  static const QRegularExpression assignment_regex{R"(^\s*([[:alpha:]]\w*)\s*=\s*(.*))"};

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
      res = m_parser.value(match.capturedRef(2).toString(), getVariablesMap());
      m_variables.add(Variable{var_name, res, false});
    } else
      res = m_parser.value(formula_plain, getVariablesMap());
  } catch (std::exception &e) {
    error = e.what();
  }
  QString res_str{typeset_value(res)};
  formula = typeset(formula);
  if (auto match{assignment_regex.match(formula)}; match.hasMatch())
    formula = match.capturedRef(2).toString();
  QVariantMap res_map;
  res_map.insert("formula", formula);
  res_map.insert("variable", var_name);
  res_map.insert("result", res_str);
  res_map.insert("error", error);
  return res_map;
}


QString Calculator::typeset(QString formula) const {
  static const QRegularExpression whitespace_regex{R"(\s+)"};
  static const QRegularExpression pi_regex{R"(\bpi\b)"};
  static const QRegularExpression sqrt_regex{R"(\bsqrt\b)"};
  static const QRegularExpression Gamma_regex{R"(\bGamma\b)"};
  static const QRegularExpression gamma_regex{R"(\bgamma\b)"};
  static const QRegularExpression leading_spaces_regex{R"(^\s*)"};
  static const QRegularExpression ending_spaces_regex{R"(\s*$)"};
  static const QRegularExpression binary_operator1_regex{R"((?<!^|\(|=)([+−]))"};
  static const QRegularExpression binary_operator2_regex{R"(([=·/]))"};

  formula.replace(whitespace_regex, "")
      .replace("-", "−")
      .replace("*", "·")
      .replace(binary_operator1_regex, " \\1 ")
      .replace(binary_operator2_regex, " \\1 ")
      .replace(",", ", ")
      .replace(pi_regex, "π")
      .replace(sqrt_regex, "√")
      .replace(Gamma_regex, "Γ")
      .replace(gamma_regex, "γ")
      .replace(leading_spaces_regex, "")
      .replace(ending_spaces_regex, "")
      .replace("  ", " ");
  return formula;
}


VariablesListModel *Calculator::getVariables() {
  return &m_variables;
}


void Calculator::init_variables() {
  m_variables.add(Variable{"pi", constants::pi, true});
  m_variables.add(Variable{"e", constants::e, true});
}


math_parser::arithmetic_parser::var_map_t Calculator::getVariablesMap() const {
  math_parser::arithmetic_parser::var_map_t variables;
  for (const auto &variable : m_variables)
    variables[variable.name] = variable.value;
  return variables;
}


QString Calculator::typeset_value(double x) {
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
