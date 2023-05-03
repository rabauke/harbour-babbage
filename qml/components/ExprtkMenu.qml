import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
  id: page
  property bool debug: true
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
      //var filename = locale.name + "-exprtk-functions.json"
      var filename = "en_US-exprtk-functions.json"
      loadJSON(filename, function(doc) {
          var response = JSON.parse(doc.responseText);
          functionsListModel.clear();
          //funcs = response;
          for (var i = 0; i < response.length && i < 8000; i++) {
              functionsListModel.append(response[i]);
              //funcs[i] = response[i];
          };
      });

  }

  SilicaListView {
  anchors.fill: parent
  id: listView
  VerticalScrollDecorator { flickable: listView }

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
  }

  delegate: ListItem {
    width: parent.width
    contentWidth: parent.width
    contentHeight: text.height + Theme.paddingLarge
    menu: contextMenu
    Label {
        anchors {
          rightMargin: Theme.paddingSmall
          leftMargin: Theme.paddingSmall
        }
        width: parent.width * 1/4 - Theme.paddingMedium
        id: modelLabel
        text: model.name
        truncationMode: TruncationMode.Fade
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
    }
    Text {
      id: text
      anchors {
          left:modelLabel.right
          leftMargin: Theme.paddingSmall
          rightMargin: Theme.paddingSmall
          bottomMargin: Theme.paddingSmall
      }

      width: parent.width * 3/4 - Theme.paddingMedium
      color: Theme.primaryColor
      wrapMode: TextEdit.Wrap
      font.pixelSize: Theme.fontSizeSmall
      horizontalAlignment: TextEdit.AlignLeft
      text: model.desc
    }
    Component {
      id: contextMenu
      ContextMenu {
        MenuItem {
          text: qsTr("Copy operator")
          onClicked: Clipboard.text = model.name
        }
        MenuItem {
          text: qsTr("Copy example")
          onClicked: Clipboard.text = model.example
        }
      }
    }
  }

}
Component.onCompleted: {
    fetchLocal()
    if (debug) console.log(navigationState.name)
}

}
