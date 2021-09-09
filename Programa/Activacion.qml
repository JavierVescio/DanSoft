import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    property bool activacion
    property int mes

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        listaMeses.model = wrapper.managerActiviationSerial.getListaActivationSerial()
    }

    Text {
        id: lblTitle
        anchors.left: parent.left
        anchors.top: parent.top
        text: qsTrId("ACTIVACIÓN DEL SISTEMA")
        font.pixelSize: 30
        font.family: "Verdana"
        color: "#2E9AFE"
        focus: false
    }

    Rectangle {
        id: recSubtitulo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: lblTitle.bottom
        height: 30
        color: "#2E9AFE"
        focus: false

        Text {
            anchors.fill: parent
            anchors.margins: 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: "white"
            font.family: "Verdana"
            font.pixelSize: 14
            text: "CONSULTA DE ESTADO E INGRESO DE LLAVES DE ACTIVACIÓN"
        }
    }

    Text {
        id: lblInfoMesActual
        anchors.top: recSubtitulo.bottom
        anchors.topMargin: 3
        x: 3
        font.family: "Verdana"
        font.pixelSize: 12
        text: "Fecha registrada en sistema: " + Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dddd dd/MM/yyyy")
    }

    ListView {
        id: listaMeses
        anchors.top: lblInfoMesActual.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        spacing: 3
        clip: true
        delegate: ActivationMonthComponent {
            width: parent.width
            strMonth: {
                if (index == 0)
                    Qt.formatDate(listaMeses.model[index].valid_date_from,"MMMM - yyyy")
                else if(index == listaMeses.count-1)
                    Qt.formatDate(listaMeses.model[index].valid_date_from,"MMMM - yyyy")
                else
                    Qt.formatDate(listaMeses.model[index].valid_date_from,"MMMM")
            }
            obj: listaMeses.model[index]


        }
    }


    /*MessageDialog {
        id: messageActivation
        icon: StandardIcon.Information
        title: qsTrId("Information about your product")
    }

    Column {
        Button {
            onClicked: {
                mes = 3
                activacion = wrapper.managerActiviationSerial.verificarActivacion(mes)
                messageActivation.text = "Activation status for month " + mes + ": "  + activacion
                messageActivation.open()
            }
        }
    }*/


}
