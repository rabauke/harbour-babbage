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
  using size_type = QVector<Variable>::size_type;
  using const_iterator = QVector<Variable>::const_iterator;

  using QAbstractListModel::QAbstractListModel;

  virtual ~VariablesListModel() = default;

#if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
  QML_NAMED_ELEMENT(VariablesListModel)
#endif

  void add(const Variable &variable);
  Q_INVOKABLE void remove(const QString &name);
  Q_INVOKABLE void clear();

  Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const override;

  size_type size() const;
  bool empty() const;
  const_iterator begin() const;
  const_iterator cbegin() const;
  const_iterator end() const;
  const_iterator cend() const;

signals:
  void variableAdded(Variable variable);
  void variableRemoved(QString name);

protected:
  QHash<int, QByteArray> roleNames() const override;

private:
  [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  [[nodiscard]] QVariant data(const QModelIndex &index, int role) const override;
  bool setData(const QModelIndex &index, const QVariant &value, int role) override;
  void setData(int row, const Variable &variable);
  bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
  bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

  static constexpr int name_role = Qt::UserRole;
  static constexpr int value_role = Qt::UserRole + 1;
  static constexpr int is_protected_role = Qt::UserRole + 2;

  QVector<Variable> m_variables;
};
