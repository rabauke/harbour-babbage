import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
  id: about_page

  SilicaFlickable {
    anchors.fill: parent
    contentHeight: column.height

    Column {
      id: column

      width: parent.width
      spacing: Theme.paddingMedium

      PageHeader {
        title: qsTr("About Babbage")
      }
      TextArea {
        width: column.width
        color: Theme.primaryColor
        readOnly: true
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignJustify
        text: qsTr("_discription_")
      }
      Button {
        text: qsTr("List of functions")
        anchors.horizontalCenter: parent.horizontalCenter
        preferredWidth: Theme.buttonWidthLarge
        onClicked: pageStack.push(Qt.resolvedUrl("Functions.qml"))
      }
      Label {
        text: "<br>© Heiko Bauke, 2016—2017<br><br>Fork me on github!<br><a href=\"https://github.com/rabauke/harbour-babbage\">https://github.com/rabauke/harbour-babbage</a><br>"
        textFormat: Text.StyledText
        width: column.width
        color: Theme.primaryColor
        linkColor: Theme.highlightColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.AlignHCenter
        onLinkActivated: { Qt.openUrlExternally(link) }
      }

    }

  }

}
