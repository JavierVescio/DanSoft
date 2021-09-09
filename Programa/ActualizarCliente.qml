//import QtQml 2.0
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.4
import "qrc:/components"
import QtQuick.Dialogs 1.0
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CMAlumno 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.1

Rectangle {
    id: principal
    opacity: 0
    enabled: false
    property var recordClienteSeleccionado : buscador.recordClienteSeleccionado
    property alias aliasImgFotoClienteSource: imgFotoCliente.source
    property bool cargaRealizada: false
    property string sinFoto : "qrc:/media/Media/woman.jpg"

    Behavior on opacity {PropertyAnimation{}}

   /* Action {
        enabled: principal.enabled
        shortcut: "Enter"

        onTriggered: {
            btnAlta.onClicked();
        }
    }*/

    Action {
        enabled: principal.enabled
        shortcut: StandardKey.InsertParagraphSeparator

        onTriggered: {
            btnAlta.clicked();
        }
    }

    Component {
        id: compCamara

        CamaraDeFotos {
            onImageReady: {
                imgFotoCliente.source = arg
                loaderCamara.sourceComponent = undefined
                recOcultar.opacity = 0
                recOcultar.enabled = false
            }

            onCerrarCamara: {
                loaderCamara.sourceComponent = undefined
                recOcultar.opacity = 0
                recOcultar.enabled = false
            }
        }
    }

    Loader {
        id: loaderCamara
        anchors.centerIn: parent
        z: 2
    }

    Rectangle {
        id: recOcultar
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: 1
        enabled: false

        MouseArea {
            anchors.fill: parent

            onClicked: {
                loaderCamara.sourceComponent = undefined
                recOcultar.opacity = 0
                recOcultar.enabled = false
            }
        }
    }

    WrapperClassManagement {
        id: wrapper
    }

    /*Connections {
        //target: principal.enabled ? wrapper.classManagementGestionDeAlumnos : null
        //ignoreUnknownSignals: true
        target: wrapper.classManagementGestionDeAlumnos

        onSig_urlFotoCliente: {
            imgFotoCliente.source = arg
        }

        onSig_noHayFoto: {
            imgFotoCliente.source = sinFoto
        }
    }*/

    function salir() {
        limpiarFormulario()
        principal.opacity = 0
        principal.enabled = false
        principal.parent.enabled = true
        principal.parent.opacity = 1
        imgFotoCliente.source = sinFoto
        refrescar()
    }

    MessageDialog {
        id: messageDialog
        title: "Gestión de Alumnos"
    }

    FileDialog {
        id: fileDialogFoto
        title: "Elija una foto del alumno"
        nameFilters: [ "Archivos de imagen (*.jpg *.png)", "Todos los archivos (*)" ]
        onAccepted: {
            imgFotoCliente.source = fileDialogFoto.fileUrl
        }
    }

    function limpiarFormulario() {
        txtApellido.limpiarTexto()
        txtPrimerNombre.limpiarTexto()
        txtSegundoNombre.limpiarTexto()
        comboGenero.setDefault()
        txtNacimiento.limpiarTexto()
        txtDni.limpiarTexto()
        txtTelefonoLinea.limpiarTexto()
        txtTelefonoCelular.limpiarTexto()
        txtCorreo.limpiarTexto()
        txtComentario.limpiarTexto()
    }

    function realizarCarga() {
        var data = wrapper.classManagementGestionDeAlumnos
        data.clienteEnProcesoDeActualizacion.id = recordClienteSeleccionado.id
        data.clienteEnProcesoDeActualizacion.apellido = recordClienteSeleccionado.apellido
        data.clienteEnProcesoDeActualizacion.primerNombre = recordClienteSeleccionado.primerNombre
        data.clienteEnProcesoDeActualizacion.segundoNombre = recordClienteSeleccionado.segundoNombre
        data.clienteEnProcesoDeActualizacion.genero = recordClienteSeleccionado.genero
        data.clienteEnProcesoDeActualizacion.nacimiento = recordClienteSeleccionado.nacimiento
        data.clienteEnProcesoDeActualizacion.dni = recordClienteSeleccionado.dni
        data.clienteEnProcesoDeActualizacion.telefonoFijo = recordClienteSeleccionado.telefonoFijo
        data.clienteEnProcesoDeActualizacion.telefonoCelular = recordClienteSeleccionado.telefonoCelular
        data.clienteEnProcesoDeActualizacion.correo = recordClienteSeleccionado.correo
        data.clienteEnProcesoDeActualizacion.nota = recordClienteSeleccionado.nota
        data.clienteEnProcesoDeActualizacion.estado = recordClienteSeleccionado.estado
        data.clienteEnProcesoDeActualizacion.blame_user = recordClienteSeleccionado.blame_user
        data.clienteEnProcesoDeActualizacion.blame_timestamp = recordClienteSeleccionado.blame_timestamp
        cargaRealizada=true
        cargaRealizada=false
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 0
        contentHeight: itemAddeed.height
        contentWidth: itemAddeed.width

        Rectangle {
            id: itemAddeed
            anchors.margins: 5
            anchors.fill: parent

            Text {
                id: lblTitleCuatro
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTrId("ACTUALIZACIÓN DE ALUMNO")
                font.pixelSize: 30
                font.family: "Verdana"
                color: "#F9A825"
            }

            Rectangle {
                id: recSubtituloCuatro
                anchors.top: lblTitleCuatro.bottom
                width: principal.width
                height: 30
                color: "#F9A825"
                z: 20

                Text {
                    anchors.fill: parent
                    anchors.margins: 3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: "white"
                    font.family: "Verdana"
                    font.pixelSize: 14
                    text: "CAMBIO DE DATOS Y/O FOTO DE PERFIL"
                }
            }

            Column {
                id: columnData
                anchors.left: parent.left
                anchors.top: recSubtituloCuatro.bottom
                anchors.bottom: parent.bottom
                width: 375
                anchors.margins: 10
                spacing: 3

                move: Transition {
                    NumberAnimation { properties: "x,y"; duration: 50 }
                }

                TextFieldWithLabel {
                    id: txtApellido
                    strLblTexto: qsTrId("Apellido (*)")
                    p_txtTexto.maximumLength: 45
                    p_fieldRequired: true
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.apellido
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.apellido = strTxtTexto
                    }


                }
                TextFieldWithLabel {
                    id: txtPrimerNombre
                    strLblTexto: qsTrId("Primer nombre (*)")
                    p_txtTexto.maximumLength: 45
                    p_fieldRequired: true
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: {
                        if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.primerNombre

                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.primerNombre = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtSegundoNombre
                    strLblTexto: qsTrId("Segundo nombre")
                    p_txtTexto.maximumLength: 45
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.segundoNombre
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.segundoNombre = strTxtTexto
                    }
                }
                ComboBoxWithLabel {
                    id: comboGenero
                    strLblTexto: qsTrId("Género")
                    comboComp.model: [ "Femenino", "Masculino" ]
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.genero === "Femenino" ? comboComp.currentIndex = 0 : comboComp.currentIndex = 1
                    }

                    onIndexComboChanged: {
                        indexCombo === 0 ? wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.genero = "Femenino" : wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.genero = "Masculino"
                    }
                }
                TextFieldWithLabel {
                    id: txtNacimiento
                    strLblTexto: qsTrId("Nacimiento (dd/mm/aaaa)")
                    property var locale: Qt.locale()
                    property string aux
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)

                            aux = Qt.formatDate(wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.nacimiento,"dd/MM/yyyy").toString()
                        p_txtTexto.inputMask = "00/00/0000;_"
                        p_txtTexto.text = aux.replace("/","");
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.nacimiento = Date.fromLocaleString(locale, strTxtTexto, "dd/MM/yyyy");
                    }

                    p_txtTexto.onFocusChanged: {
                        if (p_txtTexto.text === "//"){
                            p_txtTexto.cursorPosition = 0
                        }
                    }
                }

                TextFieldWithLabel {
                    id: txtDni
                    strLblTexto: qsTrId("DNI")
                    p_fieldRequired: false
                    property string aux
                    property bool cargaRealizada : principal.cargaRealizada
                    property variant alumno : null
                    property string dniOriginal : ""

                    onCargaRealizadaChanged: {
                        if (cargaRealizada)
                            aux= wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.dni
                        p_txtTexto.inputMask = "00.000.000;_";
                        dniOriginal = aux
                        p_txtTexto.text = aux.replace(".","")
                        /*if (p_txtTexto.text !== "..") {
                            p_txtTexto.readOnly = true
                            validado = true
                        }
                        else {
                            p_txtTexto.readOnly = false
                        }*/
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.dni = strTxtTexto
                        alumno = wrapper.classManagementGestionDeAlumnos.obtenerAlumnoPorId(strTxtTexto,0)
                        if (alumno !== null && p_txtTexto.readOnly == false && p_txtTexto.text !== dniOriginal) {
                            validado = false
                        }
                        else {
                            validado = true
                        }
                    }

                    p_txtTexto.onFocusChanged: {
                        if (p_txtTexto.text === ".."){
                            p_txtTexto.cursorPosition = 0
                        }
                    }
                }

                Rectangle {
                    opacity:  {
                        if (txtDni.alumno !== null && txtDni.p_txtTexto.text !== txtDni.dniOriginal)
                            1
                        else
                            0
                    }
                    enabled: opacity === 1
                    visible: opacity > 0
                    width: txtDni.width
                    height: 40
                    border.color: "black"
                    border.width: 2
                    color: "#FF0000"

                    Behavior on opacity {PropertyAnimation{}}

                    Text {
                        anchors.fill: parent
                        anchors.margins: 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        font.family: "Verdana"
                        font.pixelSize: 14
                        text: {
                            if (txtDni.alumno != null) {
                                if (txtDni.alumno.estado === "Habilitado")
                                    "Ya está registrado.\nEstado: Habilitado"
                                else
                                    "Ya está registrado.\nEstado: Dado de baja"
                            }
                            else
                                ""
                        }
                    }
                }

                TextFieldWithLabel {
                    id: txtTelefonoLinea
                    strLblTexto: qsTrId("Teléfono de línea")
                    p_txtTexto.maximumLength: 20
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.telefonoFijo
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.telefonoFijo = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtTelefonoCelular
                    strLblTexto: qsTrId("Teléfono celular")
                    p_txtTexto.maximumLength: 20
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.telefonoCelular
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.telefonoCelular = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtCorreo
                    strLblTexto: qsTrId("Correo electrónico")
                    p_txtTexto.maximumLength: 45
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.correo
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.correo = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtComentario
                    strLblTexto: qsTrId("Comentario")
                    p_txtTexto.maximumLength: 140
                    property bool cargaRealizada : principal.cargaRealizada

                    onCargaRealizadaChanged: { if (cargaRealizada)
                            p_txtTexto.text = wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.nota
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeActualizacion.nota = strTxtTexto
                    }
                }

                Row {
                    height: 30
                    width: parent.width
                    x: 0
                    spacing: 3

                    Button {
                        text: qsTrId("Cancelar")

                        onClicked: {
                            salir()
                        }
                    }

                    Button {
                        id: btnAlta
                        text: qsTrId("Validar y actualizar")
                        width: 298
                        enabled: txtApellido.validado * txtPrimerNombre.validado * txtDni.validado

                        onClicked: {
                            if (wrapper.classManagementGestionDeAlumnos.actualizacionAlumno()) {
                                messageDialog.text = "Cliente actualizado exitosamente."
                                messageDialog.icon = StandardIcon.Information
                                messageDialog.open()
                                salir()
                            }
                            else {
                                messageDialog.text = "Error en el proceso de actualización.\nProbable duplicación de DNI o campos obligatorios incompletos."
                                messageDialog.icon = StandardIcon.Critical
                                messageDialog.open()
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: recImagen
                anchors.left: columnData.right
                width: 300
                anchors.top: recSubtituloCuatro.bottom
                height: 300
                anchors.margins: 10
                border.color: "#006d7e"
                radius: 5
                Row {
                    id: rowOpciones
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    layoutDirection: Qt.RightToLeft
                    height: 30
                    z: 2
                    ToolButton {
                        iconSource: "qrc:/media/Media/salir.png"
                        opacity: 0.8

                        onClicked: {
                            imgFotoCliente.source = sinFoto
                        }
                    }

                    ToolButton {
                        iconSource: "qrc:/media/Media/open.png"
                        opacity: 0.7

                        onClicked: {
                            fileDialogFoto.open()
                        }
                    }

                    ToolButton {
                        id: toolButtonFoto
                        iconSource: "qrc:/media/Media/foto.png"
                        opacity: 0.8

                        onClicked: {
                            if (loaderCamara.sourceComponent === compCamara) {
                                recOcultar.opacity = 0
                                recOcultar.enabled = false
                                loaderCamara.sourceComponent = undefined
                            }
                            else {
                                recOcultar.opacity = 0.1
                                recOcultar.enabled = true
                                loaderCamara.sourceComponent = compCamara
                            }
                        }
                    }

                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    height: 30
                    width: 93
                    opacity: 0.7
                    border.color: "grey"
                    z: 1
                }

                Image {
                    id: imgFotoCliente
                    anchors.fill: parent
                    anchors.margins: 1
                    anchors.top: rowOpciones.bottom
                    source: sinFoto
                    fillMode: Image.PreserveAspectFit
                    opacity: 0.1

                    onSourceChanged: {
                        if (source != sinFoto){
                            wrapper.classManagementGestionDeAlumnos.pathFotoCliente = source
                            imgFotoCliente.opacity = 1
                        }
                        else {
                            wrapper.classManagementGestionDeAlumnos.pathFotoCliente = ""
                            imgFotoCliente.opacity = 0.1
                        }
                    }

                    Behavior on opacity {PropertyAnimation{}}
                }
            }
        }
    }
}
