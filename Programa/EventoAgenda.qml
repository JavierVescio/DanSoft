import QtQuick 2.0
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: principal
    property string strAlumnoSeleccionado : "-NN-"
    property color p_colorInicial : "white"
    property color p_colorFinal : "#FFE9E9"
    property color p_colorBorder : "lightgrey"
    property date fechaSeleccionada
    border.color: p_colorBorder

    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: p_colorInicial
        }
        GradientStop {
            position: 1.00;
            color: p_colorFinal
        }
    }

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: wrapper.classManagementGestionDeAlumnos

        onSig_recordAlumnoSeleccionado: {
            strAlumnoSeleccionado = recordAlumnoSeleccionado.apellido + ", "
                    + recordAlumnoSeleccionado.nombre + " (" + recordAlumnoSeleccionado.dni + ")";
        }
    }

    Connections {
        target: wrapper.managerNuevoEvento

        onSig_eventosActualizados: {
            listViewFechas.model = arg
        }
    }

    Grid {
        id: grid
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25
        anchors.margins: 3
        rows: 2
        columns: 2

        RecConFormato {
            id: tituloAlumno
            width: 250
            height: 25
            p_strTexto: qsTrId("Cliente")
        }

        RecConFormato {
            id: txtAlumnoSeleccionado
            width: parent.width - tituloAlumno.width
            height: 25
            p_strTexto: strAlumnoSeleccionado
            color: "white"
        }
    }

    ListView{
        id: listViewFechas
        anchors.right: parent.right
        anchors.rightMargin: 3
        anchors.top: grid.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        width: txtAlumnoSeleccionado.width
        clip: true
        spacing: 3
        delegate: EventoIndividual {
            height: 25
            width: listViewFechas.width;
            p_index: index
            p_fechaSeleccionada: listViewFechas.model[index].fecha
            p_hora: listViewFechas.model[index].hora
            p_minuto: listViewFechas.model[index].minuto
            p_record: listViewFechas.model[index]
            color: index === 0 ? "#CEECF5" : "#F5FBF7"
        }
    }

    Calendar {
        id: calendarioNuevoEvento
        anchors.top: grid.bottom
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        width: tituloAlumno.width

        onDoubleClicked: {
            fechaSeleccionada = date
            wrapper.managerNuevoEvento.agregarNuevoEvento(fechaSeleccionada,0,0)
        }
    }
}
