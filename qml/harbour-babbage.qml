import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import 'pages'


ApplicationWindow {
  id: appWindow

  AppModel {
    id: appModel
  }

  Calculator {
    id: calculator
  }

  ListModel {
    id: resultsListModel
  }

  initialPage: Qt.resolvedUrl(appModel.calculatorType == AppModel.ScientificCalculator ? 'pages/MainPage.qml' : 'pages/SimpleCalculator.qml')
  cover: Qt.resolvedUrl('cover/CoverPage.qml')
  allowedOrientations: Orientation.All
}
