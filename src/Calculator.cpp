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
        m_variables.insert(variable, valueAsDouble);
    }
  }
  settings.endGroup();

  init_variables();
}


Calculator::~Calculator() {
  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  settings.remove("");
  for (const auto &variable : m_variables)
    settings.setValue(variable.first, variable.second);
  settings.endGroup();
  settings.sync();
}


void Calculator::init_variables() {
  m_variables.insert("pi", constants::pi);
  m_variables.insert("e", constants::e);
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
      res = m_parser.value(match.capturedRef(2).toString(), m_variables);
      m_variables[var_name] = res;
      emit variablesChanged();
    } else
      res = m_parser.value(formula_plain, m_variables);
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


void Calculator::removeVariable(int i) {
  if (i < 0 or static_cast<std::size_t>(i) >= m_variables.size())
    return;
  auto j{m_variables.begin()};
  std::advance(j, i);
  m_variables.erase(j);
  emit variablesChanged();
}


void Calculator::clear() {
  m_variables.clear();
  init_variables();
  emit variablesChanged();
}


QString Calculator::typeset(QString formula) const {
  static const QRegularExpression pi_regex{R"(\bpi\b)"};
  static const QRegularExpression sqrt_regex{R"(\bsqrt\b)"};
  static const QRegularExpression Gamma_regex{R"(\bGamma\b)"};
  static const QRegularExpression gamma_regex{R"(\bgamma\b)"};
  static const QRegularExpression leading_spaces_regex{R"(^\s*)"};
  static const QRegularExpression ending_spaces_regex{R"(\s*$)"};
  static const QRegularExpression binary_operator1_regex{R"((?<!^|\(|=)([+−]))"};
  static const QRegularExpression binary_operator2_regex{R"(([=·/]))"};

  formula.replace(" ", "")
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
};


QVariantList Calculator::getVariables() const {
  QVariantList list;
  for (const auto &x : m_variables) {
    QString value_str{typeset_value(x.second)};
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
