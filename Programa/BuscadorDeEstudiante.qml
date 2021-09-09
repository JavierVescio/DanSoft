import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import com.mednet.WrapperClassManagement 1.0

Rectangle {
    id: buscadorCliente
    //modality: Qt.WindowModal
    //flags: Qt.Window
    //    title: qsTr("Buscar cliente")
    //    maximumHeight: height
    //    minimumHeight: height
    //    maximumWidth: width
    //    minimumWidth: width
    property variant recordClienteSeleccionado : null
    property bool dadosDeBaja : true
    property bool poderDarDeAlta : false
    property bool escucharSignals : false
    property bool laBusquedaFueRealizadaPorDNI : false
    property alias modeloAlumnos : tablaAlumno.model
    property alias aliasTablaAlumno: tablaAlumno

    property int idClase : -1
    property bool originalSize: true
    property bool changeSizeAllowed: true
    property bool inicializacionComponente: true

    MouseArea {
        enabled: changeSizeAllowed
        anchors.fill: parent

        onDoubleClicked: {
            change_size()
        }
    }

    function change_size() {
        if (originalSize){
            buscadorCliente.height = buscadorCliente.height / 1.7
            originalSize = false
        }
        else{
            buscadorCliente.height = buscadorCliente.height * 1.7
            originalSize = true
        }
    }

    onIdClaseChanged: {
        console.debug("idClase: " + idClase)

        tablaAlumno.mostrarColumnaMatricula = false
        if (idClase === -1 )
            tablaAlumno.mostrarColumnaInscripcion = false
        else if (idClase === 0){
            tablaAlumno.mostrarColumnaInscripcion = false
            tablaAlumno.mostrarColumnaMatricula = true
        }else
            tablaAlumno.mostrarColumnaInscripcion = true
    }

    onEscucharSignalsChanged: {
        if (escucharSignals) {
            conexionListaDeClientes.target = wrapper.classManagementGestionDeAlumnos
            if (inicializacionComponente) {
                buscarEstudiante()
                inicializacionComponente = false
            }

        }
        else {
            conexionListaDeClientes.target = null
        }
    }

    function focoEnDNI() {
        //searchBoxApellido.aliasTxtTexto.focus = true
    }

    function buscarEstudiante() {
        recordClienteSeleccionado = null
        laBusquedaFueRealizadaPorDNI = searchBoxDni.strTxtTexto !== ".."
        var tipoDeBusqueda;
        if (idClase === -1) {
            //tablaAlumno.mostrarColumnaInscripcion = false
            if (checkMostrarInhabilitados.checked)
                tipoDeBusqueda = 2
            else
                tipoDeBusqueda = 1
        }
        else {
            if (checkAlumnosConAbonoInfantil.checked){
                tipoDeBusqueda = 5
            }
            else{
                tipoDeBusqueda = 4
            }
            //tablaAlumno.mostrarColumnaInscripcion = true
        }

        wrapper.classManagementGestionDeAlumnos.buscarAlumno(searchBoxApellido.strTxtTexto,searchBoxNombre.strTxtTexto,searchBoxDni.strTxtTexto, tipoDeBusqueda, idClase);
    }

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        id: conexionListaDeClientes
        target: null
        ignoreUnknownSignals: true

        onSig_listaAlumnos: {
            tablaAlumno.model = null
            tablaAlumno.model = listaAlumnos;
            if (laBusquedaFueRealizadaPorDNI && listaAlumnos.length === 1) {
                tablaAlumno.selection.select(0)
                tablaAlumno.doubleClicked(tablaAlumno.currentRow)
            }
        }
    }

    Rectangle {
        id: recBuscador
        anchors.left: parent.left
        anchors.right: btnBuscar.left
        anchors.top: parent.top
        anchors.margins: 3
        height: 70//40
        color: "transparent"

        Grid {
            anchors.fill: parent
            spacing: 3
            rows: 3
            columns: 2

            SearchBox {
                id: searchBoxApellido
                width: 200
                strLblTexto: qsTrId("Apellido")
                aliasTxtTexto.placeholderText: "Escriba aquí..."
                aliasTxtTexto.onAccepted: buscarEstudiante()

                Component.onCompleted: {
                    aliasTxtTexto.focus = true
                }

                onStrTxtTextoChanged: {
                    if (strTxtTexto !== ""){
                        searchBoxDni.limpiarTexto()
                    }
                    if (aliasTxtTexto.focus)
                        buscarEstudiante()
                }

                aliasTxtTexto.onFocusChanged: {
                    if (aliasTxtTexto.focus) {
                        if (aliasTxtTexto.text.length > 2) {
                            aliasTxtTexto.selectAll()
                        }
                    }
                }
            }

            SearchBox {
                id: searchBoxNombre
                width: 200
                strLblTexto: qsTrId("Nombre")
                aliasTxtTexto.placeholderText: "Escriba aquí..."
                aliasTxtTexto.onAccepted: buscarEstudiante()

                onStrTxtTextoChanged: {
                    if (strTxtTexto !== "") {
                        searchBoxDni.limpiarTexto()
                    }
                    if (aliasTxtTexto.focus)
                        buscarEstudiante()
                }

                aliasTxtTexto.onFocusChanged: {
                    if (aliasTxtTexto.focus) {
                        if (aliasTxtTexto.text.length > 2) {
                            aliasTxtTexto.selectAll()
                        }
                    }
                }

                //Component.onCompleted: {
                //realizarBusqueda.connect(buscarEstudiante)
                //}
            }

            SearchBox {
                id: searchBoxDni
                width: 200
                strLblTexto: qsTrId("DNI")
                aliasTxtTexto.inputMask: "00.000.000;_"
                aliasTxtTexto.onAccepted: buscarEstudiante()

                onStrTxtTextoChanged: {
                    if (aliasTxtTexto.focus)
                        buscarEstudiante()
                    if (aliasTxtTexto.text !== "..") {
                        searchBoxApellido.limpiarTexto()
                        searchBoxNombre.limpiarTexto()
                    }
                }

                aliasTxtTexto.onFocusChanged: {
                    if (aliasTxtTexto.focus) {
                        if (aliasTxtTexto.text === ".."){
                            aliasTxtTexto.cursorPosition = 0
                        }
                        if (aliasTxtTexto.text.length > 2) {
                            aliasTxtTexto.selectAll()
                        }
                    }
                }
            }

            Rectangle {
                color: "transparent"
                height: 28
                width: 130

                CheckBox {
                    id: checkMostrarInhabilitados
                    anchors.top:parent.top
                    anchors.topMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.leftMargin: 3
                    visible: dadosDeBaja
                    text: qsTrId("Dados de baja")
                    onCheckedChanged: buscarEstudiante()
                }

                CheckBox {
                    id: checkAlumnosConAbonoInfantil
                    anchors.top:parent.top
                    anchors.topMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.leftMargin: 3
                    visible: idClase !== -1
                    text: qsTrId("Alumnos con abono infantil")
                    onCheckedChanged: buscarEstudiante()
                }
            }
        }
    }

    /*Action {
        enabled: parent.enabled
        shortcut: "Enter"

        onTriggered: {
            buscarEstudiante()
        }
    }*/

    Action {
        enabled: parent.enabled
        shortcut: "enter" //StandardKey.InsertParagraphSeparator | "Enter"

        onTriggered: {
            buscarEstudiante()
        }
    }

    Button {
        id: btnBuscar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 6
        //height: searchBoxDni.height - 4
        height: 0
        width: 100
        text: qsTrId("Buscar")
        visible: false

        onClicked: {
            buscarEstudiante()
        }
    }

    Image {
        id: imgExpandir
        source: "qrc:/media/Media/Expandir.png"
        anchors.right: lblTotalRegistros.right
        anchors.top: btnBuscar.bottom
        anchors.topMargin: 3
        anchors.rightMargin: 3
        width: 18
        height: 18
        opacity: 0.7
        visible: changeSizeAllowed

        MouseArea {
            anchors.fill: parent
            enabled: changeSizeAllowed

            onClicked: {
                change_size()
            }
        }

    }

    Text {
        id: lblTotalRegistros
        anchors.top: imgExpandir.bottom
        anchors.topMargin: 11
        anchors.right: parent.right
        anchors.rightMargin: 7
        font.family: "verdana"
        styleColor: "grey"
        text: qsTrId("Total registros: ") + tablaAlumno.rowCount
    }

    Button {
        id: btnAlta                     //Este botón nunca se llegó a implementar.
        anchors.right: parent.right
        anchors.top: btnBuscar.bottom
        anchors.margins: 6
        height: searchBoxDni.height - 4
        width: 100
        //visible: poderDarDeAlta
        visible: false
        text: qsTrId("Nuevo")

        onClicked: {

        }
    }

    Rectangle {
        anchors.top: recBuscador.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        border.width: 1
        radius: 5

        TablaAlumno {
            id: tablaAlumno
            anchors.fill: parent

            onClicked: {
                if (currentRow != -1) {
                    recordClienteSeleccionado = model[currentRow]
                    wrapper.classManagementGestionDeAlumnos.recordAlumnoSeleccionado = model[currentRow]
                }
            }

            onCurrentRowChanged: {
                if (currentRow != -1) {
                    recordClienteSeleccionado = model[currentRow]
                    wrapper.classManagementGestionDeAlumnos.recordAlumnoSeleccionado = model[currentRow]
                }
            }
        }
    }
}
