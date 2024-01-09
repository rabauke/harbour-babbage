import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
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
    }
    TextArea {
      id: descriptionField
      width: parent.width
      label: qsTr('Description')
    }
  }

  onStatusChanged: {
    if (status === PageStatus.Active) {
      expressionField.text = expression
      descriptionField.text = description
    }
  }

  onDone: {
    if (result === DialogResult.Accepted) {
      expression = expressionField.text
      description = descriptionField.text
    }
  }
}
