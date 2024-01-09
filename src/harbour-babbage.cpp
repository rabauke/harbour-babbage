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
#include "Calculator.hpp"
#include "FormularyExpression.hpp"


int main(int argc, char *argv[]) {
  QScopedPointer<QGuiApplication> app{SailfishApp::application(argc, argv)};
  app->setApplicationName("harbour-babbage");
  app->setOrganizationDomain("rabauke");

  qmlRegisterType<Calculator>("harbour.babbage.qmlcomponents", 1, 0, "Calculator");
  qmlRegisterType<AppModel>("harbour.babbage.qmlcomponents", 1, 0, "AppModel");

  qRegisterMetaType<FormularyExpression>();
  qRegisterMetaTypeStreamOperators<FormularyExpression>("FormularyExpression");

  QScopedPointer<QQuickView> view{SailfishApp::createView()};
  view->setSource(SailfishApp::pathTo("qml/harbour-babbage.qml"));
  view->show();
  return app->exec();
}
