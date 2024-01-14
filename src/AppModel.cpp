#include "AppModel.hpp"
#include <QCoreApplication>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>
#include <QMetaEnum>
#include "FormularyExpression.hpp"


#ifdef SAILJAIL

namespace {

  QString settings_path() {
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" +
           QCoreApplication::applicationName() + ".conf";
  }

}  // namespace

#endif


AppModel::AppModel(QObject* parent) : QObject{parent} {
#ifdef SAILJAIL
  QSettings settings{settings_path(), QSettings::NativeFormat};
#else
  QSettings settings;
#endif
  const auto calculator_type_variant{settings.value("calculator_type")};
  if (calculator_type_variant.isValid()) {
    auto calculator_type_meta{QMetaEnum::fromType<CalculatorType>()};
    bool success{false};
    int value{calculator_type_meta.keyToValue(qPrintable(calculator_type_variant.toString()),
                                              &success)};
    if (success)
      m_calculator_type = static_cast<CalculatorType>(value);
  }

  const auto expressions_variant{settings.value("expressions")};
  if (expressions_variant.isValid() and expressions_variant.canConvert<QVariantList>()) {
    QSequentialIterable iterable{expressions_variant.value<QSequentialIterable>()};
    for (const QVariant& v : iterable) {
      if (v.canConvert<FormularyExpression>())
        m_formulary.add(v.value<FormularyExpression>());
    }
  }
}


AppModel::~AppModel() {
#ifdef SAILJAIL
  QSettings settings{settings_path(), QSettings::NativeFormat};
#else
  QSettings settings;
#endif

  auto calculator_type_meta{QMetaEnum::fromType<CalculatorType>()};
  auto* calculator_type_str{calculator_type_meta.key(static_cast<int>(m_calculator_type))};
  if (calculator_type_str != nullptr)
    settings.setValue("calculator_type", calculator_type_str);

  QVariantList expressions;
  for (const auto& expression : m_formulary) {
    QVariant expression_variant;
    expression_variant.setValue(expression);
    expressions.append(expression_variant);
  }
  settings.setValue("expressions", expressions);
  settings.sync();
}


Calculator* AppModel::getCalculator() {
  return &m_calculator;
}


FormularyListModel* AppModel::getFormulary() {
  return &m_formulary;
}
