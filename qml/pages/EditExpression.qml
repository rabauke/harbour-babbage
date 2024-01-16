import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
  id: dialog

  property string expression
  property string description

  Column {
    width: parent.width
    spacing: Theme.paddingLarge

    DialogHeader {}

    TextArea {
      id: expressionField
      width: parent.width
      label: qsTr('Mathematical expression')
      inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
      EnterKey.iconSource: 'image://theme/icon-m-enter-next'
      EnterKey.onClicked: {
        text = appModel.calculator.typeset(text)
        descriptionField.focus = true
        descriptionField.cursorPosition = descriptionField.text.length
      }
    }
    TextArea {
      id: descriptionField
      width: parent.width
      label: qsTr('Description')
      EnterKey.iconSource: 'image://theme/icon-m-enter-next'
      EnterKey.onClicked: {
        text = text.replace('\n', '')
        focus = false
      }
    }
  }

  canAccept: expressionField.text.replace(/\s+/gm, '').length > 0

  onStatusChanged: {
    if (status === PageStatus.Active) {
      expressionField.text = expression
      descriptionField.text = description
      expressionField.focus = true
      expressionField.cursorPosition = expressionField.text.length
    }
  }

  onDone: {
    if (result === DialogResult.Accepted) {
      expression = appModel.calculator.typeset(expressionField.text)
      description = descriptionField.text
    }
  }
}
