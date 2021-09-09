import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
    id: item
    anchors.fill: parent
    property string strSource
    visible: false

    function cleanAndClose() {
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

    Image {
        id: imgProfile
        anchors.centerIn: parent
        cache: false
        source: strSource
        z: 10

        MouseArea {
            anchors.fill: parent

            onClicked:
                cleanAndClose()
        }
    }

    Rectangle {
        id: recImagen
        anchors.fill: imgProfile
        anchors.margins: -5
        border.color: "#006d7e"
        radius: 5
        z: 1
    }
}
