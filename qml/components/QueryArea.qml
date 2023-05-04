import QtQuick 2.0
import Sailfish.Silica 1.0

TextArea {
  id: queryField

  implicitWidth: _editor.implicitWidth + Theme.paddingSmall + Theme.itemSizeSmall
  implicitHeight: Theme.itemSizeSmall

  focusOutBehavior: FocusBehavior.ClearPageFocus

  font {
    pixelSize: Theme.fontSizeMedium
    family: Theme.fontFamilyHeading
  }

  textLeftMargin: Theme.horizontalPageMargin
  textRightMargin: text.length == 0 ? Theme.horizontalPageMargin
                                    : Theme.itemSizeSmall + Theme.paddingMedium //+ Theme.horizontalPageMargin
  textTopMargin: height/2 - _editor.implicitHeight/2
  labelVisible: false

  placeholderText: ""
  onFocusChanged: if (focus) cursorPosition = text.length

  inputMethodHints: Qt.ImhNoPredictiveText

  Item {
    parent: queryField
    anchors.fill: parent

    IconButton {
      id: clearButton
      anchors {
        right: parent.right
        bottom: parent.bottom
        rightMargin: Theme.paddingMedium
      }
      width: icon.width
      height: icon.height
      icon.source: "image://theme/icon-m-clear"

      enabled: queryField.enabled

      opacity: queryField.text.length > 0 && enabled ? 1 : 0
      Behavior on opacity {
        FadeAnimation {}
      }

      onClicked: {
        queryField.text = ""
        queryField._editor.forceActiveFocus()
      }
    }
  }

}
