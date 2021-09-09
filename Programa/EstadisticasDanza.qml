import QtQuick.Controls 1.4
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0
    enabled: false
    property variant p_objPestania

    Behavior on opacity {PropertyAnimation{}}

    property int totalAsistencias : 0
    property int porcentajeAsistencias : 0
    property int totalMujeres : 0
    property int totalHombres : 0
    property int porcentajeMujeres : 0
    property int porcentajeHombres : 0
    property string alumnoMasAsistencia : "Sin información disponible"
    property string danzaClaseSeleccionada : "-"

    property int id_clase
    property var fecha_inicial : wrapper.classManagementManager.obtenerFecha()
    property var fecha_final : wrapper.classManagementManager.obtenerFecha()

    property var listaTotalAsistencias : 0

    function obtenerInformacion() {
        limpiarInformacion()
        totalAsistencias = wrapper.managerAsistencias.obtenerAsistenciasEntreFechasPorClase(id_clase,fecha_inicial,fecha_final)
        if (totalAsistencias === 0) {
            porcentajeAsistencias = 0
        }
        else {
            var totalAsistenciasEntreFechas = wrapper.managerAsistencias.obtenerAsistenciasEntreFechas(fecha_inicial,fecha_final)
            if (totalAsistenciasEntreFechas === 0) {
                porcentajeAsistencias = 0
            }
            else {
                porcentajeAsistencias = 100 * totalAsistencias / totalAsistenciasEntreFechas
            }
        }
        totalMujeres = wrapper.managerAsistencias.obtenerAsistenciasPorClaseGeneroEntreFechas(id_clase,"Femenino",fecha_inicial,fecha_final)
        totalHombres = wrapper.managerAsistencias.obtenerAsistenciasPorClaseGeneroEntreFechas(id_clase,"Masculino",fecha_inicial,fecha_final)
        var totalHombresMujeres = totalMujeres + totalHombres
        if (totalHombresMujeres === 0)
            porcentajeMujeres = 0
        else
            porcentajeMujeres = 100 * totalMujeres / totalHombresMujeres

        if (totalHombresMujeres === 0)
            porcentajeHombres = 0
        else
            porcentajeHombres = 100 * totalHombres / totalHombresMujeres

        wrapper.managerAsistencias.obtenerAlumnosMasAsistidoresEntreFechasPorClase(id_clase,fecha_inicial,fecha_final)
    }

    function limpiarInformacion() {
        totalAsistencias = 0
        porcentajeAsistencias = 0
        totalMujeres = 0
        totalHombres = 0
        porcentajeMujeres = 0
        porcentajeHombres = 0
        listaTotalAsistencias = 0
        listaAlumnos.model = 0
        alumnoMasAsistencia = "Sin información disponible"
    }

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: wrapper.managerAsistencias

        //void sig_listaAlumnosMasAsistidores(QList<int> listaAsistencias, QList<QObject*> listaAlumnos);

        onSig_listaAlumnosMasAsistidores: {
            console.debug("")
            console.debug("onSig_listaAlumnosMasAsistidores")
            console.debug("listaAlumnos length: " + listaAlumnosArg.length)
            listaTotalAsistencias = listaAsistencias
            listaAlumnos.model = listaAlumnosArg
        }
    }

    Rectangle {
        id: recPanelConfiguracion
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        width: 300

        TituloF1 {
            id: titleClase
            anchors.top: parent.top
            anchors.left: parent.left
            strTitulo: qsTrId("Seleccione una clase")
            width: parent.width
        }

        Rectangle {
            id: recDanzaClase
            anchors.top: titleClase.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 200

            SelectorDanzaOrClase {
                anchors.fill: parent

                onDanzaSeleccionada: {
                    danzaClaseSeleccionada = "-"
                    limpiarInformacion()
                }

                onClaseSeleccionada: {
                    id_clase = idClase
                    obtenerInformacion()
                    danzaClaseSeleccionada = nombreClase
                }
            }
        }

        TituloF1 {
            id: titleFecha
            anchors.top: recDanzaClase.bottom
            anchors.left: parent.left
            strTitulo: qsTrId("Seleccione un período de tiempo")
            width: parent.width
        }

        Rectangle {
            id: recFechas
            anchors.top: titleFecha.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            ExclusiveGroup {
                id: group
            }

            Column {
                anchors.fill: parent
                anchors.margins: 3

                RadioButton {
                    text: qsTrId("Hoy")
                    checked: true
                    exclusiveGroup: group

                    onCheckedChanged: {
                        if (checked) {
                            fecha_inicial = wrapper.classManagementManager.obtenerFecha()
                            obtenerInformacion()
                        }
                    }
                }

                RadioButton {
                    text: qsTrId("Última semana")
                    checked: false
                    exclusiveGroup: group

                    onCheckedChanged: {
                        if (checked) {
                            fecha_inicial = wrapper.classManagementManager.nuevaFecha(wrapper.classManagementManager.obtenerFecha(),-7)
                            obtenerInformacion()
                        }
                    }
                }

                RadioButton {
                    text: qsTrId("Últimos 30 días")
                    checked: false
                    exclusiveGroup: group

                    onCheckedChanged: {
                        if (checked) {
                            fecha_inicial = wrapper.classManagementManager.nuevaFecha(wrapper.classManagementManager.obtenerFecha(),-30)
                            obtenerInformacion()
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: separador
        anchors.top: parent.top
        anchors.left: recPanelConfiguracion.right
        anchors.leftMargin: 3
        anchors.bottom: parent.bottom
        width: 3
        color: "#006d7e"
    }

    Rectangle {
        id: recEstadisticas
        anchors.left: separador.right
        anchors.leftMargin: 3
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        TituloF1 {
            id: titleInformacion
            anchors.top: parent.top
            anchors.left: parent.left
            strTitulo: "Información de la clase: " + danzaClaseSeleccionada
            width: parent.width
        }

        Column {
            anchors.fill: parent
            anchors.topMargin: titleInformacion.height + 3
            spacing: 5

            /*font.family: "Verdana"
            font.pixelSize: 14*/
            property string strFamily : "Verdana"
            property int intPixelSize : 14

            Text {
                text: "Total asistencias registradas: " + totalAsistencias
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Porcentaje de asistencias: ~" + porcentajeAsistencias + "%"
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Total mujeres: " + totalMujeres
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Total hombres: " + totalHombres
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Porcentaje mujeres: ~" + porcentajeMujeres + "%"
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Porcentaje hombres: ~" + porcentajeHombres + "%"
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            Text {
                text: "Los 5 (cinco) alumnos con mejores asistencias:"
                font.family: parent.strFamily
                font.pixelSize: parent.intPixelSize
            }

            ListView {
                id: listaAlumnos
                width: parent.width
                height: 330
                delegate: Component {
                    id: contactDelegate
                    Item {
                        width: listaAlumnos.width; height: 60

                        Text {
                            font.family: "Verdana"
                            color: "#BF6363"
                            font.pixelSize: 15
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            property string strApellido
                            z: 1

                            Component.onCompleted: {
                                strApellido = listaAlumnos.model[index].apellido
                                text = strApellido.toUpperCase() + "\n" + listaAlumnos.model[index].primerNombre + " " + listaAlumnos.model[index].segundoNombre + "\nTotal asistencias: " + listaTotalAsistencias[index]
                            }
                        }

                        Rectangle{
                            id: rec
                            anchors.fill: parent
                            color: "transparent"; radius: 5
                            border.width: 1
                            border.color: "grey"
                        }
                    }
                }
                focus: true
                clip: true
                spacing: 5

            }
        }
    }
}

