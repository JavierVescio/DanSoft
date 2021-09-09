import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    //color: "#e8eaf6"
    color: "#FFCDD2"
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property string strEstadoMatriculacion: "sin matrícula"
    property bool alumnoMatriculado: false

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    WrapperClassManagement {
        id: wrapper
    }

    Component.objectName: {
        messageInfoMatriculacion.open()
    }

    MessageDialog {
        id: messageInfoMatriculacion
        icon: StandardIcon.Information
        title: "Gestionar Matriculación infantil"
        text: "Esta funcionalidad fue creada para poder matricular/inscribir a alumnos infantiles que ya habían pagado previamente el valor de la inscripción (antes de que empezara a usarse la versión actual del sistema, es decir, en versiones 6.0 o anteriores)."

    }

    Rectangle {
        anchors.fill: parent
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
            anchors.bottomMargin: 70
            escucharSignals: principal.enabled
            idClase: 0 //Tiene que ser distinto de -1 para que se puedan buscar alumnos con abono infantil
            dadosDeBaja: false
            changeSizeAllowed: false

            onRecordClienteSeleccionadoChanged:  {
                saldoMovimientos.tableViewMovimientos.model = 0
                cuenta_alumno = null
                if (recordClienteSeleccionado !== null) {
                    wrapper.gestionBaseDeDatos.beginTransaction()
                    cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                    if (cuenta_alumno !== null) {
                        wrapper.gestionBaseDeDatos.commitTransaction()

                        wrapper.gestionBaseDeDatos.beginTransaction()
                        resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                        if (resumen_mes_alumno !== null) {
                            saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id, -1)
                            saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()
                            wrapper.gestionBaseDeDatos.commitTransaction()
                        }
                    }
                    else {
                        wrapper.gestionBaseDeDatos.rollbackTransaction()
                    }

                    alumnoMatriculado = wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(recordClienteSeleccionado.id)
                    if (alumnoMatriculado){
                        strEstadoMatriculacion = "Alumno/a infantil matriculado el día " + Qt.formatDate(recordClienteSeleccionado.fecha_matriculacion_infantil,"ddd dd/MM/yyyy")
                    }else{
                        strEstadoMatriculacion = "Alumno/a sin matrícula"
                    }
                }
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
            strTitulo: strEstadoMatriculacion
        }

        SaldoMovimientos {
            id: saldoMovimientos
            anchors.top: titulo.bottom
            anchors.bottom: btnMatricular.top
            anchors.bottomMargin: -2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: -2
            anchors.rightMargin: -1
            anchors.topMargin: -1
            mostrarTextoRecientes: false
        }

        Button {
            id: btnMatricular
            enabled: !alumnoMatriculado
            text: "Matricular sin cargo al alumno/a infantil"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            anchors.rightMargin: -2
            anchors.leftMargin: -2
            anchors.bottomMargin: -2
            height: 40

            onClicked: {
                messageDialogYesNo.open()
            }
        }

        MessageDialog {
            id: messageDialogYesNo
            title: "Matricular alumno/a sin cargo"
            icon: StandardIcon.Question
            standardButtons: StandardButton.Yes | StandardButton.No
            text: buscador.recordClienteSeleccionado !== null ? "¿Matricular a " + buscador.recordClienteSeleccionado.apellido + "?" : "--"

            onYes: {
                wrapper.managerAbonoInfantil.matricularAlumno(buscador.recordClienteSeleccionado.id)
                buscador.recordClienteSeleccionado.fecha_matriculacion_infantil = wrapper.classManagementManager.obtenerFechaHora() //No hace falta refrescar el modelo con esto.
                buscador.recordClienteSeleccionado.matriculado = true
                alumnoMatriculado = true
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
