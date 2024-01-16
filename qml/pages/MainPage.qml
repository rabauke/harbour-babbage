import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import '../components'


Page {
  id: mainPage

  function format(variable, formula, result, error) {
    return variable !== '' && formula
        === result ? variable + ' = '
                     + result : ((variable !== '' ? variable + ' = ' : '') + formula
                                 + ' = ' + result + (error !== '' ? ' (' + error + ') ' : ''))
  }

  property string formulaText: ''

  SilicaListView {
    anchors.fill: parent
    id: listView
    focus: false

    VerticalScrollDecorator {
      flickable: listView
    }

    PullDownMenu {
      RemorsePopup {
        id: remorse_output
      }
      MenuItem {
        text: qsTr('About Babbage')
        onClicked: pageStack.push(Qt.resolvedUrl('About.qml'))
      }
      MenuItem {
        text: qsTr('Pocket calculator')
        onClicked: pageStack.replace(Qt.resolvedUrl('SimpleCalculator.qml'))
      }
      MenuItem {
        text: qsTr('Remove all output')
        onClicked: remorse_output.execute(qsTr('Removing all output'),
                                          function () {
                                            resultsListModel.clear()
                                          })
      }
    }

    header: Item {
      id: headerItem
      anchors.horizontalCenter: mainPage.Center
      anchors.top: parent.Top
      height: pageHeader.height + formula.height
      width: mainPage.width
      PageHeader {
        id: pageHeader
        title: qsTr('Scientific calculator')
        titleColor: Theme.highlightColor
      }
      QueryField {
        id: formula
        anchors.top: pageHeader.bottom
        width: listView.width
        placeholderText: qsTr('Mathematical expression')
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
        EnterKey.iconSource: 'image://theme/icon-m-enter-next'
        EnterKey.enabled: text.length > 0
        EnterKey.onClicked: {
          var res = appModel.calculator.calculate(formula.text)
          resultsListModel.insert(0, res)
          formula.text = res.variable !== '' ? res.variable + ' = ' + res.formula : res.formula
        }
      }    
      Binding {
        target: formula
        property: 'text'
        value: viewModel.formulaText
      }
    }

    model: resultsListModel

    delegate: ListItem {
      id: listItem
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: ContextMenu {
        MenuItem {
          text: qsTr('Copy result')
          onClicked: Clipboard.text = resultsListModel.get(model.index).result
        }
        MenuItem {
          text: qsTr('Copy formula')
          onClicked: Clipboard.text = resultsListModel.get(model.index).formula
        }
        MenuItem {
          text: qsTr('Add formula to formulary')
          onClicked: appModel.formulary.add({expression: resultsListModel.get(model.index).formula, description: ''})
        }
        MenuItem {
          text: qsTr('Clear output')
          onClicked: listItem.remorseDelete(function () {
            resultsListModel.remove(model.index)
          })
        }
      }
      Text {
        id: result_text
        focus: false
        anchors.topMargin: Theme.paddingMedium
        anchors.bottomMargin: Theme.paddingMedium
        x: Theme.horizontalPageMargin
        y: Theme.paddingMedium
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: format(variable, formula, result, error)
      }
    }
  }

  onStatusChanged: {
    if (status === PageStatus.Active) {
      pageStack.pushAttached(Qt.resolvedUrl('Expressions.qml'))
      appModel.calculatorType = AppModel.ScientificCalculator
    }
  }
}
