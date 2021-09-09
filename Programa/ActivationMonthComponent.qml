import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.1
import QtQuick 2.0

Rectangle {
    width: 600
    height: 35
    border.color: "blue"
    radius: 3
    property string strMonth
    property var obj
    property bool activatedMonth : false

    onObjChanged: {
        activatedMonth = wrapper.managerActiviationSerial.verificarActivacion(obj.valid_date_from)
    }

    MessageDialog {
        id: messageActivacion
        icon: StandardIcon.Information
        title: qsTrId("Activación")
        text: "¡Muchas gracias por pagar el mantenimiento!\nEspero que sigas disfrutando del programa."
    }

    Row {
        anchors.fill: parent
        anchors.margins: 3

        Rectangle {
            id: recMonth
            height: parent.height
            width: parent.width / 4.1

            Text {
                id: lblMonth
                color: "#0037c4"
                anchors.centerIn: parent
                styleColor: "#000000"
                text: strMonth
                font.family: "Arial"
                font.pointSize: 13
            }

        }

        Rectangle {
            id: recStatus
            height: parent.height
            width: parent.width / 4.1

            Text {
                anchors.centerIn: parent
                text: activatedMonth ? "activado" : "sin activar"
                font.family: "arial"
                font.pointSize: 13
                color: activatedMonth ? "green" : "red"
            }
        }

        Rectangle {
            id: recCargaSerial
            height: parent.height
            width: parent.width / 2.5
            //visible: false

            TextField {
                id: txtLlaveActivacionIngresada
                anchors.fill: parent
                placeholderText: activatedMonth ? "" : "Escriba llave de activación de 16 caracteres"
                enabled: !activatedMonth
                property int salida : -1

                onTextChanged: {
                    salida = wrapper.managerActiviationSerial.verifySerial(text, obj.valid_date_from)
                    if (salida == 0) {
                        //Error
                    }
                    else if(salida == 1) {
                        //Todo bien
                        enabled = false
                        messageActivacion.open()
                        activatedMonth = true
                        text = ""
                    }
                    else if(salida == 2){
                        //Ya activado
                    }
                    if (text.length == 0)
                        salida = -1
                }
            }
        }

        Image {
            id: imgCarga
            //source: "qrc:/media/Media/icoyes.png"
            source: {
                if (txtLlaveActivacionIngresada.salida == 0)
                    "qrc:/media/Media/icono.png"
                else if(txtLlaveActivacionIngresada.salida == 1)
                    "qrc:/media/Media/icoyes.png"
                else if (txtLlaveActivacionIngresada.salida == 2)
                    "qrc:/media/Media/icono.png"
                else if (txtLlaveActivacionIngresada.salida == -1)
                    ""
            }
        }

    }
}

