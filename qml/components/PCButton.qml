import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
  id: button

  property bool down: pressed && containsMouse
  property alias text: buttonText.text
  property bool _showPress: down || pressTimer.running
  property color color: Theme.primaryColor
  property color highlightColor: Theme.highlightColor
  property color highlightBackgroundColor: Theme.highlightBackgroundColor
  property real preferredWidth: Theme.buttonWidthSmall
  property bool __silica_button

  onPressedChanged: {
    if (pressed) {
      pressTimer.start()
    }
  }

  onCanceled: {
    pressTimer.stop()
  }

  height: Screen.sizeCategory >= Screen.Large ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall
  width: Screen.sizeCategory >= Screen.Large ? Theme.buttonWidthSmall / 1.75 : Theme.buttonWidthSmall / 2.125

  Rectangle {
    anchors {
      fill: parent
    }
    radius: Theme.paddingSmall
    color: _showPress ? Theme.rgba(
                          button.highlightBackgroundColor,
                          Theme.highlightBackgroundOpacity) : Theme.rgba(
                          button.color, 0.2)

    opacity: button.enabled ? 1.0 : 0.4

    Text {
      id: buttonText
      anchors.centerIn: parent
      color: _showPress ? button.highlightColor : button.color
      font.pointSize: Screen.sizeCategory
                      >= Screen.Large ? Theme.fontSizeLarge : Theme.fontSizeMedium
    }
  }

  Timer {
    id: pressTimer
    interval: Theme.minimumPressHighlightTime
  }
}
