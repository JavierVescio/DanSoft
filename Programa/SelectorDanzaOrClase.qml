import QtQuick 2.0
import QtQuick.Controls 1.4
import com.mednet.WrapperClassManagement 1.0

Row {
    signal danzaSeleccionada(var idDanza)
    signal claseSeleccionada(var nombreClase, var idClase)

    Component.onCompleted: pedirTodasLasDanzas()

    WrapperClassManagement {
        id: wrapper
    }

    function pedirTodasLasDanzas() {
        wrapper.managerDanza.obtenerTodasLasDanzas()
        tablaClase.model = 0
    }


    Connections {
        target: wrapper.managerDanza

        onSig_listaDanzas: {
            tablaDanza.model = arg
            tablaDanza.currentRow = -1
            tablaClase.model = 0
        }
    }

    Connections {
        target: wrapper.managerClase

        onSig_listaClases: {
            tablaClase.model = arg
            tablaClase.currentRow = -1
        }
    }

    TableView {
        id: tablaDanza
        width: parent.width / 2
        height: 200

        TableViewColumn {
            role: "nombre"
            title: "ACTIVIDADES"
        }

        onCurrentRowChanged: {
            if (currentRow !== -1) {
                wrapper.managerClase.obtenerTodasLasClasesPorIdDanza(model[currentRow].id)
                danzaSeleccionada(model[currentRow].id)
            }
        }
    }

    TableView {
        id: tablaClase
        width: parent.width / 2
        height: 200

        TableViewColumn {
            role: "nombre"
            title: "CLASES DE LA ACTIVIDAD"
        }

        onCurrentRowChanged: {
            if (currentRow !== -1) {
                claseSeleccionada(tablaDanza.model[tablaDanza.currentRow].nombre + ", " + tablaClase.model[tablaClase.currentRow].nombre, tablaClase.model[tablaClase.currentRow].id)
            }
        }
    }
}

