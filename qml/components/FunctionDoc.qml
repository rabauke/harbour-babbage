import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property string functionText: ""
    property string descriptionText: ""

    width: parent.width
    height: label.height+description.height-Theme.paddingLarge

    Label {
        id: label
        x: Theme.horizontalPageMargin
        width: parent.width-Theme.horizontalPageMargin
        text: functionText
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeMedium
    }
    TextArea {
        id: description
        anchors.top: label.bottom
        anchors.right: label.right
        width: parent.width-Theme.paddingLarge
        color: Theme.primaryColor
        readOnly: true
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignJustify
        text: descriptionText
    }
}

