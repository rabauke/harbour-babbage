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

Page {
    id: page
    property bool loggingIn: false;

    Column {
        id: fields
        spacing: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.top: logo.bottom
        anchors.topMargin: 100

        TextField {
            id: username
            placeholderText: "Username"
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Keys.onReturnPressed: {
                if (username.text.length > 0 && password.text.length > 0) {
                    login()
                } else {
                    password.forceActiveFocus()
                }
            }
        }
        TextField {
            id: password
            placeholderText: "Password"
            echoMode: TextInput.Password
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Keys.onReturnPressed: {
                if (username.text.length > 0 && password.text.length > 0) {
                    login()
                } else {
                    username.forceActiveFocus()
                }
            }
        }

        Item {
            height: 10
            width: 1
        }

        Button {
            id: button
            text: "Log in"

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            enabled: username.text.length > 0 && password.text.length > 0
            onClicked: {
                login()
            }
        }

        Item {
            height: 20
            width: 1
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: 20
            onLinkActivated: Qt.openUrlExternally(link)
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            text: "<style>a:link { color: " + Theme.highlightColor
                  + "; }</style>Don't have a Libre.fm account?<br><a href='http://libre.fm'>Register for free</a>."
        }
    }


    function login() {
    }

    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 20
        visible: loggingIn
        spacing: 20

        Label {
            id: loggingText
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Logging in"
        }

        BusyIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            running: parent.visible
        }
    }
}
