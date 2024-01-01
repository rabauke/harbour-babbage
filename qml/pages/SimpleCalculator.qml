import QtQuick 2.0
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import "../components"


Page {
  id: simpleCalculatorPage
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
        onClicked: formula.text = calculator.typeset(formula.text + simpleCalculatorPage.memory)
      }
      MenuItem {
        text: qsTr('Save result')
        onClicked: {
          Clipboard.text = result.text.substr(2)
          simpleCalculatorPage.memory = result.text.substr(2)
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

      text: 'M: ' + simpleCalculatorPage.memory
      horizontalAlignment: Text.AlignLeft
      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeLarge : Theme.fontSizeMedium
      color: Theme.highlightColor
    }

    SlideshowView {
      id: view
      anchors.fill: parent

      model: 2
      delegate: Item {
        width: view.width
        height: view.height
        GridLayout {
          id: grid
          anchors.horizontalCenter: parent.horizontalCenter
          anchors {
            bottom: parent.bottom
            bottomMargin: Screen.sizeCategory
                          >= Screen.Large ? 4 * Theme.paddingLarge : 2 * Theme.paddingLarge
          }
          rows: 6
          columns: 4
          rowSpacing: Theme.paddingMedium
          columnSpacing: Theme.paddingMedium

          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '√'
            onClicked: formula.text = calculator.typeset(formula.text + '√(')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '^'
            onClicked: formula.text = calculator.typeset(formula.text + '^')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '<b>AC</b>'
            onClicked: {
              formula.text = ''
              result.text = '= '
            }
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '<b>C</b>'
            onClicked: {
              var text = formula.text
              if (text.length > 0) {
                if (text.slice(-1) === ' ')
                  text = text.slice(0, -1)
              }
              if (text.match(/[a-z]+\($/)) {
                text = text.replace(/[a-z]+\($/, '')
              } else {
                if (text.length > 0) {
                  text = text.slice(0, -1)
                }
                if (text.length > 0) {
                  if (text.slice(-1) === ' ')
                    text = text.slice(0, -1)
                }
                if (text.length > 0) {
                  if (text.slice(-1) === '√')
                    text = text.slice(0, -1)
                }
              }
              formula.text = calculator.typeset(text)
            }
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '('
            onClicked: formula.text = calculator.typeset(formula.text + '(')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: ')'
            onClicked: formula.text = calculator.typeset(formula.text + ')')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'π'
            onClicked: formula.text = calculator.typeset(formula.text + 'π')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '+'
            onClicked: formula.text = calculator.typeset(formula.text + '+')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '1'
            onClicked: formula.text = calculator.typeset(formula.text + '1')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '2'
            onClicked: formula.text = calculator.typeset(formula.text + '2')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '3'
            onClicked: formula.text = calculator.typeset(formula.text + '3')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '−'
            onClicked: formula.text = calculator.typeset(formula.text + '−')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '4'
            onClicked: formula.text = calculator.typeset(formula.text + '4')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '5'
            onClicked: formula.text = calculator.typeset(formula.text + '5')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '6'
            onClicked: formula.text = calculator.typeset(formula.text + '6')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '×'
            onClicked: formula.text = calculator.typeset(formula.text + '·')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '7'
            onClicked: formula.text = calculator.typeset(formula.text + '7')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '8'
            onClicked: formula.text = calculator.typeset(formula.text + '8')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '9'
            onClicked: formula.text = calculator.typeset(formula.text + '9')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '/'
            onClicked: formula.text = calculator.typeset(formula.text + '/')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '0'
            onClicked: formula.text = calculator.typeset(formula.text + '0')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '.'
            onClicked: formula.text = calculator.typeset(formula.text + '.')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: 2 * Theme.buttonWidthSmall / 2.125 + Theme.paddingMedium
            Layout.columnSpan: 2
            text: '<b>=</b>'
            onClicked: {
              var res = calculator.calculate(formula.text)
              resultsListModel.insert(0, res)
              result.text = '= ' + res.result
            }
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'sin'
            onClicked: formula.text = calculator.typeset(formula.text + 'sin(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'asin'
            onClicked: formula.text = calculator.typeset(formula.text + 'asin(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'sinh'
            onClicked: formula.text = calculator.typeset(formula.text + 'sinh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'asinh'
            onClicked: formula.text = calculator.typeset(formula.text + 'asinh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cos'
            onClicked: formula.text = calculator.typeset(formula.text + 'cos(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acos'
            onClicked: formula.text = calculator.typeset(formula.text + 'acos(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cosh'
            onClicked: formula.text = calculator.typeset(formula.text + 'cosh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acosh'
            onClicked: formula.text = calculator.typeset(formula.text + 'acosh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'tan'
            onClicked: formula.text = calculator.typeset(formula.text + 'tan(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'atan'
            onClicked: formula.text = calculator.typeset(formula.text + 'atan(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'tanh'
            onClicked: formula.text = calculator.typeset(formula.text + 'tanh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'atanh'
            onClicked: formula.text = calculator.typeset(formula.text + 'atanh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cot'
            onClicked: formula.text = calculator.typeset(formula.text + 'cot(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acot'
            onClicked: formula.text = calculator.typeset(formula.text + 'acot(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'coth'
            onClicked: formula.text = calculator.typeset(formula.text + 'coth(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acoth'
            onClicked: formula.text = calculator.typeset(formula.text + 'acoth(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'exp'
            onClicked: formula.text = calculator.typeset(formula.text + 'exp(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'ln'
            onClicked: formula.text = calculator.typeset(formula.text + 'ln(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '!'
            onClicked: formula.text = calculator.typeset(formula.text + '!')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '°'
            onClicked: formula.text = calculator.typeset(formula.text + '°')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'abs'
            onClicked: formula.text = calculator.typeset(formula.text + 'abs(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'log'
            onClicked: formula.text = calculator.typeset(formula.text + 'log(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'rad'
            onClicked: formula.text = calculator.typeset(formula.text + 'rad(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'deg'
            onClicked: formula.text = calculator.typeset(formula.text + 'deg(')
          }
        }
      }
    }
  }

  onStatusChanged: {
    if (status === PageStatus.Active) {
      appModel.calculatorType = AppModel.SimpleCalculator
    }
  }
}
