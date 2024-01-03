import QtQuick 2.0
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import "../components"


Page {
  id: simpleCalculatorPage
  allowedOrientations: Orientation.Portrait

  property string result
  property string memory

  function enter(str) {
    result = ''
    formula.text = calculator.typeset(formula.text + str)
  }

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
        onClicked: enter(memory)
      }
      MenuItem {
        text: qsTr('Save result')
        onClicked: {
          Clipboard.text = result
          memory = result
        }
      }
    }

    PageHeader {
      id: pageHeader
      title: qsTr('Pocket calculator')
    }

    TextArea {
      id: formula

      anchors {
        left: parent.left
        right: parent.right
        top: pageHeader.bottom
        topMargin: Theme.paddingLarge
      }

      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeMedium : Theme.fontSizeSmall
      color: Theme.primaryColor
      backgroundStyle: TextEditor.NoBackground
    }

    Text {
      id: resultItem

      anchors {
        left: parent.left
        right: parent.right
        top: formula.bottom
        leftMargin: 2 * Theme.paddingMedium
        rightMargin: 2 * Theme.paddingMedium
      }

      text: '= ' + result
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
        top: resultItem.bottom
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
      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: Screen.sizeCategory
                      >= Screen.Large ? 4 * Theme.paddingLarge : 2 * Theme.paddingLarge
      }
      height: (Screen.sizeCategory >= Screen.Large ? Theme.itemSizeMedium : Theme.itemSizeExtraSmall) * 6 + Theme.paddingMedium *6

      model: 2
      delegate: Item {
        width: view.width
        height: view.height
        GridLayout {
          id: grid
          anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
          }
          rows: 6
          columns: 4
          rowSpacing: Theme.paddingMedium
          columnSpacing: Theme.paddingMedium

          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '√'
            onClicked: enter('√(')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '^'
            onClicked: enter('^')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '<b>AC</b>'
            onClicked: {
              formula.text = ''
              result = ''
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
              result = ''
            }
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '('
            onClicked: enter('(')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: ')'
            onClicked: enter(')')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'π'
            onClicked: enter('π')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '+'
            onClicked: enter('+')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '1'
            onClicked: enter('1')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '2'
            onClicked: enter('2')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '3'
            onClicked: enter('3')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '−'
            onClicked: enter('−')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '4'
            onClicked: enter('4')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '5'
            onClicked: enter('5')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '6'
            onClicked: enter('6')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '×'
            onClicked: enter('·')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '7'
            onClicked: enter('7')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '8'
            onClicked: enter('8')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '9'
            onClicked: enter('9')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '/'
            onClicked: enter('/')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '0'
            onClicked: enter('0')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '.'
            onClicked: enter('.')
          }
          PCButton {
            visible: model.index === 0
            Layout.preferredWidth: 2 * Theme.buttonWidthSmall / 2.125 + Theme.paddingMedium
            Layout.columnSpan: 2
            text: '<b>=</b>'
            onClicked: {
              if (formula.text != '') {
                var res = calculator.calculate(formula.text)
                resultsListModel.insert(0, res)
                result = res.result
              }
            }
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'sin'
            onClicked: enter('sin(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'asin'
            onClicked: enter('asin(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'sinh'
            onClicked: enter('sinh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'asinh'
            onClicked: enter('asinh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cos'
            onClicked: enter('cos(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acos'
            onClicked: enter('acos(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cosh'
            onClicked: enter('cosh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acosh'
            onClicked: enter('acosh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'tan'
            onClicked: enter('tan(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'atan'
            onClicked: enter('atan(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'tanh'
            onClicked: enter('tanh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'atanh'
            onClicked: enter('atanh(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'cot'
            onClicked: enter('cot(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acot'
            onClicked: enter('acot(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'coth'
            onClicked: enter('coth(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'acoth'
            onClicked: enter('acoth(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'exp'
            onClicked: enter('exp(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'ln'
            onClicked: enter('ln(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '!'
            onClicked: enter('!')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: '°'
            onClicked: enter('°')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'abs'
            onClicked: enter('abs(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'log'
            onClicked: enter('log(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'rad'
            onClicked: enter('rad(')
          }
          PCButton {
            visible: model.index === 1
            Layout.preferredWidth: Theme.buttonWidthSmall / 2.125
            text: 'deg'
            onClicked: enter('deg(')
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
