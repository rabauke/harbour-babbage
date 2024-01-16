import QtQuick 2.2
import Sailfish.Silica 1.0


Page {
  id: variablesPage

  SilicaListView {
    anchors.fill: parent
    id: listView

    VerticalScrollDecorator {
      flickable: listView
    }

    PullDownMenu {
      RemorsePopup {
        id: remorse_variables
      }
      MenuItem {
        text: qsTr('Clear all variables')
        onClicked: remorse_variables.execute(qsTr('Clearing all variables'),
                                             function() {
                                               appModel.calculator.variables.clear()
                                             })
      }
    }

    header: Item {
      anchors.horizontalCenter: parent.Center
      anchors.top: parent.Top
      height: pageHeader.height
      width: page.width
      PageHeader {
        id: pageHeader
        title: qsTr('Variables')
        titleColor: Theme.highlightColor
      }
    }

    model: appModel.calculator.variables

    delegate: ListItem {
      id: listItem
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: ContextMenu {
        MenuItem {
          text: qsTr('Copy value')
          onClicked: Clipboard.text = appModel.calculator.typeset(value)
        }
        MenuItem {
          text: qsTr('Copy variable name')
          onClicked: Clipboard.text = appModel.calculator.typeset(name)
        }
        MenuItem {
          text: qsTr('Copy variable')
          onClicked: Clipboard.text = appModel.calculator.typeset(name + ' = ' + value)
        }
        MenuItem {
          text: qsTr('Clear variable')
          onClicked: listItem.remorseDelete(function () {
            appModel.calculator.variables.remove(name)
          })
          visible: !is_protected
        }
      }
      Text {
        id: result_text
        x: Theme.horizontalPageMargin
        y: Theme.paddingMedium
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: appModel.calculator.typeset(name + '=' + value)
      }
    }
  }
}
