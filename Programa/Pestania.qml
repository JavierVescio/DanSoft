import QtQuick 2.0

Rectangle {
    width: 220
    height: 40
    border.color: "lightgrey"
    radius: 2

    property color p_colorPestania: "transparent"

    /*gradient: Gradient {
        GradientStop {
            id: grad1
            position: 1.00;
            color: "transparent";
        }
        GradientStop {
            id: grad2
            position: 0;
            color: grad1.color
        }
    }*/

    gradient: Gradient {
        GradientStop {
            id: grad1
            position: 1.00;
            color: p_colorPestania
        }
        GradientStop {
            id: grad2
            position: 0;
            color: "white"
        }
    }

    property string p_strTitulo : ""
    property bool p_principal : false
    property string p_strSource : ""
    property variant p_objPestania : null
    property alias objConnexion : conexionObjPestania
    signal pestaniaClicked;
    signal cerrarClicked;


    //property alias p_colorPestania : grad1.color   //"lightsteelblue"

    Component.onCompleted: {
        if (p_principal) {
            grad2.color = "grey"
            width = 225
        }
        else {
            anchors.topMargin = 3
            lblTitulo.anchors.bottomMargin = 3
        }
    }

    Connections {
        id: conexionObjPestania
        ignoreUnknownSignals: true

        onSig_mostrarme: {
            pestaniaClicked()
        }
    }

    Rectangle {
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        height: 30

        Text {
            id: lblTitulo
            anchors.centerIn: parent
            text: p_strTitulo
            font.family: "Franklin Gothic Book"
            font.pointSize: 12
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onPressed: {
            if (pressedButtons & Qt.MiddleButton)
                cerrarClicked()
            else
                pestaniaClicked();
        }

        onDoubleClicked: {
            //if (p_principal){
                menuOpciones.visible = !menuOpciones.visible
                menuAcercaDe.visible = !menuAcercaDe.visible
                statusBar.visible = !statusBar.visible
            //}
        }

        hoverEnabled: true

        onEntered: {
            recBotonCerrar.opacity = 0.3
        }

        onExited: {
            recBotonCerrar.opacity = 0
        }
    }

    Rectangle {
        id: recBotonCerrar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: 8
        height: 17
        width: 17
        anchors.margins: 5
        radius: 1
        border.width: 1
        border.color: "grey"
        color: "red"
        opacity: 0
        visible: !p_principal
        enabled: !p_principal

        Behavior on opacity {PropertyAnimation{}}

        Text {
            id: lblCruz
            text: "x"
            x: 6
            y: 2
            opacity: 0.9
            font.pixelSize: 9
        }


        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            hoverEnabled: true

            onEntered: {
                recBotonCerrar.opacity = 0.3
            }

            onExited: {
                recBotonCerrar.opacity = 0
            }

            onClicked: {
                cerrarClicked()
            }
        }
    }
}
