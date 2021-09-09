import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.1

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    property variant p_objPestania

    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    ActualizarCliente {
        id: actualizarCliente
        anchors.fill: parent
        z: 1
        //aliasImgFotoClienteSource: detallesDelCliente.aliasSourceImage
        enabled: false
    }

    BuscadorDeEstudiante {
        id: buscador
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: detallesDelCliente.left
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -1
        poderDarDeAlta: true
        changeSizeAllowed: false
        enabled: !actualizarCliente.enabled
        escucharSignals: principal.enabled /*29-5-15: Si desde dos o más pestanias se esta utlizando el buscador,
        la que no se esté visualizando dejará de escuchar los signals en relación a los resultados de busqueda
        de los clientes con solo setear escucharSignals en false*/

        onRecordClienteSeleccionadoChanged: {
            if (recordClienteSeleccionado !== null) {
                if (recordClienteSeleccionado.estado === "Habilitado") {
                    btnBaja.visible = true
                    btnModificar.visible = true
                    btnReactivar.visible = false
                }
                else {
                    btnReactivar.visible = true
                    btnModificar.visible = false
                    btnBaja.visible = false
                }
            }
            else {
                btnReactivar.visible = false
                btnModificar.visible = false
                btnBaja.visible = false
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Gestión de alumnos"
    }

    MessageDialog {
        id: messageBajaCliente
        icon: StandardIcon.Question
        title: qsTrId("Baja de alumno")
        text: qsTrId("Inhabilitará al alumno y dejará de existir para nosotros como alumno activo.\nMás tarde podrá reactivarlo si así lo deseara. ¿Está seguro que desea continuar?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.classManagementGestionDeAlumnos.eliminarAlumno(buscador.recordClienteSeleccionado.id)
            refrescar()
        }
    }

    function refrescar() {
        btnReactivar.visible = false
        btnModificar.visible = false
        btnBaja.visible = false
        buscador.recordClienteSeleccionado = null
        wrapper.classManagementGestionDeAlumnos.realizarUltimaBusquedaDeAlumno(true)
        buscador.buscarEstudiante()
    }

    MessageDialog {
        id: messageReactivarCliente
        icon: StandardIcon.Question
        title: qsTrId("Reactivar alumno")
        text: qsTrId("Habilitará nuevamente al alumno y se podrá volver a interactuar con él desde los distintos módulos.\n¿Está seguro que desea continuar?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.classManagementGestionDeAlumnos.reactivarCliente(buscador.recordClienteSeleccionado.id)
            refrescar()
        }
    }

    MessageDialog {
        id: messageEliminacionFisicaCliente
        icon: StandardIcon.Warning
        title: qsTrId("Eliminación física de alumno")
        text: qsTrId("El alumno ahora se encuentra inhabilitado (dado de baja), aunque tiene la posibilidad de reactivarlo si así lo deseara. Si procede con la eliminación física, no quedarán rastros de la existencia de dicho cliente.\n
Es importante que entienda que todos los eventos y estadísticas, etc asociados a aquel se perderán para siempre.")

        onAccepted: {
            messageEliminacionFisicaClienteConfirmacion.open()
        }
    }

    MessageDialog {
        id: messageEliminacionFisicaClienteConfirmacion
        icon: StandardIcon.Question
        title: qsTrId("Eliminación física de alumno")
        text: qsTrId("¿Realmente está seguro que desea eliminar físicamente al alumno y todos sus registros asociados en el sistema?\n¡La acción no se podrá deshacer!")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (wrapper.classManagementGestionDeAlumnos.eliminacionFisica(buscador.recordClienteSeleccionado.id)) {
                messageDialog.text = "Baja física realizada con éxito"
                messageDialog.icon = StandardIcon.Information
                messageDialog.open()
            }
            else {
                messageDialog.text = "¡Ha ocurrido un error!"
                messageDialog.icon = StandardIcon.Critical
                messageDialog.open()
            }

            refrescar()
        }
    }

    DetallesDelCliente {
        id: detallesDelCliente
        anchors.top: parent.top
        //anchors.topMargin: 3
        anchors.right: parent.right
        anchors.bottom: rowOpciones.top
        //anchors.rightMargin: 3
        anchors.topMargin: -1
        width: 250
        aliasRecordClienteSeleccionado: buscador.recordClienteSeleccionado
    }

    Rectangle {
        id: rowOpciones
        anchors.bottom: parent.bottom
        anchors.left: detallesDelCliente.left
        anchors.leftMargin: -1
        anchors.right: parent.right
        height: 30
        color: "white"

        Row {
            anchors.centerIn: parent
            spacing: 3

            Button {
                id: btnModificar
                text: qsTrId("Modificar")
                width: 115

                onClicked: {
                    actualizarCliente.opacity = 1
                    actualizarCliente.enabled = true
                    actualizarCliente.aliasImgFotoClienteSource = detallesDelCliente.aliasSourceImage
                    actualizarCliente.realizarCarga()
                }
            }

            Button {
                id: btnBaja
                text: qsTrId("Dar de baja")
                width: 115

                onClicked: messageBajaCliente.open()
            }

            Button {
                id: btnReactivar
                text: qsTrId("Reactivar")
                width: 115

                onClicked: messageReactivarCliente.open()
            }

            Button {
                id: btnEliminacionFisica
                text: qsTrId("Eliminación física")
                visible: false//btnReactivar.visible
                width: 115

                onClicked: messageEliminacionFisicaCliente.open()
            }
        }
    }
}
