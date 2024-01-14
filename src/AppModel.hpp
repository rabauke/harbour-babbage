#pragma once

#include <QtGlobal>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QUrl>
#include <QQmlListProperty>
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
#include <QtQmlIntegration>
#endif
#include "Version.h"
#include "Calculator.hpp"
#include "FormularyListModel.hpp"


class AppModel : public QObject {
  Q_OBJECT

public:
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(AppModel)
#endif

  enum class CalculatorType : int { SimpleCalculator, ScientificCalculator };
  Q_ENUM(CalculatorType)

  explicit AppModel(QObject* parent = nullptr);
  ~AppModel();

  Q_PROPERTY(QString version MEMBER m_version CONSTANT)
  Q_PROPERTY(FormularyListModel* formulary READ getFormulary CONSTANT)
  Q_PROPERTY(Calculator* calculator READ getCalculator CONSTANT)
  Q_PROPERTY(
      CalculatorType calculatorType MEMBER m_calculator_type NOTIFY calculatorTypeChanged)
  Q_PROPERTY(FormularyListModel* formulary READ getFormulary CONSTANT)

signals:
  void calculatorTypeChanged(CalculatorType new_calculator_type);
  void formularyChanged();

private:
  Calculator* getCalculator();
  FormularyListModel* getFormulary();

  QString m_version{QString::fromStdString(project_version)};
  Calculator m_calculator;
  CalculatorType m_calculator_type{CalculatorType::SimpleCalculator};
  FormularyListModel m_formulary;
};
