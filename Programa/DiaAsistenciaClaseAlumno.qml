import QtQuick 2.0
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    height: 25
    width: 50
    color: "transparent"
    //border.color: "black"

    property var nroDia: "-1"
    property bool esHoy: false
    property bool tienePresente: false
    property variant recordCliente: null
    property string textDayName: ""

    onTextDayNameChanged: {
        if (textDayName === "sáb."){
            name.font.underline = true
            name.font.bold = true
        }
        else if (textDayName === "dom."){
            name.font.underline = true
            name.font.bold = true
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: {
            if (wrapper.classManagementManager.clienteSeleccionado !== null){
                recordCliente === wrapper.classManagementManager.clienteSeleccionado //&& esHoy
            }
            else
                false
        }
        opacity: 0.5
        color: "#CE93D8"
        z:1

        /*onVisibleChanged: {
            if (!tienePresente && esHoy){
                if (visible) {
                    imgPresente.visible = true
                }
                else {
                    imgPresente.visible = false
                }
            }
            else {
                imgPresente.visible = tienePresente
            }
        }*/
    }

    Rectangle {
        id: recBordeSuperior
        anchors.top: parent.top
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
        //color: "#C8E6C9"
        color: "black"
        visible: textDayName === "dom."
    }



    WrapperClassManagement {
        id: wrapper
    }

    Image {
        id: imgPresente
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: tienePresente
        source: "qrc:/media/Media/asistiendo.PNG"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: name
        text: (nroDia+1)
        color: esHoy ? "#795548" : "black"
        font.italic: esHoy
    }

    Rectangle {
        anchors.fill: parent
        visible: !esHoy
        opacity: 0.3
        color: "#E0E0E0"
        z:1
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!tienePresente) {
                parent.color = "#CE93D8"
                //imgPresente.visible = true

            }
        }

        onClicked: {
            wrapper.classManagementManager.clienteSeleccionado = recordCliente
        }

        onDoubleClicked: {
            wrapper.classManagementManager.clienteSeleccionado = recordCliente
            wrapper.managerAsistencias.intentarRegistrarPresenteTablaInfantil()
        }


        onExited: {
            if (!tienePresente) {
                //imgPresente.visible = tienePresente
                parent.color = "white"
            }
        }

    }
}
