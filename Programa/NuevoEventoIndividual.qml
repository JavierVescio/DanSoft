import QtQuick 2.0
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

Rectangle {
    color: "transparent"
    height: 50

    Component.onCompleted:
        txtDescripcion.focus = true

    WrapperClassManagement{
        id: wrapper
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onFechaSeleccionadaChanged: {
            txtFecha.text = "Fecha: " + Qt.formatDate(wrapper.managerNuevoEvento.fechaSeleccionada,"dd/MM/yyyy").toString()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTrId("Agenda")

        onAccepted: {
            close()
        }
    }

    TituloF1 {
        id: titulo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        strTitulo: "Nuevo Evento"
    }

    Rectangle {
        id: recTxtFecha
        anchors.top: titulo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        height: 0
        color: "transparent"

        Text {
            id: txtFecha
            anchors.centerIn: parent
            font.family: "Verdana"
            font.pixelSize: 12
            visible: false
        }
    }

    Rectangle {
        id: recTxtDescripcion
        anchors.top: recTxtFecha.bottom
        anchors.bottom: btnGuardarEvento.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        border.color: "grey"
        color: "#eaeaea"

        TextArea {
            id: txtDescripcion
            anchors.fill: parent
            anchors.margins: 5
            font.family: "Verdana"
            font.pixelSize: 12
        }
    }

    Button {
        id: btnGuardarEvento
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 3
        height: 30
        enabled: txtDescripcion.text !== ""
        text: qsTrId("Agendar")

        onClicked: {
            if (wrapper.managerNuevoEvento.guardarNuevoEvento(txtDescripcion.text))
                txtDescripcion.text = ""
            else {
                messageDialog.text = qsTrId("Ups! Algo no fue bien.")
                messageDialog.open()
            }
        }
    }
}
