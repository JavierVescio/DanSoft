import QtQuick 2.0

MouseArea {
    width: 34
    height: 34
    hoverEnabled: true
    property color defaultBorderColor : "black"
    property color enteredBorderColor: "red"
    property string strDireccion : ""

    /*onEntered: {
        recDecorativo.border.color = enteredBorderColor
    }

    onExited: {
        recDecorativo.border.color = defaultBorderColor
    }

    Rectangle {
        id: recDecorativo
        anchors.fill: parent
        color: "transparent"
        border.color: defaultBorderColor
        radius: 5

        Behavior on border.color {
            ColorAnimation {duration: 200}
        }
    }*/

    Image {
        height: 32
        width: 32
        anchors.centerIn: parent
        source: strDireccion
    }
}
