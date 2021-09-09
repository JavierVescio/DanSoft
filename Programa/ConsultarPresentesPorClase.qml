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
    property int idClaseAsistencia : 0
    property string strSinInformacion: qsTrId("\tSin información disponible.")
    property variant listAlumnos: null
    property variant listAlumnosInfantiles: null

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        ignoreUnknownSignals: true

        onSig_listaClaseAsistencias: {
            tablaPresentes.model = arg
            listAlumnos = arg2
        }

        onSig_noHayAsistenciasDelAlumno: {
            noHayAsistencias()
        }

        onSig_listaClaseAsistenciasInfantil: {
            tablaPresentesInfantiles.model = arg
            listAlumnosInfantiles = arg2
        }

        onSig_noHayAsistenciasDelAlumnoInfantil: {
            noHayAsistenciasInfantiles()
        }
    }

    function noHayAsistencias() {
        tablaPresentes.model = 0
        listAlumnos = null
        detallesDelCliente.aliasRecordClienteSeleccionado = null
    }

    function noHayAsistenciasInfantiles() {
        tablaPresentesInfantiles.model = 0
        listAlumnosInfantiles = null
        detallesDelCliente.aliasRecordClienteSeleccionado = null
    }

    function obtenerPresentes() {
        txtFechaInicial.date = wrapper.classManagementManager.obtenerFecha(fechaInicial)
        txtFechaFinal.date = wrapper.classManagementManager.obtenerFecha(fechaFinal)
        rangoDias = wrapper.classManagementManager.obtenerDiferenciaDias(txtFechaInicial.date,txtFechaFinal.date) + 1
        if (rangoDias > 0 && idClaseAsistencia > 0) {
            //Q_INVOKABLE int obtenerAsistenciasEntreFechasPorClase(int id_clase, QDate fecha_inicial, QDate fecha_final = QDate::currentDate());
            if (!wrapper.managerAsistencias.obtenerAsistenciasEntreFechasPorClase(idClaseAsistencia, txtFechaInicial.date, txtFechaFinal.date)) {
                //Mostrar mensajito
            }

            if (!wrapper.managerAsistencias.obtenerAsistenciasInfantilesEntreFechasPorClase(idClaseAsistencia, txtFechaInicial.date, txtFechaFinal.date)) {
                //Mostrar mensajito
            }
        }
        else {
            noHayAsistencias()
            noHayAsistenciasInfantiles()
        }
    }

    function deshacerFecha() {
        txtFechaInicial.text = txtFechaInicial.lastDate
        txtFechaFinal.text = txtFechaFinal.lastDate
    }

    SelectorClaseDeDanza {
        id: selectorDeDanza
        z: 10
        visible: false

        onClaseAsistencia: {
            lblAsistiendoClase.text = "\t" + nombreClase
            idClaseAsistencia = idClase
            obtenerPresentes()
        }

        onClaseNoSeleccionada: {
            lblAsistiendoClase.text = strSinInformacion
            idClaseAsistencia = -1
            noHayAsistencias()
        }
    }

    Column {
        id: columnaDatos
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.margins: 5
        spacing: 10
        opacity: 1
        enabled: true
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        Row {
            id: rowClase

            Button {
                text: qsTrId("Seleccionar clase")

                onClicked: {
                    selectorDeDanza.visible = true
                }
            }

            Text {
                id: lblAsistiendoClase
                y: 5
                font.family: "verdana"
                font.pixelSize: 12
                text: strSinInformacion
            }
        }

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
            z: 1

            Row {
                anchors{   fill: parent;       leftMargin: 5   }
                spacing: 5

                Text {
                    id: lblDesde
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
                    property var date
                    property bool completed : false

                    onTextChanged:  {
                        if (completed) {
                            fechaInicial = text
                            obtenerPresentes()
                        }
                    }

                    Component.onCompleted: {
                        completed = true
                        txtFechaInicial.text = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dd/MM/yyyy")
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
                    id: lblHasta
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
                    property var date
                    property bool completed : false

                    onTextChanged:  {
                        if (completed) {
                            fechaFinal = text
                            obtenerPresentes()
                        }
                    }

                    Component.onCompleted: {
                        completed = true
                        txtFechaFinal.text = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dd/MM/yyyy")
                    }
                }

                Button {
                    id: btnCalendarFinal
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
        anchors.margins: 3
        anchors.rightMargin: -1
        anchors.leftMargin: -1
        anchors.bottomMargin: -1
        orientation: Qt.Vertical

        TableView {
            id: tablaPresentesInfantiles
            height: parent.height / 2

            function obtenerAlumno() {
                if (currentRow === -1)
                    return;
                detallesDelCliente.aliasRecordClienteSeleccionado = listAlumnosInfantiles[currentRow]
            }

            onClicked: {
                obtenerAlumno()
            }

            onCurrentRowChanged: {
                obtenerAlumno()
            }


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
                role: "nombre_cliente"
                title: "Alumno/a"
                delegate: Item {
                    Text {
                        x: 1
                        color: styleData.selected && tablaPresentesInfantiles.focus ? "white" : "black"
                        text: styleData.value
                    }
                }
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

            function obtenerAlumno() {
                if (currentRow === -1)
                    return;
                detallesDelCliente.aliasRecordClienteSeleccionado = listAlumnos[currentRow] //wrapper.classManagementGestionDeAlumnos.obtenerAlumnoPorId(model[currentRow].id_cliente)
                //wrapper.classManagementGestionDeAlumnos.obtenerFoto(model[currentRow].id_cliente)
                //var recordClienteSeleccionado = detallesDelCliente.aliasRecordClienteSeleccionado
            }

            onClicked: {
                obtenerAlumno()
            }

            onCurrentRowChanged: {
                obtenerAlumno()
            }

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
                role: "nombre_cliente"
                title: "Alumno/a"
                delegate: Item {
                    Text {
                        x: 1
                        color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        text: styleData.value

                    }
                }
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

        onSig_hoveredFecha: {
            quieroLaFechaInicial ? txtFechaInicial.text = Qt.formatDate(date, "dd/MM/yyyy") : txtFechaFinal.text = Qt.formatDate(date, "dd/MM/yyyy")
        }

        onSig_clickedFecha: {
            if (rangoDias > 0)
                aliasCalendarVisible = false
        }
    }
}

