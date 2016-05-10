import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: about_page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Scientific calculator")
            }
            TextArea {
                width: column.width
                color: Theme.primaryColor
                readOnly: true
                wrapMode: TextEdit.Wrap
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: TextEdit.AlignJustify
                text: qsTr("This scientific calculator evaluates mathematical expressions in standard mathematical notation.  Mathematical operators for addition (+), subtraction (-), multiplication (*), division (/), exponentiation (^) and factorial (!) are supported.  The following mathematical functions may be used: abs, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, sqrt, exp, ln, erf, erfc, Gamma and round.  Enter pi for π.")
            }
            Label {
                text: "© Heiko Bauke, 2016<br><br>Fork me on github!<br><a href=\"https://github.com/rabauke/harbour-babbage\">https://github.com/rabauke/harbour-babbage</a>"
                textFormat: Text.StyledText
                width: column.width
                color: Theme.primaryColor
                linkColor: Theme.highlightColor
                //readOnly: true
                wrapMode: TextEdit.Wrap
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: TextEdit.AlignHCenter
                onLinkActivated: { Qt.openUrlExternally(link) }
            }

        }

    }

}
