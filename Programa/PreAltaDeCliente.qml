//import QtQml 2.0
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "qrc:/components"
import QtQuick.Dialogs 1.0
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CMAlumno 1.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: principal
    anchors.fill: parent
    property variant p_objPestania
    opacity: 0
    enabled: false

    Behavior on opacity {PropertyAnimation{}}

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: principal.enabled ? wrapper.classManagementGestionDeAlumnos : null
        ignoreUnknownSignals: true

        onSig_listaAlumnos: {
            tablaAlumno.model = 0
            tablaAlumno.model = listaAlumnos;
            if (listaAlumnos.length > 0) {
                tablaAlumno.selection.select(0)
                //tablaAlumno.doubleClicked(tablaAlumno.currentRow)
            }
            else {
                itemPasoTres.opacity = 0
                altaDeCliente.opacity = 1
                altaDeCliente.strApellido = txtApellido.text
                altaDeCliente.strNombre = txtPrimerNombre.text
                altaDeCliente.strDNI = txtDNI.text
            }

        }
    }

    Connections {
        target: wrapper.classManagementGestionDeAlumnos

        onSig_altaClienteExitosa: {
            altaDeCliente.opacity = 0
            itemPasoUno.opacity = 1
            txtApellido.text = ""
            txtPrimerNombre.text = ""
            txtDNI.text = ""
            txtDNI.inputMask = ""
            txtApellido.focus = true
            detallesDelCliente.aliasRecordClienteSeleccionado = null
        }

    }

    Item {
        id: itemPasoUno
        anchors.centerIn: parent
        width: 320
        height: 318
        property variant alumno : null

        Behavior on opacity {PropertyAnimation{}}

        onAlumnoChanged: {
            if (alumno !== null) {

            }
        }

        Text {
            id: lblTitle
            anchors.left: parent.left
            anchors.top: parent.top
            text: qsTrId("ALTA DE ALUMNO")
            font.pixelSize: 30
            font.family: "Verdana"
            color: "#F9A825"
            focus: false
        }

        Rectangle {
            id: recSubtitulo
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: lblTitle.bottom
            height: 30
            color: "#F9A825"
            focus: false

            Text {
                anchors.fill: parent
                anchors.margins: 3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "white"
                font.family: "Verdana"
                font.pixelSize: 14
                text: "CARGA DE DATOS BASICOS"
            }
        }

        Column {
            id: col
            anchors.top: recSubtitulo.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10
            property int textFieldHeight: 45
            property int textFieldPixelSize : 15
            property string textFieldFontFamily : "verdana"
            property color textFieldTextColor : "#585858"

            Component.onCompleted:
                txtApellido.focus = true

            TextField {
                id: txtApellido
                placeholderText: qsTrId("APELLIDO")
                height: parent.textFieldHeight
                width: parent.width
                font.pixelSize: parent.textFieldPixelSize
                font.family: parent.textFieldFontFamily
                focus: true
                textColor: parent.textFieldTextColor
                property bool validado : false


                onTextChanged: {
                    validado = text.length > 1

                    if (text.length > 0) {
                        text = text.substring(0,1).toUpperCase() + text.substring(1)
                    }
                }

                onAccepted:
                    btnContinuarSeguridad.clicked()
            }

            TextField {
                id: txtPrimerNombre
                placeholderText: qsTrId("PRIMER NOMBRE")
                height: parent.textFieldHeight
                width: parent.width
                font.pixelSize: parent.textFieldPixelSize
                font.family: parent.textFieldFontFamily
                textColor: parent.textFieldTextColor
                property bool validado : false

                onTextChanged: {
                    validado = text.length > 1

                    if (text.length > 0) {
                        text = text.substring(0,1).toUpperCase() + text.substring(1)
                    }
                }

                onAccepted:
                    btnContinuarSeguridad.clicked()
            }

            Row {
                TextField {
                    id: txtDNI
                    placeholderText: qsTrId("DNI")
                    height: col.textFieldHeight
                    width: col.width
                    font.pixelSize: col.textFieldPixelSize
                    font.family: col.textFieldFontFamily
                    textColor: col.textFieldTextColor
                    property bool validado : true

                    onFocusChanged: {
                        if (focus) {
                            if (text.length === 0)
                                inputMask = "00.000.000;_"
                        }
                        else {
                            if (text.length === 2)
                                inputMask = ""
                        }
                    }

                    onTextChanged: {
                        if (text.length > 0) {
                            validado = false
                            itemPasoUno.alumno = wrapper.classManagementGestionDeAlumnos.obtenerAlumnoPorId(text,0)
                            validado = itemPasoUno.alumno === null
                        }
                        else
                            validado = true
                    }

                    onAccepted:
                        btnContinuarSeguridad.clicked()
                }

                Rectangle {
                    opacity: itemPasoUno.alumno !== null ? 1 : 0
                    enabled: opacity === 1
                    height: txtDNI.height
                    width: 200
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
                            if (itemPasoUno.alumno != null) {
                                if (itemPasoUno.alumno.estado === "Habilitado")
                                    "Ya está registrado.\nEstado: Habilitado"
                                else
                                    "Ya está registrado.\nEstado: Dado de baja"
                            }
                            else
                                ""
                        }
                    }
                }
            }

            Button {
                id: btnContinuarSeguridad
                text: qsTrId("Continuar al siguiente paso")
                height: parent.textFieldHeight
                width: parent.width
                enabled: txtApellido.validado * txtPrimerNombre.validado * txtDNI.validado

                onClicked: {
                    if (enabled) {
                        itemPasoUno.opacity = 0
                        itemPasoTres.opacity = 1
                        buscador.recordClienteSeleccionado = null
                        tablaAlumno.model = 0
                        wrapper.classManagementGestionDeAlumnos.buscarAlumno(txtApellido.text,txtPrimerNombre.text,txtDNI.text,3)
                    }
                }
            }
        }
    }

    Item {
        id: itemPasoTres
        anchors.fill: parent
        anchors.margins: 0
        opacity: 0
        enabled: opacity === 1
        property int textFieldHeight: 45

        Behavior on opacity {PropertyAnimation{}}

        Text {
            id: lblTitleTres
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            text: qsTrId("ALTA DE ALUMNO")
            font.pixelSize: 30
            font.family: "Verdana"
            color: "#F9A825"
        }

        Rectangle {
            id: recSubtituloTres
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            anchors.top: lblTitleTres.bottom
            height: 30
            color: "#F9A825"

            Text {
                anchors.fill: parent
                anchors.margins: 3
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: "white"
                font.family: "Verdana"
                font.pixelSize: 14
                text: "¿Está seguro de que el alumno no fue registrado anteriormente?"
            }
        }

        Text {
            id: lblInfo
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: detallesDelCliente.left
            anchors.top: recSubtituloTres.bottom
            anchors.topMargin: 10
            width: parent.width
            font.family: "tahoma"
            font.pixelSize: 14
            text: "Si el alumno/a aparece en la tabla de abajo, quiere decir que ya fue dado de alta.\nCaso contrario, si el alumno/a no está en la tabla, por favor, continuá al último paso."
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Rectangle {
            id: buscador
            anchors.top: lblInfo.bottom
            anchors.bottom: btnContinuar.top
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            anchors.rightMargin: -1
            anchors.leftMargin: -1
            anchors.topMargin: 10
            border.width: 1
            radius: 5
            property variant recordClienteSeleccionado : null

            TablaAlumno {
                id: tablaAlumno
                anchors.fill: parent

                onClicked: {
                    detallesDelCliente.aliasRecordClienteSeleccionado = model[currentRow]
                }
            }
        }

        Button {
            id: btnContinuar
            text: qsTrId("Continuar al último paso")
            height: parent.textFieldHeight
            anchors.left: parent.left
            anchors.right: detallesDelCliente.left
            anchors.bottom: parent.bottom

            onClicked: {
                itemPasoTres.opacity = 0
                altaDeCliente.opacity = 1
                altaDeCliente.strApellido = txtApellido.text
                altaDeCliente.strNombre = txtPrimerNombre.text
                altaDeCliente.strDNI = txtDNI.text
            }
        }


        DetallesDelCliente {
            id: detallesDelCliente
            anchors.top: parent.top
            anchors.topMargin: -1
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 250
        }
    }

    AltaDeCliente {
        id: altaDeCliente
        anchors.fill: parent
    }
}

