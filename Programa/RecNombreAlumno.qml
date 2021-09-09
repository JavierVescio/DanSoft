import QtQuick 2.0
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    id: recAlumno
    //border.color: "grey"
    color: "#A1887F"
    width: 200
    height: 25

    property var recordCliente: null
    property int tipoInfo: 1

    WrapperClassManagement {
        id: wrapper
    }

    Text {
        anchors.fill: parent
        anchors.topMargin: 6
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "verdana"
        font.pixelSize: 14
        color: "white"
        text: {
            if (recordCliente !== null ) {
                if (tipoInfo === 1){
                    recordCliente.apellido + ", " + recordCliente.primerNombre
                }
                else if (tipoInfo === 2){
                    recordCliente.dni
                }

                else {
                    ""
                }
            }
            else{
                ""
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            wrapper.classManagementManager.clienteSeleccionado = recordCliente
        }

        onPressed: {
            recEfecto.opacity = .2
        }

        onReleased: {
            recEfecto.opacity = 1
        }

        onExited: {
            recEfecto.opacity = 0
        }

    }

    Rectangle {
        id: recEfecto
        anchors.fill: parent
        color: "white"
        z:1
        opacity: 0

        Behavior on opacity{PropertyAnimation{duration: 50; easing.type: Easing.InCubic}}

        onOpacityChanged: {
            if (opacity >= 0.3)
                opacity = 0

        }
    }
}
