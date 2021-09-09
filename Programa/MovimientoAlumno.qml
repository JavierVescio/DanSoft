import QtQuick 2.0

Rectangle {
    height: 25
    width: 50
    color: "transparent"
    //border.color: "black"
    //color: listaDias.model[index] !== null ? "blue" : "grey"

    property bool hayMovimiento: false
    property string textDayName: ""
    property bool esHoy: false

    Rectangle {
        id: recBordeSuperior
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#C8E6C9"
    }

    Rectangle {
        id: recBordeDerecho
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 2
        color: "black"
        visible: textDayName === "dom."
    }


    Text {
        anchors.fill: parent
        anchors.rightMargin: 3
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        visible: hayMovimiento
        text: "$"
        font.family: "verdana"
        font.pixelSize: 16
        font.bold: true
        color: "white"
    }

    Text {
        id: nombreDia
        x: 1
        text: textDayName
        color: esHoy ? "#795548" : "black"
        font.italic: esHoy

        onTextChanged: {
            if (text === "sáb."){
                font.underline = true
                font.bold = true
            }
            else if (text === "dom."){
                font.underline = true
                font.bold = true
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: !esHoy
        opacity: 0.3
        color: "#E0E0E0"
        z:1
    }

    /*MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!hayMovimiento) {
                parent.color = "#A5D6A7"
            }
        }

        onExited: {
            if (!hayMovimiento) {
                parent.color = "transparent"
            }
        }

    }*/
}
