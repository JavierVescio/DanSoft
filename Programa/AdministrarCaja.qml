import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CuentaAlumno 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}

    property color backColorSubtitles: "#C8E6C9"
    property color colorSubtitles: "black"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null


    WrapperClassManagement {
        id: wrapper
    }

    SelectorTipoOperacion {
        id: selectorOperacion
        anchors.fill: parent
        enabled: false
        z: 2

        onEnabledChanged: {
            if (!enabled){
                if (idTipoOperacionSeleccionado !== -1){
                    lblOperacionSeleccionada.text = strDescripcionSeleccionada
                }
            }
        }
    }

    function limpiar() {
        txtMontoIngresado.text = "0"
        txtComentarioIngresado.text = ""
        lblOperacionSeleccionada.text = ""
        saldoMovimientos.tableViewMovimientos.model = 0
        selectorOperacion.limpiar()
        cargar_datos_de_tabla()
    }

    Component.onCompleted: {
        cargar_datos_de_tabla()
    }

    function cargar_datos_de_tabla() {
        saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(-1, -1)
        saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: parent.top
        height: 250
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.bottom: btnRegistrarMovimiento.top
        anchors.leftMargin: -1
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        enabled: !selectorOperacion.enabled
    }

    Flickable {
        id: flickDatos
        parent: scroll
        anchors.fill: scroll
        contentHeight: columnaDatos.height
        contentWidth: columnaDatos.width
        clip: true

        Column {
            id: columnaDatos
            spacing: 10
            opacity: 1
            enabled: true
            z: 1
            property int separacionIzquierda: 3

            Behavior on opacity {PropertyAnimation{}}

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: qsTrId("Ingreso o egreso (use signo negativo para egreso. Ej: $ -250)")
                    color: colorSubtitles
                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width

                Rectangle {
                    id: recText
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 10

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: columnaDatos.separacionIzquierda
                        font.family: "verdana";
                        font.pixelSize: 20
                        text: "$"
                        color: colorSubtitles
                    }
                }

                TextField {
                    id: txtMontoIngresado
                    anchors.left: recText.right
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.family: "verdana";
                    font.pixelSize: 20
                    horizontalAlignment: TextInput.AlignRight
                    height: 30
                    width: 175
                    textColor: text < 0 ? "red" : "green"
                    text: "0"
                    maximumLength: 5
                    validator: DoubleValidator {
                        //decimals: 2
                        //locale: toLocaleString(Qt.locale("es-ar"))
                    }

                    onTextChanged: {
                        text = text.replace(",","")
                        text = text.replace(".","")
                    }


                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: qsTrId("Motivo del ingreso/egreso")
                    color: colorSubtitles
                }
            }

            Rectangle {
                height: 30
                width: flickDatos.width
                color: "transparent"

                Row {
                    anchors.fill: parent
                    spacing: 10

                    TextField {
                        id: lblOperacionSeleccionada
                        height: 30
                        width: 300
                        font.family: "verdana";
                        readOnly: true
                        placeholderText: "Especifique el tipo de operación"
                    }

                    Button {
                        text: "Tipo de operación"
                        height: 30
                        width: 175
                        enabled: !selectorOperacion.enabled

                        onClicked: {
                            selectorOperacion.enabled = true
                        }
                    }
                }
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: qsTrId("Comentario adicional (opcional)")
                    color: colorSubtitles
                }
            }

            Rectangle {
                height: 30
                width: flickDatos.width
                color: "transparent"

                TextField {
                    id: txtComentarioIngresado
                    anchors.fill: parent
                    anchors.rightMargin: -1
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana";
                    placeholderText: "Escriba aquí"
                }
            }
        }
    }

    SaldoMovimientos {
        id: saldoMovimientos
        anchors.top: scroll.bottom
        anchors.bottom: btnRegistrarMovimiento.top
        anchors.left: parent.left
        anchors.right: parent.right
        //width: flickDatos.width
        mostrarTextoRecientes: false
        movimientosDeCaja: true
    }

    Button {
        id: btnRegistrarMovimiento
        text: qsTrId("Registrar movimiento")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: !selectorOperacion.enabled

        onClicked: {

            // checar si selectorOperacion los id son -1.
            if (selectorOperacion.idTipoOperacionSeleccionado == -1){
                messageDialog.text = "Seleccione un tipo de operación"
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
            }
            else {
                wrapper.gestionBaseDeDatos.beginTransaction()

                var tipoMasComentario = ""
                if (txtComentarioIngresado.length > 0){
                    tipoMasComentario = lblOperacionSeleccionada.text + " | " + txtComentarioIngresado.text
                }
                else {
                    tipoMasComentario = lblOperacionSeleccionada.text
                }

                var codigo = "MC"
                var id = wrapper.managerCuentaAlumno.crearMovimiento(selectorOperacion.idTipoOperacionSeleccionado, -1, txtMontoIngresado.text,tipoMasComentario,cuenta_alumno,resumen_mes_alumno,codigo,true)
                if (id !== -1) {
                    //Movimiento y actualizacion de cuenta exitosa
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    messageDialog.text = "Perfecto, ya registramos los cambios."
                    messageDialog.icon = StandardIcon.Information
                }else{
                    //Movimiento fallo
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                    messageDialog.text = "Algo no anda bien con el registro del movimiento de dinero.\nEs necesario que reportes este problema!"
                    messageDialog.icon = StandardIcon.Critical
                }
                messageDialog.open()
                limpiar()
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Administrar saldo"
    }
}
