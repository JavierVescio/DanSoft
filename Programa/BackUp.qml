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
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property bool dir1: true
    property variant recordBackUp: null

    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: {
        deshabilitar_direcciones()
        refrescar()
    }

    MessageDialog {
        id: messageDialog
        title: "BackUp"
    }

    function refrescar() {
        recordBackUp = wrapper.gestionBaseDeDatos.traerInfoBackUp()
        if (recordBackUp != null){
            txtDir1.text = recordBackUp.ruta1
            txtDir2.text = recordBackUp.ruta2
            checkCajaCierreCaja.checked = recordBackUp.al_cerrar_caja
            checkCajaCierrePrograma.checked = recordBackUp.al_cerrar_sistema
        }
    }

    FileDialog {
        id: fileDialog
        title: "Directorio donde se alojará la copia de seguridad de la base de datos"
        folder: shortcuts.home
        selectFolder: true
        onAccepted: {
            if (dir1) {
                txtDir1.text = folder
                txtDir1.text = txtDir1.text.substring(8)
            }
            else{
                txtDir2.text = folder
                txtDir2.text = txtDir2.text.substring(8)
            }
        }
    }

    Text {
        id: lblTitle
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 150
        text: qsTrId("BACKUP DE BASE DE DATOS")
        font.pixelSize: 30
        font.family: "Verdana"
        color: "#37474F"
        focus: false
    }

    Rectangle {
        id: recSubtitulo
        anchors.left: lblTitle.left
        anchors.right: lblTitle.right
        anchors.top: lblTitle.bottom
        height: 30
        color: "#37474F"
        focus: false

        Text {
            anchors.fill: parent
            anchors.margins: 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: "white"
            font.family: "Verdana"
            font.pixelSize: 14
            text: "CONFIGURACIÓN"
        }
    }

    function habilitar_direcciones() {
        /*btnDir1.enabled = true
        txtDir1.enabled = true
        btnDir2.enabled = true
        txtDir2.enabled = true*/
    }

    function deshabilitar_direcciones() {
        /*btnDir1.enabled = false
        txtDir1.enabled = false
        btnDir2.enabled = false
        txtDir2.enabled = false*/
    }

    Column {
        id: columnaDatos
        anchors.top: recSubtitulo.bottom
        anchors.topMargin: 3
        anchors.left: recSubtitulo.left
        anchors.right: recSubtitulo.right
        anchors.bottom: parent.bottom
        spacing: 10
        z: 1

        Behavior on opacity {PropertyAnimation{}}

        CheckBox {
            id: checkCajaCierreCaja
            text: "Al cerrar caja"

            onCheckedChanged: {
                if (checked){
                    habilitar_direcciones()
                }
                else {
                    if (!checkCajaCierrePrograma.checked){
                        deshabilitar_direcciones()
                    }
                }
            }
        }

        CheckBox {
            id: checkCajaCierrePrograma
            text: "Al cerrar DanSoft"

            onCheckedChanged: {
                if (checked){
                    habilitar_direcciones()
                }
                else {
                    if (!checkCajaCierreCaja.checked){
                        deshabilitar_direcciones()
                    }
                }
            }
        }

        Row {
            ToolButton {
                id: btnDir1
                iconSource: "qrc:/media/Media/icon-folder.png"
                onClicked: {
                    dir1 = true
                    fileDialog.visible = true
                }
            }

            TextField {
                id: txtDir1
                height: btnDir1.height
                width: columnaDatos.width - 35 - btnClearDir1.width
                placeholderText: "dirección1"
                readOnly: true
            }

            ToolButton {
                id: btnClearDir1
                iconSource: "qrc:/media/Media/salir.png"
                onClicked: {
                    txtDir1.text = ""
                }
            }
        }

        Row {
            ToolButton {
                id: btnDir2
                iconSource: "qrc:/media/Media/icon-folder.png"
                onClicked: {
                    dir1 = false
                    fileDialog.visible = true
                }
            }

            TextField {
                id: txtDir2
                height: btnDir2.height
                width: columnaDatos.width - 35 - btnClearDir2.width
                placeholderText: "dirección2"
                readOnly: true
            }

            ToolButton {
                id: btnClearDir2
                iconSource: "qrc:/media/Media/salir.png"
                onClicked: {
                    txtDir2.text = ""
                }
            }
        }

        /*Text {
            id: lblTotalRegistros
            font.family: "verdana";
            font.pixelSize: 14
            text: qsTrId("Total registros: ")
        }*/

        Button {
            id: btnAceptar
            text: "Guardar cambios"
            height: 35
            width: columnaDatos.width
            //enabled: (checkCajaCierreCaja.checked || checkCajaCierrePrograma.checked) && (txtDir1.length>0 || txtDir2.length>0) || ()

            onClicked: {
                var res
                if (recordBackUp == null){
                    res = wrapper.gestionBaseDeDatos.agregarInfoBackUp(
                                txtDir1.text,
                                txtDir2.text,
                                checkCajaCierreCaja.checked,
                                checkCajaCierrePrograma.checked)

                    if (res){
                        refrescar()
                        messageDialog.icon = StandardIcon.Information
                        messageDialog.text = "Perfecto, ya guardamos los cambios."
                    }else{
                        messageDialog.text = "Ups, ocurrió un problema. Volvé a intentar!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                }else{
                    res = wrapper.gestionBaseDeDatos.actualizarInfoBackUp(
                                recordBackUp.id,
                                txtDir1.text,
                                txtDir2.text,
                                checkCajaCierreCaja.checked,
                                checkCajaCierrePrograma.checked)

                    if (res){
                        refrescar()
                        messageDialog.icon = StandardIcon.Information
                        messageDialog.text = "Perfecto, ya guardamos los cambios."
                    }else{
                        messageDialog.text = "Ups, ocurrió un problema. Volvé a intentar!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                }
            }
        }

        Text{
            id: btnHacerBackup
            color: "blue"
            text: "Hacer una copia de seguridad ahora"
            enabled: {
                if (recordBackUp !== null){
                    if (recordBackUp.ruta1 !== "" || recordBackUp.ruta2 !== "")
                        true
                    else
                        false
                }else
                    false
            }
            visible: enabled

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                enabled: parent.enabled

                onEntered:
                    parent.font.underline = true
                onExited:
                    parent.font.underline = false
                onClicked: {
                    var res = wrapper.gestionBaseDeDatos.hacerBackUp(
                                recordBackUp.ruta1,
                                recordBackUp.ruta2)
                    if (res){
                        messageDialog.icon = StandardIcon.Information
                        messageDialog.text = "Perfecto, ya hicimos la copia de seguridad."
                    }else{
                        messageDialog.text = "Ups, ocurrió un problema. Volvé a intentar!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                }
            }
        }
    }

}

