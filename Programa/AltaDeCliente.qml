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
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: principal
    anchors.fill: parent
    anchors.margins: 5
    opacity: 0
    enabled: opacity === 1
    property string sinFoto : "qrc:/media/Media/woman.jpg"
    property string strNombre
    property string strApellido
    property string strDNI

    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    Rectangle {
        id: recOcultar
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: 5
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
        z: 6
    }

    Action {
        enabled: principal.enabled
        shortcut: "Enter"

        onTriggered: {
            if (btnAlta.enabled)
                wrapper.classManagementGestionDeAlumnos.darDeAltaAlumno()
        }
    }

    /*Action {
        enabled: principal.enabled
        shortcut: StandardKey.InsertParagraphSeparator

        onTriggered: {
            if (btnAlta.enabled)
                wrapper.classManagementGestionDeAlumnos.darDeAltaAlumno()
        }
    }*/


    Connections {
        target: wrapper.classManagementGestionDeAlumnos

        onSig_falloAltaCliente: {
            messageDialog.text = "Error en el proceso de alta.\nProbable duplicación de DNI o campos obligatorios incompletos."
            messageDialog.icon = StandardIcon.Critical
            messageDialog.open()
        }

        onSig_altaClienteExitosa: {
            limpiarFormulario()
            quitarFoto()
            messageDialog.text = "Alumno dado de alta exitosamente."
            messageDialog.icon = StandardIcon.Information
            messageDialog.open()
        }

        onSig_falloAltaFotoCliente: {
            messageDialog.text = "¡No se pudo cargar la foto!"
            messageDialog.icon = StandardIcon.Critical
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Gestión de alumnos"
    }

    MessageDialog {
        id: messageLimpiarFormulario
        icon: StandardIcon.Question
        title: qsTrId("Alta de alumno - Limpiar el formulario")
        text: qsTrId("Se limpiará el formulario. ¿Está seguro que desea continuar?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            limpiarFormulario()
        }
    }

    FileDialog {
        id: fileDialogFoto
        title: "Elija una foto de su alumno/a"
        nameFilters: [ "Archivos de imagen (*.jpg *.png)", "Todos los archivos (*)" ]
        onAccepted: {
            imgFotoCliente.source = fileDialogFoto.fileUrl
        }
    }

    function limpiarFormulario() {
        txtSegundoNombre.limpiarTexto()
        comboGenero.setDefault()
        txtNacimiento.limpiarTexto()
        txtTelefonoLinea.limpiarTexto()
        txtTelefonoCelular.limpiarTexto()
        txtCorreo.limpiarTexto()
        txtComentario.limpiarTexto()
        txtApellido.p_txtTexto.focus = true
    }

    function quitarFoto() {
        imgFotoCliente.source = sinFoto
    }

    Flickable {
        anchors.fill: parent
        contentHeight: itemAddeed.height
        contentWidth: itemAddeed.width

        Item {
            id: itemAddeed
            anchors.fill: parent

            Text {
                id: lblTitleCuatro
                anchors.left: parent.left
                anchors.top: parent.top
                text: qsTrId("ALTA DE ALUMNO")
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
                    text: "CARGA DE MAS DATOS Y FOTO DE PERFIL"
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

                TextFieldWithLabel {
                    id: txtApellido
                    strLblTexto: qsTrId("Apellido (*)")
                    p_txtTexto.maximumLength: 45
                    p_txtTexto.readOnly: true
                    p_fieldRequired: true
                    p_txtTexto.text: strApellido

                    Component.onCompleted: {
                        p_txtTexto.focus = true
                    }

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.apellido = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtPrimerNombre
                    strLblTexto: qsTrId("Primer nombre (*)")
                    p_txtTexto.readOnly: true
                    p_txtTexto.maximumLength: 45
                    p_fieldRequired: true
                    p_txtTexto.text: strNombre

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.primerNombre = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtSegundoNombre
                    strLblTexto: qsTrId("Segundo nombre")
                    p_txtTexto.maximumLength: 45

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.segundoNombre = strTxtTexto
                    }
                }
                ComboBoxWithLabel {
                    id: comboGenero
                    strLblTexto: qsTrId("Género")
                    comboComp.model: [ "Femenino", "Masculino" ]

                    onIndexComboChanged: {
                        indexCombo === 0 ? wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.genero = "Femenino" : wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.genero = "Masculino"
                    }
                }
                TextFieldWithLabel {
                    id: txtNacimiento
                    strLblTexto: qsTrId("Nacimiento (dd/mm/aaaa)")
                    p_txtTexto.inputMask: "00/00/0000;_"
                    property var locale: Qt.locale()

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.nacimiento = Date.fromLocaleString(locale, strTxtTexto, "dd/MM/yyyy");
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
                    p_txtTexto.inputMask: "00.000.000;_"
                    p_txtTexto.readOnly: true
                    p_fieldRequired: false
                    p_txtTexto.text: strDNI

                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.dni = strTxtTexto
                    }

                    p_txtTexto.onFocusChanged: {
                        if (p_txtTexto.text === ".."){
                            p_txtTexto.cursorPosition = 0
                        }
                    }

                }
                TextFieldWithLabel {
                    id: txtTelefonoLinea
                    strLblTexto: qsTrId("Teléfono de línea")
                    p_txtTexto.maximumLength: 20
                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.telefonoFijo = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtTelefonoCelular
                    strLblTexto: qsTrId("Teléfono celular")
                    p_txtTexto.maximumLength: 20
                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.telefonoCelular = strTxtTexto
                    }
                }
                TextFieldWithLabel {
                    id: txtCorreo
                    strLblTexto: qsTrId("Correo electrónico")
                    p_txtTexto.maximumLength: 45
                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.correo = strTxtTexto
                    }
                }

                TextFieldWithLabel {
                    id: txtComentario
                    strLblTexto: qsTrId("Comentario")
                    p_txtTexto.maximumLength: 140
                    onStrTxtTextoChanged: {
                        wrapper.classManagementGestionDeAlumnos.clienteEnProcesoDeAlta.nota = strTxtTexto
                    }
                }

                Row {
                    height: 30
                    width: parent.width
                    x: 0
                    spacing: 3

                    Button {
                        text: qsTrId("Limpiar formulario")
                        onClicked: messageLimpiarFormulario.open()
                    }

                    Button {
                        id: btnAlta
                        text: qsTrId("Dar de alta")
                        width: 298 - 17
                        enabled: true //txtApellido.validado * txtPrimerNombre.validado * txtDni.validado

                        onClicked: {
                            //seLlegoAlLimite
                            if (wrapper.classManagementManager.versionGratis){
                                if (wrapper.classManagementManager.seLlegoAlLimite())
                                    messageLimite.open()
                                else
                                    wrapper.classManagementGestionDeAlumnos.darDeAltaAlumno()
                            }
                            else
                                wrapper.classManagementGestionDeAlumnos.darDeAltaAlumno()
                        }
                    }
                }
            }

            MessageDialog {
                id: messageLimite
                icon: StandardIcon.Warning
                title: qsTrId("¡Límite alcanzado!")
                text: qsTrId("¡Vaya! No se pudo realizar el alta del alumno, ya que actualmente hay "+wrapper.classManagementManager.limiteDeAlumnos+" alumnos registrados en el sistema.\nPuedes, sin embargo, actualizar los datos de un viejo alumno por los del nuevo y volver a intentarlo, o bien, puedes ponerte en contacto conmigo (menú 'Acerca de' -> 'Sobre la copia') y solicitar una versión de este programa que se adapte a tus necesidades.")
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
                            quitarFoto()
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
                            //loaderCamara.sourceComponent === compCamara ? loaderCamara.sourceComponent = undefined : loaderCamara.sourceComponent = compCamara

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
                            wrapper.classManagementGestionDeAlumnos.pathFotoAlta = source
                            imgFotoCliente.opacity = 1
                        }
                        else {
                            wrapper.classManagementGestionDeAlumnos.pathFotoAlta = ""
                            imgFotoCliente.opacity = 0.1
                        }
                    }

                    Behavior on opacity {PropertyAnimation{}}
                }
            }
        }
    }
}

/* Rectangle {
                width: 350
                height: 300
                anchors.centerIn: parent
                border.color: "red"
                border.width: 2
                radius: 5

                Item {
                    anchors.fill: parent

                    Camera {
                        id: camera

                        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

                        exposure {
                            exposureCompensation: -1.0
                            exposureMode: Camera.ExposurePortrait
                        }

                        flash.mode: Camera.FlashRedEyeReduction

                        imageCapture {
                            onImageCaptured: {
                                photoPreview.source = preview  // Show the preview in an Image
                            }
                        }
                    }

                    VideoOutput {
                        source: camera
                        anchors.fill: parent
                        focus : visible // to receive focus and capture key events when visible
                    }

                    Image {
                        id: photoPreview
                    }
                }
            }
        */
