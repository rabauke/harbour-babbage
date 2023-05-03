//C++ Mathematical Expression Toolkit Library
#include "extern/exprtk.hpp"
#include <QDebug>

#include "constants.hpp"
#include "calculator.hpp"
#include "math_parser.hpp"
#include <limits>
#include <cmath>
#include <QtDebug>
#include <QStringList>
#include <QSettings>
#include <QStandardPaths>
#include <QCoreApplication>


calculator::calculator(QObject *parent) : QObject(parent) {
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


calculator::~calculator() {
  QSettings settings(get_settings_path(), QSettings::NativeFormat);
  settings.beginGroup("variables");
  settings.remove("");
  for (const auto &variable : V)
    settings.setValue(variable.first, variable.second);
  settings.endGroup();
  settings.sync();
}


void calculator::init_variables() {
  V.insert("pi", constants::pi);
  V.insert("e", constants::e);
}


QVariantMap calculator::calculate(QString formula) {
  static const QRegularExpression pi_regex{R"(\bpi\b)"};
  static const QRegularExpression sqrt_regex{R"(\bsqrt\b)"};
  static const QRegularExpression Gamma_regex{R"(\bGamma\b)"};
  static const QRegularExpression gamma_regex{R"(\bgamma\b)"};
  static const QRegularExpression leading_spaces_regex{R"(^\s*)"};
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
      res = P.value(match.capturedRef(2).toString(), V);
      V[var_name] = res;
    } else
      res = P.value(formula_plain, V);
  } catch (std::exception &e) {
    error = e.what();
  }
  QString res_str{typeset(res)};
  formula.replace(" ", "")
      .replace("+", " + ")
      .replace("−", " − ")
      .replace("-", " − ")
      .replace("·", " · ")
      .replace("*", " · ")
      .replace("/", " / ")
      .replace("=", " = ")
      .replace(",", ", ")
      .replace(pi_regex, "π")
      .replace(sqrt_regex, "√")
      .replace(Gamma_regex, "Γ")
      .replace(gamma_regex, "γ")
      .replace("  ", " ")
      .replace(leading_spaces_regex, "");
  if (auto match{assignment_regex.match(formula)}; match.hasMatch())
    formula = match.capturedRef(2).toString();
  QVariantMap res_map;
  res_map.insert("formula", formula);
  res_map.insert("variable", var_name);
  res_map.insert("result", res_str);
  res_map.insert("error", error);
  return res_map;
}


//http://www.partow.net/programming/exprtk/index.html
QVariantMap calculator::exprtk(QString formula){
    //convert to std::String
    QString error;
    QString res_str;
    QVariantMap res_map;

    /*static const QRegularExpression assignment_regex{R"(^\s*([[:alpha:]]\w*)\s*\\:=\s*(.*))"};

    QString var_name;
    double res{std::numeric_limits<double>::quiet_NaN()};
    try {
      auto match{assignment_regex.match(formula)};
      if (match.hasMatch()) {
        var_name = match.capturedRef(1).toString();
        res = P.value(match.capturedRef(2).toString(), V);
        V[var_name] = res;
      } else
        res = P.value(formula, V);
    } catch (std::exception &e) {
      error = e.what();
    }*/

    const std::string expressionStr = formula.toStdString();

    //numeric type
    typedef double T;
    typedef exprtk::expression<T> expression_t;
    typedef exprtk::parser<T> parser_t;
    typedef exprtk::symbol_table<T> symbol_table_t;

    // Setup global constants symbol table
    T x = T(0);
    T y = T(0);
    T z = T(0);

    symbol_table_t symbol_table;
    symbol_table.add_constants();
    symbol_table.add_variable("x",x);
    symbol_table.add_variable("y",y);
    symbol_table.add_variable("z",z);

    //instantiate classes
    expression_t expression;
    // Register the various symbol tables
    expression.register_symbol_table(symbol_table);

    // instrantiate the parser
    parser_t parser;

    if(!parser.compile(expressionStr, expression)){
        //construct error Msg
        res_str = "";
        qDebug() << "425: " << QString::fromStdString(parser.error().c_str());
        error.append(QString::fromStdString(parser.error().c_str()));
    }
    else{
        T result = expression.value();
        qDebug() << "425: " << double(result);
        res_str = typeset(result);
    }

    /* collect results from intermediate calculations */
    QVariantList resultsList;
    if (expression.results().count()) {
        typedef exprtk::results_context<T> results_context_t;
        typedef typename results_context_t::type_store_t type_t;

        typedef typename type_t::scalar_view scalar_t;
        typedef typename type_t::vector_view vector_t;
        typedef typename type_t::string_view string_t;

        const results_context_t& results = expression.results();

        for (std::size_t i = 0; i < results.count(); ++i)
        {
                type_t t = results[i];
                QString name;
                switch (t.type)
                {
                case type_t::e_scalar :
                    resultsList.push_front( scalar_t(t)()  );
                                           break;

                case type_t::e_vector :
                {
                    vector_t vector(t);
                    for (std::size_t x = 0; x < vector.size(); ++x)
                    {
                        resultsList.push_front(  vector[x]  );
                    }
                }
                                           break;

                 case type_t::e_string :
                        resultsList.push_front( to_str(string_t(t)).c_str() );
                                           break;

                 default               : continue;
                }
        }
    }
    /* take on original var handling */
    /*double res{std::numeric_limits<double>::quiet_NaN()};
    static const QRegularExpression assignment_regex{R"(^\s*([[:alpha:]]\w*)\s*:=\s*(.*))"};
    QString var_name;
    try {
      auto match{assignment_regex.match(formula)};
      if (match.hasMatch()) {
        var_name = match.capturedRef(1).toString();
        if (var_name == "pi" or var_name == "e")
          throw std::runtime_error{"protected variable"};
        res = P.value(match.capturedRef(2).toString(), V);
        V[var_name] = res;
      } else
        res = P.value(formula, V);
    } catch (std::exception &e) {
      error.append( e.what());
    }*/

    res_map.insert("formula", formula);
    res_map.insert("variable", "");//var_name);
    res_map.insert("result", res_str);
    res_map.insert("iresults", resultsList);
    res_map.insert("error", error);
    return res_map;

}

void calculator::removeVariable(int i) {
  if (i < 0 or static_cast<std::size_t>(i) >= V.size())
    return;
  auto j{V.begin()};
  std::advance(j, i);
  V.erase(j);
}


void calculator::clear() {
  V.clear();
  init_variables();
}


QVariantList calculator::getVariables() const {
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


QString calculator::typeset(double x) {
  static const QRegularExpression pos_exponent_regex{R"(e[+](\d+))"};
  static const QRegularExpression neg_exponent_regex{R"(e[-](\d+))"};

  return QString::number(x, 'g', 12)
      .replace(pos_exponent_regex, R"( · 10^\1)")
      .replace(neg_exponent_regex, R"( · 10^(−\1))")
      .replace("-", "−")
      .replace("inf", "∞");
}


QString calculator::get_settings_path() {
  return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" +
         QCoreApplication::applicationName() + ".conf";
}
