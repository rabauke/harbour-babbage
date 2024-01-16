#include "VariablesListModel.hpp"
#include <algorithm>


void VariablesListModel::add(const Variable &variable) {
  const auto insert_pos{
      std::lower_bound(m_variables.begin(), m_variables.end(), variable,
                       [](const Variable &x, const Variable &y) { return x.name < y.name; })};
  if (insert_pos == m_variables.cend()) {
    const int new_row{rowCount()};
    insertRow(new_row);
    setData(new_row, variable);
    emit variableAdded(variable);
  } else if (insert_pos->name == variable.name) {
    if (not insert_pos->is_protected) {
      const int row{static_cast<int>(insert_pos - m_variables.begin())};
      setData(row, variable);
      emit variableAdded(variable);
    }
  } else {
    const int new_row{static_cast<int>(insert_pos - m_variables.begin())};
    insertRow(new_row);
    setData(new_row, variable);
    emit variableAdded(variable);
  }
}


void VariablesListModel::remove(const QString &name) {
  const auto iter{
      std::find_if(begin(), end(), [&name](const auto &value) { return value.name == name; })};
  if (iter == end())
    return;
  if (iter->is_protected)
    return;
  const auto row{iter - begin()};
  removeRow(row);
  emit variableRemoved(name);
}


void VariablesListModel::clear() {
  QVector<QString> names;
  for (const auto &variable : *this) {
    if (not variable.is_protected)
      names.push_back(variable.name);
  }
  for (const auto &name : names)
    remove(name);
}


Qt::ItemFlags VariablesListModel::flags(const QModelIndex &index) const {
  return Qt::ItemIsEditable;
}


VariablesListModel::size_type VariablesListModel::size() const {
  return m_variables.size();
}


bool VariablesListModel::empty() const {
  return m_variables.empty();
}


VariablesListModel::const_iterator VariablesListModel::begin() const {
  return m_variables.begin();
}


VariablesListModel::const_iterator VariablesListModel::cbegin() const {
  return m_variables.cbegin();
}


VariablesListModel::const_iterator VariablesListModel::end() const {
  return m_variables.end();
}


VariablesListModel::const_iterator VariablesListModel::cend() const {
  return m_variables.cend();
}


QHash<int, QByteArray> VariablesListModel::roleNames() const {
  static const QHash<int, QByteArray> role_names{
      {name_role, "name"}, {value_role, "value"}, {is_protected_role, "is_protected"}};
  return role_names;
}


int VariablesListModel::rowCount([[maybe_unused]] const QModelIndex &parent) const {
  return m_variables.count();
}


QVariant VariablesListModel::data(const QModelIndex &index, int role) const {
  const int row{index.row()};
  if (0 <= row and row < m_variables.count()) {
    auto &variable{m_variables[row]};
    switch (role) {
      case name_role:
        return variable.name;
      case value_role:
        return variable.value;
      case is_protected_role:
        return variable.is_protected;
    }
  }
  return {};
}


bool VariablesListModel::setData(const QModelIndex &index, const QVariant &value, int role) {
  if (!hasIndex(index.row(), index.column(), index.parent()) || !value.isValid())
    return false;

  auto &variable{m_variables[index.row()]};
  switch (role) {
    case name_role:
      variable.name = value.toString();
    case value_role:
      variable.value = value.toDouble();
    case is_protected_role:
      variable.is_protected = value.toBool();
    default:
      return false;
  }

  emit dataChanged(index, index, {role});

  return true;
}


void VariablesListModel::setData(int row, const Variable &variable) {
  if (row < 0 or row >= rowCount())
    return;

  m_variables[row] = variable;
  auto row_index{index(row)};

  emit dataChanged(row_index, row_index, {name_role, value_role, is_protected_role});
}


bool VariablesListModel::insertRows(int row, int count, const QModelIndex &parent) {
  if (count < 1 or row < 0 or row > rowCount())
    return false;

  beginInsertRows(parent, row, row + count - 1);
  m_variables.insert(row, count, Variable{});
  endInsertRows();

  return true;
}


bool VariablesListModel::removeRows(int row, int count, const QModelIndex &parent) {
  if (count < 1 or row < 0 or row + count > rowCount())
    return false;

  beginRemoveRows(parent, row, row + count - 1);
  m_variables.remove(row, count);
  endRemoveRows();

  return true;
}
