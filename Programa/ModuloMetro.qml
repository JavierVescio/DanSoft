import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"

Rectangle {
    color: "#FAFAFA"
    border.color: "black"
    anchors.margins: 1
    property color colorTitulo : "#F3E2A9"
    property string strTitulo : qsTrId("Título No Definido")
    property string strDescripcion : qsTrId("Descripción No Definido")
    property string strImagen : ""
    property string strImgBackground : ""
    property int heightTitulo : 30
    property bool canRotate: true

    Rectangle {
        id: recTitulo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: heightTitulo
        color: colorTitulo
        border.width: 2

        Image {
            id: imgRotate
            source: "qrc:/media/Media/rotate-metro.png"
            width: 30
            y: 2
            x: 2
            fillMode: Image.PreserveAspectFit
            opacity: 0.2
            visible: canRotate
        }

        Text {
            id: lblTitulo
            anchors.centerIn: parent
            text: strTitulo
            style: Text.Outline
            font.pixelSize: 19
            font.family: "verdana"
            styleColor: "white"
        }
    }

    Image {
        id: imgModuloMetro
        anchors.top: recTitulo.bottom
        anchors.left: parent.left
        fillMode: Image.PreserveAspectFit
        //anchors.margins: 3
        source: strImagen
        height: 64
        width: strImagen === "" ? 0 : 64
    }

    Image {
        id: imgBackgroundMetro
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: strImgBackground
        opacity: 0.1
        visible:true
        z: 1
    }

    Rectangle {
        id: recDescripcion
        anchors.left: imgModuloMetro.right
        anchors.top: recTitulo.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 3
        radius: 1
        color: "transparent"

        Text {
            anchors.fill: parent
            text: strDescripcion
            font.pixelSize: 12
            font.family: "verdana"
        }
    }
}
