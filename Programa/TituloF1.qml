import QtQuick 2.0

Rectangle {
    height: 30
    width: 100
    //radius: 5
    gradient: Gradient {
        GradientStop {
            position: 0.0;
            color: "#ebd499"
        }
        GradientStop {
            position: 0.2;
            color: "#e9c35f"
        }
    }
    property string strTitulo : "- No definido -"
    property color colorTitulo : "white"
    border.color: "#006d7e"

    Text {
        anchors.centerIn: parent
        text: strTitulo
        color: colorTitulo
        font.pointSize: 12
    }
}
