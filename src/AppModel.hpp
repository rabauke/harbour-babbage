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
  Q_PROPERTY(
      CalculatorType calculatorType MEMBER m_calculator_type NOTIFY calculatorTypeChanged)
  Q_PROPERTY(QVariantList expressions READ getExpressions NOTIFY expressionsChanged)

  Q_INVOKABLE void addExpression(const QString &expression);
  Q_INVOKABLE void removeExpression(qint32 index);
  Q_INVOKABLE void updateExpression(qint32 index, const QString &expression,
                                    const QString &description);
  Q_INVOKABLE void clearExpressions();

signals:
  void calculatorTypeChanged(CalculatorType new_calculator_type);
  void expressionsChanged();

private:
  QVariantList getExpressions() const;

  QString m_version{QString::fromStdString(project_version)};
  CalculatorType m_calculator_type{CalculatorType::SimpleCalculator};
  QVariantList m_expressions;
};
