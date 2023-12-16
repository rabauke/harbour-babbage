import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import 'pages'

ApplicationWindow {
  id: app_window

  Calculator {
    id: calculator
  }

  ListModel {
    id: resultsListModel
  }

  ListModel {
    id: variablesListModel
  }

  initialPage: Qt.resolvedUrl('pages/SimpleCalculator.qml')
  cover: Qt.resolvedUrl('cover/CoverPage.qml')
  allowedOrientations: Orientation.All
  _defaultPageOrientations: Orientation.All
}
