import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0
import '../components'

Page {
  id: main_page

  function format(variable, formula, result, error) {
    return variable !== '' && formula
        === result ? variable + ' = '
                     + result : ((variable !== '' ? variable + ' = ' : '') + formula
                                 + ' = ' + result + (error !== '' ? ' (' + error + ') ' : ''))
  }

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

    Component {
      id: headerComponent
      Item {
        id: headerComponentItem
        anchors.horizontalCenter: main_page.Center
        anchors.top: parent.Top
        height: pageHeader.height + formula.height
        width: main_page.width
        PageHeader {
          id: pageHeader
          title: qsTr('Scientific calculator')
        }
        QueryField {
          id: formula
          anchors.top: pageHeader.bottom
          width: listView.width
          text: ''
          placeholderText: qsTr('Mathematical expression')
          inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
          EnterKey.enabled: text.length > 0
          EnterKey.onClicked: {
            var res = calculator.calculate(formula.text)
            resultsListModel.insert(0, res)
            formula.text = res.variable !== '' ? res.variable + ' = ' + res.formula : res.formula
            variablesListModel.clear()
            var variables = calculator.getVariables()
            for (var i in variables)
              variablesListModel.append({
                                          'variable': variables[i]
                                        })
          }
        }
      }
    }

    header: headerComponent

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
      variablesListModel.clear()
      var variables = calculator.getVariables()
      for (var i in variables)
        variablesListModel.append({
                                    'variable': variables[i]
                                  })
      pageStack.pushAttached(Qt.resolvedUrl('Variables.qml'))
    }
  }

}
