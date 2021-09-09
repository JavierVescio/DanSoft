import QtQuick 2.0

Rectangle {
    border.color: "lightsteelblue"
    property string m_text : ""
    property color m_colorFrom : "white"
    property color m_colorTo : "#CEECF5"
    property color m_colorTextStyle : "white"
    property string m_strSourceIcon : ""
    property string m_strSourceIconExtra : ""
    signal m_clicked
    signal m_midClicled
    color: m_colorFrom
    property alias alias_opacity_image: recImage.opacity

    Behavior on color {
        ColorAnimation {duration:75}
    }

    Rectangle {
        id: recImage
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.height
        color: "transparent"
        border.color: parent.border.color

        Image {
            id: imgPrincipal
            anchors.centerIn: parent
            height: 26
            width: 26
            source: m_strSourceIcon
        }

        Image {
            id: imgSecundaria
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            height: 18
            width: 18
            source: m_strSourceIconExtra
            z: 1

            onSourceChanged: {
                if (source !== "") {
                    imgPrincipal.opacity = 0.7
                }
                else {
                    imgPrincipal.opacity = 1
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: m_text
        font.pixelSize: 13
        font.family: "verdana"
        style: Text.Outline
        styleColor: m_colorTextStyle
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        //acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onReleased: {
            /*if (pressedButtons & Qt.LeftButton) {
                m_clicked();
            }
            else if (pressedButtons & Qt.MiddleButton){
                //m_midClicled()
                m_clicked();
                wrapper.classManagementManager.abrirModulo("qrc:/vistaPrincipal/VistaInicial.qml");
            }*/

            m_clicked();
            //if (pressedButtons & Qt.MiddleButton || pressedButtons & Qt.RightButton){
            if (pressedButtons & Qt.MiddleButton){
                wrapper.classManagementManager.abrirModulo("qrc:/vistaPrincipal/VistaInicial.qml");
            }

            parent.color = m_colorTo
        }

        onExited: {
            parent.color = m_colorFrom
        }

        onEntered:
            parent.color = m_colorTo

        /*onExited:
            parent.color = m_colorFrom*/
    }
}

