import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
  id: expressionsPage

  SilicaListView {
    id: listView

    anchors.fill: parent

    VerticalScrollDecorator {
      flickable: listView
    }

    PullDownMenu {
      RemorsePopup {
        id: remorse_expressions
      }
      MenuItem {
        text: qsTr('Clear all expressions')
        onClicked: remorse_expressions.execute(qsTr('Clearing all expressions'),
                                               function() {
                                                 appModel.formulary.clear()
                                               })
      }
    }

    header: Item {
      anchors.horizontalCenter: parent.Center
      anchors.top: parent.Top
      height: pageHeader.height
      width: page.width
      PageHeader {
        id: pageHeader
        title: qsTr('Formulary')
        titleColor: Theme.highlightColor
      }
    }

    model: appModel.formulary

    delegate: ListItem {
      id: listItem
      width: parent.width
      contentWidth: parent.width
      contentHeight: expressionText.height + descriptionText.height + Theme.paddingLarge
      menu: ContextMenu {
        MenuItem {
          text: qsTr('Use expression')
          onClicked: {
            viewModel.formulaText = expression
            var res = appModel.calculator.calculate(viewModel.formulaText)
            resultsListModel.insert(0, res)
            pageStack.navigateBack(PageStackAction.Animated)
          }
        }
        MenuItem {
          text: qsTr('Copy expression')
          onClicked: {
            Clipboard.text = expression
          }
        }
        MenuItem {
          text: qsTr('Edit expression')
          onClicked: {
            var dialog = pageStack.push(Qt.resolvedUrl('EditExpression.qml'),
                                        {'expression': expression,
                                          'description': description})
            dialog.accepted.connect(function() {
              appModel.formulary.set(model.index, {
                                       expression: appModel.calculator.typeset(dialog.expression),
                                       description: dialog.description.trim()
                                     })
            })
          }
        }
        MenuItem {
          text: qsTr('Remove expression')
          onClicked: listItem.remorseDelete(function () {
            appModel.formulary.remove(model.index)
          })
        }
      }
      Text {
        id: expressionText
        x: Theme.horizontalPageMargin
        y: Theme.paddingMedium
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: expression
      }
      Text {
        id: descriptionText
        x: Theme.horizontalPageMargin
        anchors.top: expressionText.bottom
        width: parent.width - 2 * Theme.horizontalPageMargin
        height: visible ? implicitHeight : 0
        color: Theme.secondaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.AlignLeft
        text: description
        visible: text !== ''
      }
    }
  }
  
  onStatusChanged: {
    if (status === PageStatus.Active) {
      pageStack.pushAttached(Qt.resolvedUrl('Variables.qml'))
    }
  }
}
