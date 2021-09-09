import QtQuick.Controls 1.4
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
    property int rangoDias : 1

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

        onSig_listaClaseAsistenciasInfantil: {
            tablaPresentesInfantiles.model = arg
        }

        onSig_noHayAsistenciasDelAlumnoInfantil: {
            tablaPresentesInfantiles.model = 0
        }
    }

    function obtenerPresentes() {
        if (columnaDatos.enabled) {
            var dateInicial = wrapper.classManagementManager.obtenerFecha(fechaInicial)
            var dateFinal = wrapper.classManagementManager.obtenerFecha(fechaFinal)
            rangoDias = wrapper.classManagementManager.obtenerDiferenciaDias(dateInicial,dateFinal) + 1
            if (rangoDias > 0) {
                if (!wrapper.managerAsistencias.obtenerPresentesEntreFechas(dateInicial, dateFinal, buscador.recordClienteSeleccionado.id)) {
                    //Mostrar mensajito
                }

                if (!wrapper.managerAsistencias.obtenerPresentesInfantilesEntreFechas(dateInicial, dateFinal, buscador.recordClienteSeleccionado.id)) {

                }
            }
            else {
                tablaPresentes.model = 0
                tablaPresentesInfantiles.model = 0
            }
        }
    }

    function deshacerFecha() {
        txtFechaInicial.text = txtFechaInicial.lastDate
        txtFechaFinal.text = txtFechaFinal.lastDate
    }

    function switchOnOffDatos(logico) {
        if (logico) {
            txtFechaInicial.text = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dd/MM/yyyy")
            txtFechaFinal.text = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dd/MM/yyyy")
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
        }
        else {
            tablaPresentes.model = 0
            tablaPresentesInfantiles.model = 0
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
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
                obtenerPresentes()
            }
            else {
                switchOnOffDatos(false)
            }
        }
    }

    Column {
        id: columnaDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.margins: 5
        spacing: 10
        opacity: 0
        enabled: false
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        Row {
            spacing: 5

            Text {
                font.family: "verdana"; //color: "#0101DF";
                font.pixelSize: 14
                text: qsTrId("Período: ") + rangoDias + qsTrId(" día/s.")
            }

            Text {
                id: lblTotalRegistros
                font.family: "verdana"; //color: "#0101DF";
                font.pixelSize: 14
                text: "Arriba infantiles ("+tablaPresentesInfantiles.rowCount+"), abajo adultos ("+tablaPresentes.rowCount+"). Total: " + (tablaPresentes.rowCount + tablaPresentesInfantiles.rowCount)
            }
        }

        Rectangle { ////Fecha
            id: recFechas
            height: 40
            width: 300
            color: "transparent"
            radius: 3
            //border.color: "grey"
            z: 1

            Row {
                anchors{   fill: parent;       leftMargin: 5   }
                spacing: 5

                Text {
                    y: 8
                    font.family: "verdana"
                    font.pixelSize: 12
                    text: qsTrId("Desde")
                }

                TextField {
                    id: txtFechaInicial
                    y: 8
                    inputMask: "00/00/0000;_"
                    maximumLength: 10
                    width: 82
                    property string lastDate

                    onTextChanged:  {
                        fechaInicial = text
                        obtenerPresentes()
                    }
                }

                Button {
                    width: parent.height - 10
                    height: width
                    y: 5

                    Image {
                        anchors{    fill: parent;       margins: 3 }
                        source: "qrc:/media/Media/calendar.png"
                    }

                    onClicked: {
                        quieroLaFechaInicial = true
                        detallesDelCliente.aliasCalendarVisible = !detallesDelCliente.aliasCalendarVisible
                        if (detallesDelCliente.aliasCalendarVisible) {
                            txtFechaInicial.lastDate = txtFechaInicial.text
                            txtFechaFinal.lastDate = txtFechaFinal.text
                        }
                        else {
                            deshacerFecha()
                        }

                        detallesDelCliente.aliasCalendar.selectedDate = wrapper.classManagementManager.obtenerFecha(fechaInicial)
                    }
                }

                Text {
                    y: 8
                    font.family: "verdana"
                    font.pixelSize: 12
                    text: qsTrId("Hasta")
                }

                TextField {
                    id: txtFechaFinal
                    y: 8
                    inputMask: "00/00/0000;_"
                    maximumLength: 10
                    width: 82
                    property string lastDate

                    onTextChanged:  {
                        fechaFinal = text
                        obtenerPresentes()
                    }
                }

                Button {
                    width: parent.height - 10
                    height: width
                    y: 5

                    Image {
                        anchors{    fill: parent;       margins: 3 }
                        source: "qrc:/media/Media/calendar.png"
                    }

                    onClicked: {
                        quieroLaFechaInicial = false
                        detallesDelCliente.aliasCalendarVisible = !detallesDelCliente.aliasCalendarVisible
                        if (detallesDelCliente.aliasCalendarVisible) {
                            txtFechaFinal.lastDate = txtFechaFinal.text
                            txtFechaInicial.lastDate = txtFechaInicial.text
                        }
                        else {
                            deshacerFecha()
                        }
                        detallesDelCliente.aliasCalendar.selectedDate = wrapper.classManagementManager.obtenerFecha(fechaFinal)
                    }
                }
            }


        } //////////////Fecha
    }

    Rectangle {
        id: recOcultar
        anchors.top: parent.top
        anchors.right: detallesDelCliente.left
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "transparent"
        z: 10
        enabled: detallesDelCliente.aliasCalendarVisible

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                deshacerFecha()
            }

            onClicked: {
                deshacerFecha()
                detallesDelCliente.aliasCalendarVisible = false
            }
        }
    }

    SplitView {
        anchors.top: columnaDatos.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical
        anchors.topMargin: 2
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        anchors.bottomMargin: -1

        TableView {
            id: tablaPresentesInfantiles

            TableViewColumn {
                role: "index"
                title: ""
                width: 55

                delegate: Item {
                    Text {
                        x: 1
                        y: 1
                        text: tablaPresentesInfantiles.model.length - styleData.row
                        color: styleData.selected && tablaPresentesInfantiles.focus ? "white" : "black"
                    }
                }
            }

            TableViewColumn {
                role: "id"
                title: "Nro"
                width: 55
            }

            TableViewColumn {
                role: "nombre_actividad"
                title: "Actividad"
            }

            TableViewColumn {
                role: "nombre_clase"
                title: "Clase"
            }

            TableViewColumn {
                role: "fecha"
                title: "Fecha"

                delegate: Item {
                    Text {
                        x: 1
                        y: 1
                        //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                        text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                        color: styleData.selected && tablaPresentesInfantiles.focus ? "white" : "black"
                    }
                }
            }

            /*TableViewColumn {
                role: "estado"
                title: "Estado"
            }*/
        }

        TableView {
            id: tablaPresentes

            /*anchors.top: columnaDatos.bottom
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            height: (principal.height - tablaPresentes.y) / 2
            anchors.topMargin: 3
            anchors.rightMargin: -1
            anchors.leftMargin: -1*/

            TableViewColumn {
                role: "index"
                title: ""
                width: 55

                delegate: Item {
                    Text {
                        x: 1
                        y: 1
                        text: tablaPresentes.model.length - styleData.row
                        color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                    }
                }
            }

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
                role: "clase_debitada"
                title: "Cubierta por abono"
                width: 100
                visible: false

                delegate: Item {
                    Image {
                        x: (parent.width / 2) - (width/2)
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
                        y: 1
                        //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                        text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                        color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                    }
                }
            }

            /*TableViewColumn {
                role: "estado"
                title: "Estado"
            }*/
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

        onSig_hoveredFecha: {
            quieroLaFechaInicial ? txtFechaInicial.text = Qt.formatDate(date, "dd/MM/yyyy") : txtFechaFinal.text = Qt.formatDate(date, "dd/MM/yyyy")
        }

        onSig_clickedFecha: {
            if (rangoDias > 0)
                aliasCalendarVisible = false
        }
    }
}
