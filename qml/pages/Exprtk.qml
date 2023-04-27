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

  property var varstxt
  property var prefixed: "var pi := 3.141592653589793238462643383279502; var e := 2.71828182846; "

  function format(result, error) {
      return result + " " + error
    //return variable !== "" && formula === result ? variable + " := " + result : ((variable !== "" ? variable + " := " : "") + formula + " = " + result + (error !== "" ? " (" + error + ") ": ""))
  }

  /* c++ precre variant
     static const QRegularExpression assignment_regex{R"(var\s*([[:alpha:]]\w*)\s*:=\s*([[:digit:]]*);)"};
      We shift the variable handling to javascript.
  */

  function getVariables() {
      variablesListModel.clear()
      // get the internal vars common to all
      var variables = calculator.getVariables()
      for (var i in variables)
        variablesListModel.append({variable: variables[i]})

      const regex = /var\s*(\w*)\s*:=\s*(\d*);/gm;
      var m
      while ((m = regex.exec(varstxt)) !== null) {
          // This is necessary to avoid infinite loops with zero-width matches
          if (m.index === regex.lastIndex) {
              regex.lastIndex++;
          }
          // The result can be accessed through the `m`-variable.
          // add our special cases
          variablesListModel.append({variable: {"variable": m[1], "value": m[2] } })
      }

  }

  SilicaListView {
    anchors.fill: parent
    id: listView
    focus: false

    VerticalScrollDecorator { flickable: listView }

    PullDownMenu {
      //RemorsePopup { id: remorse_output }
      MenuItem {
        text: qsTr("About Babbage")
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: qsTr("Pocket calculator")
        onClicked: pageStack.replace(Qt.resolvedUrl("SimpleCalculator.qml"))
      }
      MenuItem {
        text: qsTr("Scientific calculator")
        onClicked: pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
      }

    }
    PushUpMenu {
        MenuItem {
            RemorsePopup { id: remorse_variables }
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
        height: pageHeader.height + formula.height + vars.height
        width: main_page.width
        PageHeader {
          id: pageHeader
          title: qsTr("Programmable calculator")
        }
        QueryField {
          id: vars
          anchors.top: pageHeader.bottom
          width: listView.width
          text: "var a:=0; var b:=2; var v[3]:={5,10,15};"
          placeholderText: qsTr("Variables")
          inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
          EnterKey.enabled: text.length > 0
          EnterKey.onClicked: {
            varstxt = text
            //var txt = prefixed + vars.text + " " + formula.text
            //var res = calculator.exprtk(txt)
            //result = res.result
            //resultsListModel.insert(0, res)
            //getVariables()
          }
        }
        QueryField {
          id: formula
          anchors.top: vars.bottom
          width: listView.width
          text: "for ( a ; a < v[] ; a += 1) { b+=v[a]; }"
          placeholderText: qsTr("Mathematical expression")
          inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
          EnterKey.enabled: text.length > 0
          EnterKey.onClicked: {
              varstxt = vars.text
              var txt = prefixed + vars.text + " " + formula.text
              var res = calculator.exprtk(txt)
              // clear our form to not polute other views
              // but keep results
              //res.formula = ""
              res.variable = ""
              resultsListModel.insert(0, res)
              getVariables()
          }

        }
        IconButton {
            id: help
            width: icon.width
            height: icon.height
            icon.source: "image://theme/icon-m-question"
            anchors {
              top: formula.bottom
              right: parent.right
              rightMargin: Theme.horizontalPageMargin
            }
            onClicked:  pageStack.push(Qt.resolvedUrl("../components/ExprtkMenu.qml"))
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
        x: Theme.horizontalPageMargin
        y: 0.5 * Theme.paddingLarge
        width: parent.width - 2 * Theme.horizontalPageMargin
        color: Theme.primaryColor
        wrapMode: TextEdit.Wrap
        font.pixelSize: Theme.fontSizeMedium
        horizontalAlignment: TextEdit.AlignLeft
        text: format(result, error)
        //text: result
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
      getVariables()
      pageStack.pushAttached(Qt.resolvedUrl("Variables.qml"))
    }
  }

  Component.onDestruction: {
    //console.log("MainPage off")
  }
  Component.onCompleted: {
       navigationState.name = "exprtk"
      //console.log(navigationState.name)
  }

}
