#include "FormularyListModel.hpp"

void FormularyListModel::add(const FormularyExpression &expression) {
  const int new_row{rowCount()};
  insertRow(new_row);
  setData(new_row, expression);
}


void FormularyListModel::add(const QVariantMap &object) {
  const auto expression{FormularyExpression::create(object)};
  add(expression);
}


void FormularyListModel::set(int row, const FormularyExpression &expression) {
  setData(row, expression);
}


void FormularyListModel::set(int row, const QVariantMap &object) {
  const auto expression{FormularyExpression::create(object)};
  setData(row, expression);
}


FormularyExpression FormularyListModel::get(int row) const {
  if (0 <= row and row < rowCount())
    return m_expressions[row];
  return {};
}


void FormularyListModel::remove(int row) {
  removeRow(row);
}


void FormularyListModel::clear() {
  removeRows(0, rowCount());
}


Qt::ItemFlags FormularyListModel::flags(const QModelIndex &index) const {
  return Qt::ItemIsEditable;
}


FormularyListModel::size_type FormularyListModel::size() const {
  return m_expressions.size();
}


bool FormularyListModel::empty() const {
  return m_expressions.empty();
}


FormularyListModel::const_iterator FormularyListModel::begin() const {
  return m_expressions.begin();
}


FormularyListModel::const_iterator FormularyListModel::cbegin() const {
  return m_expressions.cbegin();
}


FormularyListModel::const_iterator FormularyListModel::end() const {
  return m_expressions.end();
}


FormularyListModel::const_iterator FormularyListModel::cend() const {
  return m_expressions.cend();
}


QHash<int, QByteArray> FormularyListModel::roleNames() const {
  static const QHash<int, QByteArray> role_names{{expression_role, "expression"},
                                                 {description_role, "description"}};
  return role_names;
}


int FormularyListModel::rowCount([[maybe_unused]] const QModelIndex &parent) const {
  return m_expressions.count();
}


QVariant FormularyListModel::data(const QModelIndex &index, int role) const {
  const int row{index.row()};
  if (0 <= row and row < m_expressions.count()) {
    auto &expression{m_expressions[row]};
    switch (role) {
      case expression_role:
        return expression.expression;
      case description_role:
        return expression.description;
    }
  }
  return {};
}


bool FormularyListModel::setData(const QModelIndex &index, const QVariant &value, int role) {
  if (!hasIndex(index.row(), index.column(), index.parent()) || !value.isValid())
    return false;

  auto &expression{m_expressions[index.row()]};
  switch (role) {
    case expression_role:
      expression.expression = value.toString();
    case description_role:
      expression.description = value.toString();
    default:
      return false;
  }

  emit dataChanged(index, index, {role});

  return true;
}


void FormularyListModel::setData(int row, const FormularyExpression &expression) {
  if (row < 0 or row >= rowCount())
    return;

  m_expressions[row] = expression;
  auto row_index{index(row)};

  emit dataChanged(row_index, row_index, {expression_role, description_role});
}


bool FormularyListModel::insertRows(int row, int count, const QModelIndex &parent) {
  if (count < 1 or row < 0 or row > rowCount())
    return false;

  beginInsertRows(parent, row, row + count - 1);
  m_expressions.insert(row, count, FormularyExpression{});
  endInsertRows();

  return true;
}


bool FormularyListModel::removeRows(int row, int count, const QModelIndex &parent) {
  if (count < 1 or row < 0 or row + count > rowCount())
    return false;

  beginRemoveRows(parent, row, row + count - 1);
  m_expressions.remove(row, count);
  endRemoveRows();

  return true;
}
