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
    color: "#F3E5F5"
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    property int cantidadDeClasesEnDeuda : 0
    property bool quieroLaFechaInicial : true
    property string fechaInicial: ""; property string fechaFinal: ""
    property int duracionDeAbono : 1
    property string strSinInformacion: qsTrId("\tSin información disponible.")
    property string strNoAbono : qsTrId("\tNo existe ningún abono vigente a la fecha del alumno/a.")

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        ignoreUnknownSignals: true

        onSig_listaClaseAsistencias: {
            tablaPresentes.model = arg
        }

        onSig_noHayAsistenciasDelAlumno: {
            tablaPresentes.model = 0
        }
    }

    Connections {
        target: principal.enabled ? wrapper.managerAbono : null
        ignoreUnknownSignals: true

        onSig_abonosDeAlumno: {
            tablaPresentes.model = 0
            selectorDeAbono.p_modelAbonos = arg
            selectorDeAbono.visible = true
        }

        onSig_noHayAbonosDelAlumno: {
            switchOnOffDatos(false)
        }
    }

   /* MessageDialog {
        id: messageError
        title: "Adultos"
        icon: StandardIcon.Critical
        text: qsTrId("Lamentablemente ha ocurrido un error al intentar mejorar el abono.\nIntente nuevamente más tarde.")
    }*/

    function limpiarFormulario() {
        lblAbonosVigentesDisponibles.text = strSinInformacion
        tablaPresentes.model = 0
    }


    function switchOnOffDatos(logico) {
        if (logico) {
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
            wrapper.managerAbono.obtenerAbonosPorClienteMasFecha(buscador.recordClienteSeleccionado.id,true,false,true)
        }
        else {
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
            selectorDeAbono.p_modelAbonos = 0
            lblAbonosVigentesDisponibles.text = strNoAbono
            selectorDeAbono.visible = false
            tablaPresentes.model = 0
        }
    }

    BuscadorDeEstudiante {
        id: buscador
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: detallesDelCliente.left
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        height: 250
        escucharSignals: principal.enabled
        dadosDeBaja: false

        onRecordClienteSeleccionadoChanged: {
            if (recordClienteSeleccionado !== null) {
                switchOnOffDatos(true)
            }
            else {
                limpiarFormulario()
                switchOnOffDatos(false)
            }
        }
    }

    Column {
        id: columnaDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.margins: 0
        spacing: 10
        opacity: 0
        enabled: false
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        Row {
            Text {
                font.family: "verdana";
                font.pixelSize: 14
                text: qsTrId("Abonos vigentes del alumno/a")
            }

            /*BuscadorDeAbono {

            }*/
        }

        Text {
            id: lblAbonosVigentesDisponibles
            font.family: "verdana"
            font.pixelSize: 12
            text: strSinInformacion
            visible: !selectorDeAbono.visible
        }

        SelectorDeAbono {
            id: selectorDeAbono
            width: columnaDatos.width
            height: 148
            visible: false
            mostrarLeyendaDeVigentes: true

            onIdAbonoSeleccionadoChanged: {
                if (idAbonoSeleccionado > 0) {
                    wrapper.managerAsistencias.obtenerClasesPorAbono(idAbonoSeleccionado)
                }
            }
        }

        Text {
            id: lblTotalRegistros
            font.family: "verdana";
            font.pixelSize: 14
            text: qsTrId("Total registros: ") + tablaPresentes.rowCount
        }
    }

    TableView {
        id: tablaPresentes
        anchors.top: columnaDatos.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: parent.bottom
        anchors.margins: 5
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        anchors.bottomMargin: -1

        TableViewColumn {
            role: "id"
            title: "Nro"
            width: 55
        }

        TableViewColumn {
            role: "nombre_actividad"
            title: "Actividad"
            delegate: Item {
                Text {
                    x: 1
                    text: styleData.value
                    color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "nombre_clase"
            title: "Clase"
            delegate: Item {
                Text {
                    x: 1
                    text: styleData.value
                    color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "credencial_firmada"
            title: "Firma"
            width: 55

            delegate: Item {
                Image {
                    x: 1
                    source: styleData.value === "No" ? "qrc:/media/Media/icono.png" : "qrc:/media/Media/icoyes.png"
                }
            }
        }

        TableViewColumn {
            role: "fecha"
            title: "Fecha"
            delegate: Item {
                Text {
                    x: 1
                    text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                    color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                }
            }
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

