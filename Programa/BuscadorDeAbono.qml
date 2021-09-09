import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    width: 200
    height: 28
    color: "transparent"

    SearchBox {
        anchors.fill: parent
        strLblTexto: qsTrId("Abono")
        aliasTxtTexto.placeholderText: "Escriba un número de abono"
        aliasTxtTexto.inputMask: "000000000;_"

        aliasTxtTexto.onAccepted: {
            console.debug("Putooooooooooooooooo")
        }
    }
}

