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
        text: qsTr('Clear all expressions')
        onClicked: remorse_variables.execute(qsTr('Clearing all expressions'),
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
        title: qsTr('Formulary')
        titleColor: Theme.highlightColor
      }
    }

    model: appModel.expressions

    delegate: ListItem {
      id: listItem
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: ContextMenu {
        MenuItem {
          text: qsTr('Copy expression')
          onClicked: {
            Clipboard.text = modelData
          }
        }
        MenuItem {
          text: qsTr('Remove expression')
          onClicked: listItem.remorseDelete(function () {
            appModel.removeExpression(model.index)
          })
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
        text: modelData
      }
    }
  }

  onStatusChanged: {
    if (status === PageStatus.Active) {
      pageStack.pushAttached(Qt.resolvedUrl('Variables.qml'))
    }
  }

}
