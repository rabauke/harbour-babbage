import QtQuick 2.0
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import "../components"

Page {
  id: simpleCalculator
  allowedOrientations: Orientation.Portrait

  property string memory

  SilicaFlickable {
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: qsTr('About Babbage')
        onClicked: pageStack.push(Qt.resolvedUrl('About.qml'))
      }
      MenuItem {
        text: qsTr('Scientific calculator')
        onClicked: pageStack.replace(Qt.resolvedUrl('MainPage.qml'))
      }
      MenuItem {
        text: qsTr('Get memory')
        onClicked: formula.text = formula.text + simpleCalculator.memory
      }
      MenuItem {
        text: qsTr('Save result')
        onClicked: {
          Clipboard.text = result.text.substr(2)
          simpleCalculator.memory = result.text.substr(2)
        }
      }
    }

    PageHeader {
      id: pageHeader
      title: qsTr('Pocket calculator')
    }

    Text {
      id: formula

      anchors {
        left: parent.left
        right: parent.right
        top: pageHeader.bottom
        topMargin: Theme.paddingLarge
        leftMargin: 2 * Theme.paddingMedium
        rightMargin: 2 * Theme.paddingMedium
      }

      text: ''
      horizontalAlignment: {
        text == '' || contentWidth < width ? Text.AlignLeft : Text.AlignRight
      }
      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeMedium : Theme.fontSizeSmall
      color: Theme.primaryColor
      elide: Text.ElideLeft
    }

    Text {
      id: result

      anchors {
        left: parent.left
        right: parent.right
        top: formula.bottom
        topMargin: Theme.paddingLarge
        leftMargin: 2 * Theme.paddingMedium
        rightMargin: 2 * Theme.paddingMedium
      }

      text: '= '
      horizontalAlignment: Text.AlignLeft
      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeLarge : Theme.fontSizeMedium
      color: Theme.highlightColor
    }

    Text {
      id: memoryText

      anchors {
        left: parent.left
        right: parent.right
        top: result.bottom
        topMargin: Theme.paddingLarge
        leftMargin: 2 * Theme.paddingMedium
        rightMargin: 2 * Theme.paddingMedium
      }

      text: 'M: ' + simpleCalculator.memory
      horizontalAlignment: Text.AlignLeft
      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeLarge : Theme.fontSizeMedium
      color: Theme.highlightColor
    }

    GridLayout {
      id: grid
      anchors.horizontalCenter: parent.horizontalCenter
      anchors {
        bottom: parent.bottom
        bottomMargin: Screen.sizeCategory >= Screen.Large ? 4 * Theme.paddingLarge : 2
                                                            * Theme.paddingLarge
      }
      rows: 6
      columns: 4
      rowSpacing: Theme.paddingMedium
      columnSpacing: Theme.paddingMedium

      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '√'
        onClicked: formula.text = formula.text + '√('
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '^'
        onClicked: formula.text = formula.text + '^'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '<b>AC</b>'
        onClicked: {
          formula.text = ''
          result.text = '= '
        }
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '<b>C</b>'
        onClicked: {
          if (formula.text.length > 0) {
            if (formula.text.slice(-1) == ' ')
              formula.text = formula.text.slice(0, -1)
          }
          if (formula.text.length > 0) {
            formula.text = formula.text.slice(0, -1)
          }
          if (formula.text.length > 0) {
            if (formula.text.slice(-1) == ' ')
              formula.text = formula.text.slice(0, -1)
          }
          if (formula.text.length > 0) {
            if (formula.text.slice(-1) == '√')
              formula.text = formula.text.slice(0, -1)
          }
        }
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '('
        onClicked: formula.text = formula.text + '('
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: ')'
        onClicked: formula.text = formula.text + ')'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: 'π'
        onClicked: formula.text = formula.text + 'π'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '+'
        onClicked: formula.text = formula.text + ' + '
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '1'
        onClicked: formula.text = formula.text + '1'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '2'
        onClicked: formula.text = formula.text + '2'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '3'
        onClicked: formula.text = formula.text + '3'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '−'
        onClicked: formula.text = formula.text + ' − '
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '4'
        onClicked: formula.text = formula.text + '4'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '5'
        onClicked: formula.text = formula.text + '5'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '6'
        onClicked: formula.text = formula.text + '6'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '×'
        onClicked: formula.text = formula.text + ' · '
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '7'
        onClicked: formula.text = formula.text + '7'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '8'
        onClicked: formula.text = formula.text + '8'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '9'
        onClicked: formula.text = formula.text + '9'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '/'
        onClicked: formula.text = formula.text + ' / '
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '0'
        onClicked: formula.text = formula.text + '0'
      }
      PCButton {
        Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
        text: '.'
        onClicked: formula.text = formula.text + '.'
      }
      PCButton {
        Layout.preferredWidth: 2 * Theme.buttonWidthSmall / 2.125 + Theme.paddingMedium
        Layout.columnSpan: 2
        text: '<b>=</b>'
        onClicked: {
          var res = calculator.calculate(formula.text)
          resultsListModel.insert(0, res)
          result.text = '= ' + res.result
        }
      }
    }
  }
}
