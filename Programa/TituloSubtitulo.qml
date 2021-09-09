import QtQuick 2.0

Item {
    property alias aliasLblTitulo : lblTitle
    property alias aliasLblSubtitulo : lblSubtitle
    property color colorLblTitulo : "#2E9AFE"
    property color colorRecSubtitulo : "#2E9AFE"
    property color colorLblSubtitulo : "white"
    property color colorBackgroundTitle: "white"
    property int heightItem : lblTitle.height + recSubtitle.height

    Text {
        id: lblTitle
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 23
        font.family: "Verdana"
        text: "TITULO"
        color: colorLblTitulo
        z: 1
    }

    Rectangle {
        anchors.fill: lblTitle
        color: colorBackgroundTitle
        z: 0
    }

    Rectangle {
        id: recSubtitle
        anchors.top: lblTitle.bottom
        width: parent.width
        height: 30
        color: colorRecSubtitulo
        z: 20

        Text {
            id: lblSubtitle
            anchors.fill: parent
            anchors.margins: 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: colorLblSubtitulo
            font.family: "Verdana"
            font.pixelSize: 14
            text: "ESTO ES UN SUBTITULO"
        }
    }
}

