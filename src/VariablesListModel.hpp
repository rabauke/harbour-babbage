#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>
#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
#include <QtQmlIntegration>
#endif
#include "Variable.hpp"


class VariablesListModel : public QAbstractListModel {
  Q_OBJECT
public:
  using const_iterator = QVector<Variable>::const_iterator;

  using QAbstractListModel::QAbstractListModel;

  virtual ~VariablesListModel() = default;

#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(VariablesListModel)
#endif

  [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  [[nodiscard]] QVariant data(const QModelIndex &index, int role) const override;
  bool setData(const QModelIndex &index, const QVariant &value, int role) override;
  void setData(int row, const Variable &variable);
  bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
  bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
  Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const override;

  const_iterator begin() const;
  const_iterator cbegin() const;
  const_iterator end() const;
  const_iterator cend() const;

  void add(const Variable &variable);
  Q_INVOKABLE Variable get(int row) const;
  Q_INVOKABLE void remove(int row);
  Q_INVOKABLE void clear();

protected:
  QHash<int, QByteArray> roleNames() const override;

private:
  static constexpr int name_role = Qt::UserRole;
  static constexpr int value_role = Qt::UserRole + 1;
  static constexpr int is_protected_role = Qt::UserRole + 2;

  QVector<Variable> m_variables;
};
