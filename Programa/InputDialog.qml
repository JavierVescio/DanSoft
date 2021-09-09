import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: item
    anchors.fill: parent
    property string strMensaje : "Escriba un texto"
    property alias strTxtFieldText : txtField.text
    signal textoIngresado(var arg)
    visible: false

    onVisibleChanged: txtField.focus = visible

    function aceptar() {
        textoIngresado(txtField.text)
        cleanAndClose()
    }

    function cleanAndClose() {
        strMensaje = "Escriba un texto"
        txtField.text = ""
        visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.2

        MouseArea {
            anchors.fill: parent

            onClicked: {
                item.visible = false
            }
        }
    }

    Rectangle {
        height: 80
        width: 300
        anchors.centerIn: parent
        clip: true
        border.color: "blue"
        border.width: 2
        z: 5

        Column {
            anchors.fill: parent
            anchors.margins: 3
            spacing: 3

            Text {
                text: strMensaje
                x: 3
                font.family: "Verdana"
                color: "navy"
            }

            TextField {
                id: txtField
                placeholderText: qsTrId("Escriba aquí...")
                width: parent.width - 6
                x: 3
                text: strTxtFieldText
                onAccepted: {
                    if (text !== "")
                        aceptar()
                }
                onFocusChanged: {
                    if (!focus)
                        cleanAndClose()
                }
            }

            Row {
                width: parent.width
                Button {
                    text: qsTrId("Aceptar")
                    enabled: txtField.text !== ""
                    width: parent.width / 2.5
                    onClicked: aceptar()
                }
                Button {
                    width: parent.width / 2.5
                    text: qsTrId("Cancelar")
                    onClicked: cleanAndClose()
                }
            }
        }
    }
}

