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
        enabled: !selectorOperacion.enabled

        /*onRecordClienteSeleccionadoChanged: {
            cuenta_alumno = null
            limpiar()
            if (recordClienteSeleccionado !== null) {
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                if (cuenta_alumno === null) {
                    var id_alumno_cuenta = wrapper.managerCuentaAlumno.crearCuentaAlumno(recordClienteSeleccionado.id)
                    if (id_alumno_cuenta !== -1){
                        cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                        if (cuenta_alumno !== null) {
                            console.debug("credito_actual: " + cuenta_alumno.credito_actual);
                        }
                    }
                }
            }
            else {
                //switchOnOffDatos(false)
            }
        }*/

        onRecordClienteSeleccionadoChanged: {
            cuenta_alumno = null
            limpiar()
            if (recordClienteSeleccionado !== null) {
                wrapper.gestionBaseDeDatos.beginTransaction()
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                if (cuenta_alumno !== null) {
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    wrapper.gestionBaseDeDatos.beginTransaction()
                    resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                    if (resumen_mes_alumno !== null) {
                        saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id, -1)
                        saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()
                        wrapper.gestionBaseDeDatos.commitTransaction()
                    }
                }
                else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                }
            }
            else {
                //switchOnOffDatos(false)
            }
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
        enabled: !selectorOperacion.enabled
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: btnRegistrarMovimiento.top
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
                    text: qsTrId("Saldo actual")
                    color: colorSubtitles
                }
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 15

                Text {
                    font.family: "verdana";
                    font.pixelSize: cuenta_alumno === null ? 14 : 28
                    color:{
                        if (cuenta_alumno !== null) {
                            if (cuenta_alumno.credito_actual >=0){
                                "green"
                            }else{
                                "red"
                            }
                        }else{
                            "black"
                        }
                    }
                    text: cuenta_alumno === null ? "Sin información disponible" : "$ " + cuenta_alumno.credito_actual
                }

                Text {
                    y: 12
                    font.family: "verdana";
                    font.pixelSize: 14
                    text: {
                        if (cuenta_alumno !== null) {
                            if (cuenta_alumno.credito_actual > 0) {
                                "Alumno/a con dinero a favor"
                            }
                            else if (cuenta_alumno.credito_actual === 0 ){
                                "Alumno/a al día"
                            }
                            else {
                                "Alumno/a con deuda"
                            }
                        }
                        else {
                            "";
                        }
                    }
                }
            }

            SaldoMovimientos {
                id: saldoMovimientos
                height: 200
                width: flickDatos.width
                mostrarTextoRecientes: false
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
                    text: qsTrId("Cargue o debite saldo (use signo negativo para debitar. Ej: $ -250)")
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
                    enabled: cuenta_alumno !== null
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

                Row {
                    id: recProbableSaldo
                    anchors.left: txtMontoIngresado.right
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    spacing: 3

                    Text {
                        verticalAlignment: Text.AlignVCenter
                        font.family: "verdana";
                        font.pixelSize: 18
                        text: "Saldo resultante: $ "
                        color: colorSubtitles
                    }

                    Text{
                        id: lblSaldoResultante
                        color: text < 0 ? "red" : "green"
                        font.family: "verdana";
                        font.pixelSize: 18
                        text: isNaN(parseFloat(txtMontoIngresado.text)) ? (cuenta_alumno !== null ? parseFloat(cuenta_alumno.credito_actual):""): ( cuenta_alumno !== null ? parseFloat(cuenta_alumno.credito_actual) + parseFloat(txtMontoIngresado.text):"")
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
                        enabled: cuenta_alumno !== null
                        font.family: "verdana";
                        readOnly: true
                        placeholderText: "Especifique el tipo de operación"
                    }

                    Button {
                        text: "Tipo de operación"
                        height: 30
                        width: 175
                        enabled: !selectorOperacion.enabled && cuenta_alumno !== null

                        onClicked: {
                            selectorOperacion.enabled = true
                        }
                    }
                }
            }

            CheckBox {
                id: checkEsAjuste
                x: columnaDatos.separacionIzquierda
                text: "Tildar si con este movimiento no estás sacando plata de caja o no estás ingresando plata a caja. Ej:
- Acreditás saldo a un alumno sin que aquel te haya pagado algo. Podría ser una bonificación.
- Le debitás saldo a un alumno por razones extraordinarias. Podría ser una penalización."
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
                    enabled: cuenta_alumno !== null
                    font.family: "verdana";
                    placeholderText: "Escriba aquí"
                }
            }
        }
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
        enabled: !selectorOperacion.enabled && cuenta_alumno !== null

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

                var codigo = "OM"
                if (checkEsAjuste.checked)
                    codigo = "OMX"
                var id = wrapper.managerCuentaAlumno.crearMovimiento(selectorOperacion.idTipoOperacionSeleccionado, cuenta_alumno.id, txtMontoIngresado.text,tipoMasComentario,cuenta_alumno,resumen_mes_alumno,codigo)
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
