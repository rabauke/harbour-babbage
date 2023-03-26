import QtQuick 2.2
import Sailfish.Silica 1.0


Page {
  id: page

  SilicaListView {
    anchors.fill: parent
    id: listView

    VerticalScrollDecorator { flickable: listView }

    PullDownMenu {
      RemorsePopup { id: remorse_variables }
      MenuItem {
        text: qsTr("Clear all variables")
        onClicked: remorse_variables.execute(qsTr("Clearing all variables"),
                                             function() {
                                               calculator.clear()
                                               variablesListModel.clear()
                                               var variables=calculator.getVariables()
                                               for (var i in variables)
                                                 variablesListModel.append({variable: variables[i]})
                                             } )
      }
    }

    header: Item {
      anchors.horizontalCenter: page.Center
      anchors.top: parent.Top
      height: pageHeader.height
      width: page.width
      PageHeader {
        id: pageHeader
        title: qsTr("Variables")
      }
    }

    model: variablesListModel

    delegate: ListItem {
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: contextMenu
      Text {
        id: result_text
        x: Theme.horizontalPageMargin
        y: 0.5 * Theme.paddingLarge
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: variable
      }
      Component {
        id: contextMenu
        ContextMenu {
          MenuItem {
            text: qsTr("Copy value")
            onClicked: Clipboard.text = variablesListModel.get(model.index).variable.split(" = ")[1]
          }
          MenuItem {
            text: qsTr("Copy variable name")
            onClicked: Clipboard.text = variablesListModel.get(model.index).variable.split(" = ")[0]
          }
          MenuItem {
            text: qsTr("Copy variable")
            onClicked: Clipboard.text = variablesListModel.get(model.index).variable
          }
          MenuItem {
            text: qsTr("Clear variable")
            onClicked: {
              calculator.removeVariable(model.index)
              variablesListModel.remove(model.index)
            }
            visible: variable.substr(0, 2) !== "π " && variable.substr(0, 2) !== "e "
          }
        }
      }
    }

  }

}
