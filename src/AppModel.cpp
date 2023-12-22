#include "AppModel.hpp"
#include <QCoreApplication>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>
#include <QMetaEnum>


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
  if (expressions_variant.isValid() and expressions_variant.canConvert<QStringList>())
    m_expressions = expressions_variant.toStringList();
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

  settings.setValue("expressions", m_expressions);
  settings.sync();
}


void AppModel::addExpression(QString expression) {
  m_expressions.append(expression);
  emit expressionsChanged();
}


void AppModel::removeExpression(qint32 index) {
  if (0 <= index && index < m_expressions.size()) {
    m_expressions.removeAt(index);
    emit expressionsChanged();
  }
}


void AppModel::clearExpressions() {
  m_expressions.clear();
  emit expressionsChanged();
}


QStringList AppModel::getExpressions() const {
  return m_expressions;
}
