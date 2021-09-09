import QtQuick 2.0
import QtQuick.Controls 1.2
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    property variant p_objPestania

    Behavior on opacity {PropertyAnimation{}}

    /*DiaSeleccionado{
        id: diaSeleccionado
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 3
    }*/


    CalendarioAgenda {
        id: calendarioAgenda
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 3
    }

    NuevoEventoIndividual {
        id: nuevoEvento
        anchors.top: calendarioAgenda.bottom
        anchors.left: parent.left
        anchors.right: listaDeEventos.left
        anchors.bottom: parent.bottom
        anchors.margins: 3
    }

    Rectangle {
        id: recOcultar
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: 1
        enabled: false

        MouseArea {
            anchors.fill: parent

            onClicked: {
                buscadorCliente.opacity = 0
                buscadorCliente.enabled = false
                recOcultar.opacity = 0
                recOcultar.enabled = false
            }
        }
    }

    BuscadorDeEstudiante {
        id: buscadorCliente
        anchors.margins: 150
        anchors.fill: parent
        opacity: 0
        enabled: false
        border.color: "grey"
        border.width: 2
        radius: 5
        z: 2
        dadosDeBaja: false
        escucharSignals: principal.enabled

        Behavior on opacity {PropertyAnimation{}}

        onRecordClienteSeleccionadoChanged: {
            opacity = 0
            enabled = false
            recOcultar.opacity = 0
            recOcultar.enabled = false
        }
    }

    InformacionDelDia{ //29-5-15: NO SE UTILIZA POR AHORA ESTE COMPONENTE
        id: nuevoEventoIndividual
        anchors.top:  parent.top
        anchors.left: calendarioAgenda.right
        anchors.right: parent.right
        anchors.margins: 3
        visible: false
    }

    ListaDeEventos {
        id: listaDeEventos
        anchors.top:  parent.top
        anchors.left: calendarioAgenda.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 3
    }
}
