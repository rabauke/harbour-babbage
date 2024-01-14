#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
#include <QtQmlIntegration>
#endif
#include "FormularyExpression.hpp"


class FormularyListModel : public QAbstractListModel {
  Q_OBJECT
public:
  using const_iterator = QVector<FormularyExpression>::const_iterator;

  using QAbstractListModel::QAbstractListModel;

  virtual ~FormularyListModel() = default;

#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(FormularyListModel)
#endif

  [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  [[nodiscard]] QVariant data(const QModelIndex &index, int role) const override;
  bool setData(const QModelIndex &index, const QVariant &value, int role) override;
  void setData(int row, const FormularyExpression &expression);
  bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
  bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
  Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const override;

  const_iterator begin() const;
  const_iterator cbegin() const;
  const_iterator end() const;
  const_iterator cend() const;

  void add(const FormularyExpression &expression);
  Q_INVOKABLE void add(const QVariantMap &object);
  void set(int row, const FormularyExpression &expression);
  Q_INVOKABLE void set(int row, const QVariantMap &object);
  Q_INVOKABLE FormularyExpression get(int row) const;
  Q_INVOKABLE void remove(int row);
  Q_INVOKABLE void clear();

protected:
  QHash<int, QByteArray> roleNames() const override;

private:
  static constexpr int expression_role = Qt::UserRole;
  static constexpr int description_role = Qt::UserRole + 1;

  QVector<FormularyExpression> m_expressions;
};
