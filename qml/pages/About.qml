import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    Column {
        id: column

        width: page.width
        spacing: Theme.paddingLarge
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
            text: qsTr("This scientific calculator evaluates mathematical expressions in standard mathematical notation.  Mathematical operators for addition (+), subtraction (-), multiplication (*), division (/) and exponentiation (^) are supported.  The following mathematical functions may be used: abs, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, sqrt, exp, ln, erf and erfc.  Enter pi for π.")
        }
        TextArea {
            width: column.width
            color: Theme.primaryColor
            readOnly: true
            wrapMode: TextEdit.Wrap
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: TextEdit.AlignHCenter
            text: "Fork me on github!\nhttps://github.com/rabauke/harbour-babbage"
        }

    }

}
