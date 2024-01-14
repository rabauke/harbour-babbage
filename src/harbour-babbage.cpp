#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QScopedPointer>
#include <QGuiApplication>
#include <QMetaType>
#include <QQmlEngine>
#include <QQuickView>
#include <sailfishapp.h>
#include "AppModel.hpp"
#include "Variable.hpp"
#include "VariablesListModel.hpp"
#include "Calculator.hpp"
#include "FormularyExpression.hpp"
#include "FormularyListModel.hpp"


int main(int argc, char *argv[]) {
  QScopedPointer<QGuiApplication> app{SailfishApp::application(argc, argv)};
  app->setApplicationName("harbour-babbage");
  app->setOrganizationDomain("rabauke");

  qmlRegisterType<Calculator>("harbour.babbage.qmlcomponents", 1, 0, "Calculator");
  qmlRegisterType<AppModel>("harbour.babbage.qmlcomponents", 1, 0, "AppModel");

  qRegisterMetaType<Variable>();
  qRegisterMetaTypeStreamOperators<Variable>("Variable");

  qmlRegisterType<VariablesListModel>("harbour.babbage.qmlcomponents", 1, 0,
                                      "VariablesListModel");

  qRegisterMetaType<FormularyExpression>();
  qRegisterMetaTypeStreamOperators<FormularyExpression>("FormularyExpression");

  qmlRegisterType<FormularyListModel>("harbour.babbage.qmlcomponents", 1, 0,
                                      "FormularyListModel");

  QScopedPointer<QQuickView> view{SailfishApp::createView()};
  view->setSource(SailfishApp::pathTo("qml/harbour-babbage.qml"));
  view->show();
  return app->exec();
}
