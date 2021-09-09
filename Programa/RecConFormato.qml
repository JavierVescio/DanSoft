import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    property string p_strTexto : "-"
    property string p_strTitulo : "-"
    property bool isMail: false

    Rectangle {
        id: recTitulo
        y: 5
        height: 25
        width: parent.width
        color: "#e5ecf5"

        Text {
            id: lblTitulo
            anchors.fill: parent
            anchors.margins: 3
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "tahoma"
            font.pixelSize: 14
            color: "white"
            text: p_strTitulo
            style: Text.Outline
            styleColor: "#006d7e"
        }
    }

    TextEdit {
        id: txtValor
        anchors.top: recTitulo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 3
        text: p_strTexto
        readOnly: true
        font.family: "tahoma"
        font.pixelSize: 13
        wrapMode: Text.WrapAnywhere

        MouseArea {
            anchors.fill: parent
            property bool seleccion : true

            onDoubleClicked: {
                if (seleccion) {
                    parent.selectAll()
                    parent.copy()
                    seleccion = false
                }
                else {
                    seleccion = true
                    parent.deselect()
                }
            }
        }

        Image {
            id: btnMail
            visible: isMail && parent.text.length > 0
            opacity: 0.7
            anchors{
                top:parent.top
                topMargin: -4
                right: parent.right
            }
            source: "qrc:/media/Media/mailicon.png"
            z: 1
            fillMode: Image.PreserveAspectFit
            height: 25
            width: height

            Behavior on opacity {PropertyAnimation{}}

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered:
                    parent.opacity = 1

                onExited:
                    parent.opacity = .7

                onClicked: {
                    wrapper.classManagementManager.enviarMail(txtValor.text)
                }
            }
        }
    }
}
