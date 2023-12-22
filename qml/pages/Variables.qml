import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
  id: page

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
                                             calculator.clear())
      }
    }

    header: Item {
      anchors.horizontalCenter: page.Center
      anchors.top: parent.Top
      height: pageHeader.height
      width: page.width
      PageHeader {
        id: pageHeader
        title: qsTr('Variables')
        titleColor: Theme.highlightColor
      }
    }

    model: calculator.variables

    delegate: ListItem {
      id: listItem
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: ContextMenu {
        MenuItem {
          text: qsTr('Copy value')
          onClicked: Clipboard.text = modelData.value
        }
        MenuItem {
          text: qsTr('Copy variable name')
          onClicked: Clipboard.text = modelData.variable
        }
        MenuItem {
          text: qsTr('Copy variable')
          onClicked: Clipboard.text = modelData.variable + ' = ' + modelData.value
        }
        MenuItem {
          text: qsTr('Clear variable')
          onClicked: listItem.remorseDelete(function () {
            calculator.removeVariable(model.index)
          })
          visible: !modelData.protected
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
        text: modelData.variable + ' = ' + modelData.value
      }
    }
  }
}
