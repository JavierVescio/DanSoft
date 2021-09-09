import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item {
    id: principal
    anchors.fill: parent
    property int idClase: -1


    onVisibleChanged: {
        if (visible){
            buscador.buscarEstudiante()
        }

    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.2
        z:1

        MouseArea {
            anchors.fill: parent

            onClicked: {
                principal.visible = false
                listViewInscripciones.model = 0
                recargar()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 30
        z:2

        MouseArea {
            anchors.fill: parent
        }

        BuscadorDeEstudiante {
            id: buscador
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: detallesDelCliente.left
            anchors.rightMargin: -1
            anchors.leftMargin: -2
            height: 250
            escucharSignals: principal.enabled
            idClase: principal.idClase
            dadosDeBaja: false
            changeSizeAllowed: false

            onRecordClienteSeleccionadoChanged:  {
                switchInscripcion.actualizandoInfo = true

                listViewInscripciones.model = 0
                listViewInscripciones.model = wrapper.managerAsistencias.traerInscripcionesDelAlumno(recordClienteSeleccionado.id)

                if (recordClienteSeleccionado.inscripto_a_clase){
                    switchInscripcion.checked = true
                }
                else {
                    switchInscripcion.checked = false
                }
                switchInscripcion.actualizandoInfo = false
            }
        }

        TituloF1 {
            id: titulo
            anchors.top: buscador.bottom
            anchors.topMargin: -1
            anchors.left: parent.left
            anchors.leftMargin: -2
            anchors.rightMargin: -1
            anchors.right: detallesDelCliente.left
            height: 30
            strTitulo: lblAsistiendoClase.text
        }

        Row {
            id: rowInscripcion
            anchors.top: titulo.bottom
            anchors.topMargin: 15
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: detallesDelCliente.left
            spacing: 10

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                text: "Inscripto a " + lblAsistiendoClase.text + ":"
            }

            Switch {
                id: switchInscripcion
                checked: false
                property bool actualizandoInfo: false

                onCheckedChanged: {
                    if (!actualizandoInfo){
                        //Es el usuario que cambio algo
                        wrapper.managerAsistencias.inscribirDesinscribirClienteClase(buscador.recordClienteSeleccionado.id,idClase,checked)
                        buscador.recordClienteSeleccionado.inscripto_a_clase = checked //No hace falta refrescar el modelo con esto.
                        listViewInscripciones.model = 0
                        listViewInscripciones.model = wrapper.managerAsistencias.traerInscripcionesDelAlumno(buscador.recordClienteSeleccionado.id)
                    }
                }
            }
        }

        Rectangle {
            id: lblTotalInscripciones
            anchors.top: rowInscripcion.bottom
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            height: 29
            color: backColorSubtitles

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 3
                font.family: "verdana";
                font.pixelSize: 14
                text: "Total de inscripciones del alumno: " + listViewInscripciones.count
            }
        }

        ListView {
            id: listViewInscripciones
            anchors.top: lblTotalInscripciones.bottom
            anchors.topMargin: 10
            anchors.bottom: btnVolver.top
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: detallesDelCliente.left
            clip: true
            spacing: 10

            delegate: Text {
                font.family: "verdana";
                font.italic: true
                font.pixelSize: 12
                color: listViewInscripciones.model[index].id_danza_clase === idClase ? "blue" : "black"
                text: (index+1) + ". " + listViewInscripciones.model[index].nombre_actividad + ", " + listViewInscripciones.model[index].nombre_clase
            }
        }



        Button {
            id: btnVolver
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -1
            anchors.left: parent.left
            anchors.leftMargin: -1
            height: 30
            text: "Volver a la tabla"
            iconSource: "qrc:/media/Media/tablas.png"

            onClicked: {
                principal.visible = false
                listViewInscripciones.model = 0
                recargar()
            }
        }


        DetallesDelCliente {
            id: detallesDelCliente
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: -1
            //anchors.margins: 3
            width: 250
            aliasRecordClienteSeleccionado: buscador.recordClienteSeleccionado

        }
    }
}
