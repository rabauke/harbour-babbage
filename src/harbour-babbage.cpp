#include <QtQuick>
#include <QString>
#include <QObject>
#include <QtQml>
#include <sailfishapp.h>
#include "calculator.hpp"


int main(int argc, char *argv[]) {
  QScopedPointer<QGuiApplication> app{SailfishApp::application(argc, argv)};
  app->setApplicationName("harbour-babbage");
  app->setOrganizationDomain("rabauke");

  qmlRegisterType<calculator>("harbour.babbage.qmlcomponents", 1, 0, "Calculator");

  QScopedPointer<QQuickView> view{SailfishApp::createView()};
  view->setSource(SailfishApp::pathTo("qml/harbour-babbage.qml"));
  view->show();
  return app->exec();
}
