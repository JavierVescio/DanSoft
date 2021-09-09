import QtQuick 2.0
import QtQuick.Controls 1.4
import com.mednet.WrapperClassManagement 1.0

Item {
    id: item
    anchors.fill: parent
    signal claseNoSeleccionada()
    signal claseAsistencia(var nombreClase, var idClase)
    signal actividadAsistencia(var nombreActividad, var idActividad)
    property bool verSoloActividad: false

    property bool escuchandoSignal: false

    property string filtroCategoria: "KidsAdults"

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.2

        MouseArea {
            anchors.fill: parent

            onClicked: {
                claseNoSeleccionada()
                cleanAndExit()
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            pedirTodasLasDanzas()
        }
    }

    function cleanAndExit() {
        tablaClase.model = 0
        tablaDanza.model = 0
        item.visible = false
    }

    function pedirTodasLasDanzas() {
        tablaDanza.model = 0
        tablaClase.model = 0

        if (radioConFiltro.checked){
            escuchandoSignal = true
            wrapper.managerDanza.obtenerTodasLasDanzasConFiltro(filtroCategoria)
        }
        else if (radioSinFiltro.checked){
            escuchandoSignal = true
            wrapper.managerDanza.obtenerTodasLasDanzas()
        }
    }

    Rectangle {
        id: recContenido
        anchors.centerIn: parent
        width: 400
        height: 240
        border.color: "grey"
        border.width: 2
        color: "white"
        radius: 2
        z: 5

        WrapperClassManagement {
            id: wrapper
        }

        Connections {
            target: wrapper.managerDanza

            onSig_listaDanzas: {
                if (escuchandoSignal){
                    tablaDanza.model = arg
                    tablaDanza.currentRow = -1
                    tablaClase.model = 0
                    escuchandoSignal = false
                }
            }
        }

        Connections {
            target: wrapper.managerClase

            onSig_listaClases: {
                if (escuchandoSignal) {
                    tablaClase.model = arg
                    tablaClase.currentRow = -1
                    escuchandoSignal = false
                }
            }
        }

        Column {
            spacing: 2

            Row {
                spacing: -1

                TableView {
                    id: tablaDanza
                    width: verSoloActividad ? recContenido.width : (recContenido.width / 2)
                    height: 196

                    TableViewColumn {
                        role: "nombre"
                        title: "ACTIVIDADES"
                    }

                    onClicked: {
                        if (currentRow !== -1) {
                            if (verSoloActividad) {
                                actividadAsistencia(tablaDanza.model[tablaDanza.currentRow].nombre, tablaDanza.model[tablaDanza.currentRow].id)
                                cleanAndExit()
                                //item.visible = false
                            }
                            else {
                                tablaClase.model = 0
                                if (radioConFiltro.checked){
                                    escuchandoSignal = true
                                    wrapper.managerClase.obtenerTodasLasClasesPorIdDanzaConFiltro(model[currentRow].id, filtroCategoria)
                                }
                                else if (radioSinFiltro.checked){
                                    escuchandoSignal = true
                                    wrapper.managerClase.obtenerTodasLasClasesPorIdDanza(model[currentRow].id)
                                }
                            }
                        }
                    }
                }

                TableView {
                    id: tablaClase
                    width: (recContenido.width / 2) + 1
                    height: 196
                    visible: !verSoloActividad

                    TableViewColumn {
                        role: "nombre"
                        title: "CLASES DE LA ACTIVIDAD"
                    }

                    onClicked: {
                        claseAsistencia(tablaDanza.model[tablaDanza.currentRow].nombre + ", " + tablaClase.model[tablaClase.currentRow].nombre, tablaClase.model[tablaClase.currentRow].id)
                        cleanAndExit()
                    }
                }
            }

            RadioButton {
                id: radioConFiltro
                x: 5
                text: {
                    if (filtroCategoria === "Adults"){
                        "Ver sólo las clases que se dan hoy para adultos"
                    }else if (filtroCategoria === "Kids"){
                        "Ver sólo las clases que se dan hoy para niños"
                    }else if (filtroCategoria === "KidsAdults"){
                        "Ver sólo las clases que se dan hoy para niños o adultos"
                    }else{
                        "Ver sólo las clases que se dan hoy"
                    }
                }
                exclusiveGroup: groupFiltrado
                checked: true

                onCheckedChanged: {
                    if (item.visible){
                        if (checked) {
                            radioSinFiltro.checked = false
                            pedirTodasLasDanzas()
                        }
                    }
                }
            }

            RadioButton {
                id: radioSinFiltro
                x: 5
                text: "Ver todo"
                exclusiveGroup: groupFiltrado

                onCheckedChanged: {
                    if (item.visible){
                        if (checked) {
                            radioConFiltro.checked = false
                            pedirTodasLasDanzas()
                        }
                    }
                }
            }
        }
    }

    ExclusiveGroup{
        id: groupFiltrado
    }
}
