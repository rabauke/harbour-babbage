import QtQuick 2.2
import Sailfish.Silica 1.0

CoverBackground {

  function format(variable, formula, result) {
      return (variable !== '') && (formula === result) ? variable + ' = ' + result : ((variable !== '' ? variable + ' = ' : '') + formula + ' = ' + result)
  }

  Image {
    source: '/usr/share/harbour-babbage/images/cover_background.png'
    x: 0
    y: parent.height - parent.width
    z: -1
    opacity: 0.125
    width: parent.width
    height: parent.width
  }

  Column {
    id: countColumn
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      topMargin: Theme.paddingMedium
      leftMargin: Theme.paddingLarge
      rightMargin: Theme.paddingLarge
    }
    spacing: Theme.paddingMedium

    Label {
      text: resultsListModel.count >= 1 ? format(resultsListModel.get(0).variable, resultsListModel.get(0).formula, resultsListModel.get(0).result) : ''
      font.pixelSize : Theme.fontSizeSmall
      color: Theme.secondaryColor
      width: parent.width
      wrapMode: Text.Wrap
      anchors.bottomMargin: Theme.paddingLarge
    }

    Label {
      text: resultsListModel.count >= 2 ? format(resultsListModel.get(1).variable, resultsListModel.get(1).formula, resultsListModel.get(1).result) : ''
      font.pixelSize : Theme.fontSizeSmall
      color: Theme.secondaryColor
      width: parent.width
      wrapMode: Text.Wrap
      anchors.bottomMargin: Theme.paddingLarge
    }

    Label {
      text: resultsListModel.count >= 3 ? format(resultsListModel.get(2).variable, resultsListModel.get(2).formula, resultsListModel.get(2).result) : ''
      font.pixelSize : Theme.fontSizeSmall
      color: Theme.secondaryColor
      width: parent.width
      wrapMode: Text.Wrap
      anchors.bottomMargin: Theme.paddingLarge
    }

  }

}
