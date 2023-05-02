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
import "../components"

Page {
  id: main_page

  function format(variable, formula, result, error) {
    return variable !== "" && formula === result ? variable + " = " + result : ((variable !== "" ? variable + " = " : "") + formula + " = " + result + (error !== "" ? " (" + error + ") ": ""))
  }

  SilicaListView {
    anchors.fill: parent
    id: listView
    focus: false

    VerticalScrollDecorator { flickable: listView }

    PullDownMenu {
      RemorsePopup { id: remorse_output }
      MenuItem {
        text: qsTr("About Babbage")
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: qsTr("Pocket calculator")
        onClicked: pageStack.replace(Qt.resolvedUrl("SimpleCalculator.qml"))
      }
      MenuItem {
        text: qsTr("Remove all output")
        onClicked: remorse_output.execute(qsTr("Removing all output"),
                                          function() {
                                            resultsListModel.clear()
                                          } )
      }
    }

    Component {
      id: headerComponent
      Item {
        id: headerComponentItem
        anchors.horizontalCenter: main_page.Center
        anchors.top: parent.Top
        height: pageHeader.height + formula.height
        width: main_page.width
        PageHeader {
          id: pageHeader
          title: qsTr("Scientific calculator")
        }
        QueryField {
          id: formula
          anchors.top: pageHeader.bottom
          width: listView.width
          text: ""
          placeholderText: qsTr("Mathematical expression")
          inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhPreferNumbers
          EnterKey.enabled: text.length > 0
          EnterKey.onClicked: {
            var res = calculator.calculate(formula.text)
            resultsListModel.insert(0, res)
            formula.text = res.variable !== "" ? res.variable + " = " + res.formula : res.formula
            variablesListModel.clear()
            var variables = calculator.getVariables()
            for (var i in variables)
              variablesListModel.append({variable: variables[i]})
          }
        }
      }
    }

    header: headerComponent

    model: resultsListModel

    delegate: ListItem {
      width: parent.width
      contentWidth: parent.width
      contentHeight: result_text.height + Theme.paddingLarge
      menu: contextMenu
      Text {
        id: result_text
        focus: false
        anchors.topMargin: Theme.paddingMedium
        anchors.bottomMargin: Theme.paddingMedium
        x: Theme.horizontalPageMargin
        y: 0.5 * Theme.paddingLarge
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: format(variable, formula, result, error)
      }
      Component {
        id: contextMenu
        ContextMenu {
          MenuItem {
            text: qsTr("Copy result")
            onClicked: Clipboard.text = resultsListModel.get(model.index).result
          }
          MenuItem {
            text: qsTr("Copy formula")
            onClicked: Clipboard.text = resultsListModel.get(model.index).formula
          }
          MenuItem {
            text: qsTr("Remove output")
            onClicked: resultsListModel.remove(model.index)
          }
        }
      }
    }

  }

  onStatusChanged: {
    if (status === PageStatus.Active) {
      variablesListModel.clear()
      var variables = calculator.getVariables()
      for (var i in variables)
        variablesListModel.append({variable: variables[i]})
      pageStack.pushAttached(Qt.resolvedUrl("Variables.qml"))
    }
  }

  Component.onDestruction: {
    console.log("MainPage off")
  }

}
