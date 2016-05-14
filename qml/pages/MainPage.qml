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

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.babbage.qmlcomponents 1.0


Page {
    id: main_page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About Babbage")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Copy")
                onClicked: Clipboard.text = app_window.lastformula
            }
        }

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader {
                id: header
                title: qsTr("Scientific calculator")
            }
            Calculator {
                id: calculator
            }
            Row {
                spacing: Theme.paddingSmall
                TextField {
                    id: formula
                    width: column.width-clearButton.width-2*Theme.paddingSmall
                    text: ""
                    focus: true
                    placeholderText: qsTr("Enter mathematical expression")
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    EnterKey.enabled: text.length>0
                    EnterKey.onClicked: { app_window.lastformula = calculator.calculate(formula.text);
                        results.text = "•  "+app_window.lastformula+"\n"+results.text; }
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
                    onClicked: formula.text = ""
                }
            }
            TextArea {
                id: results
                width: column.width
                color: Theme.primaryColor
                readOnly: true
                wrapMode: TextEdit.Wrap
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: TextEdit.AlignLeft
                text: ""
            }

        }

    }

}
