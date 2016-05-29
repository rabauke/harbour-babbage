/*
  Copyright (C) 2016 Heiko Bauke
  Contact: Heiko Bauke <heiko.bauke@mail.de>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0


Page {
  id: main_page

  Calculator {
    id: calculator
  }

  SilicaListView {
    anchors.fill: parent
    id: listView

    VerticalScrollDecorator { flickable: listView }

    PullDownMenu {
      RemorsePopup { id: remorse_variables }
      RemorsePopup { id: remorse_output }
      MenuItem {
        text: qsTr("About Babbage")
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: qsTr("Clear variables")
        onClicked: remorse_variables.execute(qsTr("Clearing variables"),
                                             function() {
                                               calculator.clear()
                                             } )
      }
      MenuItem {
        text: qsTr("Clear output")
        onClicked: remorse_output.execute(qsTr("Clearing output"),
                                          function() {
                                            listModel.clear()
                                          } )
      }
    }

    header: Item {
      anchors.horizontalCenter: main_page.Center
      anchors.top: parent.Top
      height: pageHeader.height+formula_row.height
      width: main_page.width
      PageHeader {
        id: pageHeader
        title: qsTr("Scientific calculator")
      }
      Row {
        id: formula_row
        anchors.top: pageHeader.bottom
        spacing: Theme.paddingSmall
        TextField {
          id: formula
          width: listView.width-clearButton.width-2*Theme.paddingSmall
          text: ""
          focus: true
          placeholderText: qsTr("Mathematical expression")
          inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
          EnterKey.enabled: text.length>0
          EnterKey.onClicked: listModel.insert(0, { res: calculator.calculate(formula.text) } )
        }
        IconButton {
          id: clearButton
          anchors {
            verticalCenter: formula.top
            verticalCenterOffset: formula.textVerticalCenterOffset
          }
          icon.source: "image://theme/icon-m-backspace?" + (pressed
                                                            ? Theme.highlightColor
                                                            : Theme.primaryColor)
          onClicked: formula.text=""
        }
      }
    }

    model: listModel

    delegate: ListItem {
      width: parent.width
      contentWidth: parent.width
      contentHeight: result.height+Theme.paddingLarge
      menu: contextMenu
      Text {
        id: result
        x: Theme.horizontalPageMargin
        y: 0.5*Theme.paddingLarge
        width: parent.width-2*Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: res
      }
      Component {
        id: contextMenu
        ContextMenu {
          MenuItem {
            text: qsTr("Copy")
            onClicked: Clipboard.text=listModel.get(model.index).res
          }
          MenuItem {
            text: qsTr("Remove")
            onClicked: {
              listModel.remove(model.index)
            }
          }
        }
      }

    }

  }

}
