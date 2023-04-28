import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
  id: page
  property bool debug: false
  property var funcs
  property var locale: Qt.locale()

  function loadJSON(file, callback) {
      var xobj = new XMLHttpRequest();
      xobj.open('GET', file, true);
      xobj.onreadystatechange = function () {
          if (xobj.readyState === XMLHttpRequest.DONE) {
              callback(xobj);
          }
      };
      xobj.open("GET",file)
      xobj.send();
  }

  function fetchLocal(){
      debug = false;
      console.log(locale.name)
      var filename = "../components/"+locale.name + "-exprtk-prototypes.json"
      loadJSON(filename, function(doc) {
          var response = JSON.parse(doc.responseText);
          functionsListModel.clear();
          //funcs = response;
          for (var i = 0; i < response.length && i < 8000; i++) {
              functionsListModel.append(response[i]);
              //funcs[i] = response[i];
              if (debug) console.debug(JSON.stringify(funcs[i]))
          };
      });
  }

SilicaListView {
  anchors.fill: parent
  id: listView
  VerticalScrollDecorator { flickable: listView }
/*
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
*/

  header: Item {
    anchors.horizontalCenter: page.Center
    anchors.top: parent.Top
    height: pageHeader.height
    width: page.width
    PageHeader {
      id: pageHeader
      title: qsTr("Operators and Functions")
    }
  }

  model:   ListModel {
      id: functionsListModel
      //Component.onCompleted:update()
  }

  delegate: ListItem {
    width: parent.width
    contentWidth: parent.width
    contentHeight: text.height + Theme.paddingLarge
    menu: contextMenu
    Label {
        visible: false
        id: modelLabel
        text: model.name
        truncationMode: TruncationMode.Fade
        color: Theme.highlightColor
    }
    Text {
      id: text
      anchors {
          left:modelLabel.right
          leftMargin: Theme.paddingLarge
          rightMargin: Theme.paddingLarge
          bottomMargin: Theme.paddingLarge
      }

      width: parent.width - parent.width/4
      color: Theme.primaryColor
      wrapMode: TextEdit.Wrap
      font.pixelSize: Theme.fontSizeMedium
      horizontalAlignment: TextEdit.AlignLeft
      text: model.op
    }
    Component {
      id: contextMenu
      ContextMenu {
        MenuItem {
          text: qsTr("Copy func/op")
          onClicked: Clipboard.text = model.op
        }
        MenuItem {
            visible: false
          text: qsTr("Copy example")
          onClicked: Clipboard.text = model.op
        }
      }
    }
  }

}
Component.onCompleted: {
    fetchLocal()
    console.log(navigationState.name)
}

}
