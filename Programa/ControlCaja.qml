import QtQuick.Controls 1.4
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

    property int textFieldHeight: 35
    property int textFieldPixelSize : 15
    property string textFieldFontFamily : "verdana"
    property color textFieldTextColor : "#585858"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    property var record_ultima_caja: null

    property real ingresos_adultos: 0
    property real ingresos_infantiles: 0
    property real ingresos_tienda: 0
    property real ingresos_tesoreria: 0

    property real egresos_tesoreria: 0

    property real ingresos_totales: 0
    property real egresos_totales: 0

    property real caja_inicial: 0

    property real caja_esperada: 0

    property string strFechaInicioCaja: ""

    Component.onCompleted: {
        inicializar()
    }

    function inicializar() {
        ingresos_adultos =  0
        ingresos_infantiles =  0
        ingresos_tienda =  0
        ingresos_tesoreria =  0

        egresos_tesoreria =  0

        ingresos_totales =  0
        egresos_totales =  0

        caja_inicial =  0

        caja_esperada =  0

        record_ultima_caja = wrapper.managerCaja.traer_ultima_caja()
        habilitar_apertura_caja(true)
        if (record_ultima_caja !== null){
            if (record_ultima_caja.estado == "Abierta"){
                habilitar_apertura_caja(false)
                ingresos_adultos = wrapper.managerCaja.traerIngresosAbonoAdulto(record_ultima_caja.fecha_inicio)
                ingresos_infantiles = wrapper.managerCaja.traerIngresosAbonoInfantil(record_ultima_caja.fecha_inicio)
                ingresos_tienda = wrapper.managerCaja.traerIngresosTienda(record_ultima_caja.fecha_inicio)
                ingresos_tesoreria = wrapper.managerCaja.traerIngresosTesoreria(record_ultima_caja.fecha_inicio)

                egresos_tesoreria = wrapper.managerCaja.traerEgresosTesoreria(record_ultima_caja.fecha_inicio)

                ingresos_totales = wrapper.managerCaja.traerIngresosTotales(record_ultima_caja.fecha_inicio)
                egresos_totales = wrapper.managerCaja.traerEgresosTotales(record_ultima_caja.fecha_inicio)

                caja_inicial = record_ultima_caja.monto_inicial

                caja_esperada = (ingresos_totales - egresos_totales)+caja_inicial

                strFechaInicioCaja = Qt.formatDateTime(record_ultima_caja.fecha_inicio,"dddd dd/MM HH:mm")+"hs."
            }
        }
        traer_cajas()
    }

    function traer_cajas() {
        tableCaja.model = wrapper.managerCaja.obtener_registros_caja();
        //tableCaja.resizeColumnsToContents()
    }

    function habilitar_apertura_caja(estado) {
        txtComentarioApertura.visible = estado
        txtMontoInicial.visible = estado
        btnComenzar.visible = estado

        btnCancelarControlCaja.visible = !estado
        txtComentarioCierre.visible = !estado
        txtMontoFinal.visible = !estado
        btnCerrarCaja.visible = !estado
        btnRecargar.visible = !estado
        lblFechaInicioCaja.visible = !estado
    }

    WrapperClassManagement {
        id: wrapper
    }

    MessageDialog {
        id: messageDialogYesNoAnularCaja
        title: "Tesorería"
        text: "¿Seguro querés cancelar el control de caja en curso?\nRecordá que también podés escribir un comentario tal como lo hubieras hecho en un cierre de caja normal."
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question

        onYes: {
            if (wrapper.managerCaja.anular_caja(record_ultima_caja.id,txtComentarioCierre.text)){
                inicializar()
            }else {
                messageDialog.text = "Ups, parece que algo salió mal. Verificá lo ingresado y volvé a intentar."
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
            }
        }
    }

    MessageDialog {
        id: messageDialogYesNoAbirCaja
        title: "Tesorería"
        text: "¿Comenzar?"
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question

        onYes: {
            if (wrapper.managerCaja.iniciar_caja(txtMontoInicial.text,txtComentarioApertura.text)){
                inicializar()
            }else{
                messageDialog.text = "Ups, parece que algo salió mal. Verificá lo ingresado y volvé a intentar."
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
            }
        }
    }

    MessageDialog {
        id: messageDialogYesNoCerrarCaja
        title: "Tesorería"
        text: "Por favor, verificá nuevamente el valor de caja esperada y el valor de caja final ingresado.\n¿Seguro querés cerrar la caja?"
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question

        onYes: {
            if (wrapper.managerCaja.cerrar_caja(record_ultima_caja.id,record_ultima_caja.monto_inicial,txtMontoFinal.text,caja_esperada,txtComentarioCierre.text)){
                inicializar()
            }
            else {
                messageDialog.text = "Ups, parece que algo salió mal. Verificá lo ingresado y volvé a intentar."
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Tesorería"
    }

    TableView {
        id: tableCaja
        z:1
        anchors{
            top:parent.top
            right: parent.right
            bottom: parent.bottom
            left: scroll.right
            leftMargin: -1
            bottomMargin: -1
            topMargin: -1
        }
        opacity: 1
        Behavior on opacity {PropertyAnimation{duration:50}}


        onOpacityChanged: {
            if (opacity < 0.71){
                opacity = 1
            }
        }

        TableViewColumn {
            role: "id"
            title: "Nro"
            width: 45
        }

        TableViewColumn {
            role: "estado"
            title: "Estado"
            width: 75
        }

        TableViewColumn {
            role: "monto_inicial"
            title: "Inicial"
            width: 65

            delegate: Item {
                Text {
                    x: 1
                    text: "$ "+styleData.value
                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "monto_final"
            title: "Final"
            width: 65

            delegate: Item {
                Text {
                    x: 1
                    //text:
                    text: {
                        if (tableCaja.model.length > 0){
                            tableCaja.model[styleData.row].estado == "Cerrada" ? "$ "+styleData.value : ""
                        }
                        else {
                            ""
                        }
                    }
                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }

        /*TableViewColumn {
            role: "monto_segun_sistema"
            title: "Sistema"
            width: 65

            delegate: Item {
                Text {
                    x: 1
                    text: tableCaja.model[styleData.row].estado == "Cerrada" ? "$ "+styleData.value : ""
                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }*/

        TableViewColumn {
            role: "diferencia_monto"
            title: "Resultado"
            width: 90

            delegate: Item {
                Text {
                    x: 1
                    //text: tableCaja.model[styleData.row].estado == "Cerrada" ? "$ "+styleData.value : ""
                    text: {
                        if (tableCaja.model.length>0){
                            if (tableCaja.model[styleData.row].estado == "Cerrada") {
                                if (styleData.value > 0){
                                    "Faltarían $ " + styleData.value
                                }else if (styleData.value == 0){
                                    "Excelente"
                                }else {
                                    "Sobran $ " + (styleData.value)*-1
                                }
                            }else{
                                ""
                            }
                        }else{
                            ""
                        }
                    }

                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "fecha_inicio"
            title: "Fecha apertura"

            delegate: Item {
                Text {
                    x: 1
                    //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                    text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "fecha_cierre"
            title: "Fecha cierre"

            delegate: Item {
                Text {
                    x: 1
                    //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                    //text: tableCaja.model[styleData.row].estado != "Abierta" ? wrapper.classManagementManager.calcularTiempoPasado(styleData.value) : ""
                    text: {
                        if (tableCaja.model.length > 0){
                            tableCaja.model[styleData.row].estado != "Abierta" ? wrapper.classManagementManager.calcularTiempoPasado(styleData.value) : ""
                        }
                        else {
                            ""
                        }
                    }

                    color: styleData.selected && tableCaja.focus ? "white" : "black"
                }
            }
        }

        TableViewColumn {
            role: "comentario"
            title: "Comentario"
        }
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 300
        anchors.left: parent.left
        //anchors.bottom: btnRegistrarMovimiento.top
        anchors.leftMargin: -1
        anchors.topMargin: -1
        anchors.bottomMargin: 10
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

            onOpacityChanged: {
                if (opacity < 0.71){
                    opacity = 1
                }
            }


            Behavior on opacity {PropertyAnimation{duration:50}}

            TextField {
                id: txtComentarioApertura
                height: textFieldHeight
                width: 300
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                horizontalAlignment: TextInput.AlignRight
                placeholderText: "Comentario de apertura... (opcional)"
                maximumLength: 255
            }

            Row {
                TextField {
                    id: txtMontoInicial
                    height: textFieldHeight
                    width: 150
                    font.pixelSize: textFieldPixelSize
                    font.family: textFieldFontFamily
                    horizontalAlignment: TextInput.AlignRight
                    placeholderText: "caja inicial $"
                    maximumLength: 5
                    validator: DoubleValidator {}
                    property bool validado : false

                    onTextChanged: {
                        text = text.replace(",","")
                        text = text.replace(".","")
                        text = text.replace("-","")

                        validado = text.length > 0
                    }
                }

                Button {
                    id: btnComenzar
                    text: qsTrId("Iniciar caja")
                    width: 150
                    height: textFieldHeight
                    enabled: txtMontoInicial.length > 0
                    //iconSource: "qrc:/media/Media/icon-play.png"

                    onClicked: {
                        messageDialogYesNoAbirCaja.open()
                    }
                }
            }

            TextField {
                id: txtComentarioCierre
                height: textFieldHeight
                font.pixelSize: textFieldPixelSize
                font.family: textFieldFontFamily
                width: 300
                horizontalAlignment: TextInput.AlignRight
                placeholderText: "Comentario de cierre... (opcional)"
                maximumLength: 255
            }

            Row {
                TextField {
                    id: txtMontoFinal
                    height: textFieldHeight
                    width: 150
                    font.pixelSize: textFieldPixelSize
                    font.family: textFieldFontFamily
                    horizontalAlignment: TextInput.AlignRight
                    placeholderText: "caja final $"
                    maximumLength: 5
                    validator: DoubleValidator {}
                    property bool validado : false

                    onTextChanged: {
                        text = text.replace(",","")
                        text = text.replace(".","")
                        text = text.replace("-","")

                        validado = text.length > 0

                        inicializar()
                    }
                }

                Button {
                    id: btnCerrarCaja
                    text: qsTrId("Cerrar caja")
                    width: 150
                    height: textFieldHeight
                    enabled: txtMontoFinal.length > 0
                    //iconSource: "qrc:/media/Media/icon-stop.png"

                    onClicked: {
                        inicializar()
                        messageDialogYesNoCerrarCaja.open()
                    }
                }

            }

            Text {
                id: lblFechaInicioCaja
                text: "Inicio caja: " + strFechaInicioCaja
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }


            Row {
                width: flickDatos.width - 3
                height: btnCancelarControlCaja.height
                layoutDirection: Qt.RightToLeft
                spacing: 10

                ToolButton {
                    id: btnRecargar
                    y: -8
                    iconSource: "qrc:/media/Media/icon-reload.png"

                    onClicked: {
                        inicializar()
                        columnaDatos.opacity = 0.7
                        tableCaja.opacity = 0.7
                    }
                }

                Text{
                    id: btnCancelarControlCaja
                    color: "blue"
                    text: "cancelar control de caja"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: parent.enabled

                        onEntered:
                            parent.font.underline = true
                        onExited:
                            parent.font.underline = false
                        onClicked: {
                            messageDialogYesNoAnularCaja.open()
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
                    text: qsTrId("Ingresos desde el inicio de caja")
                    color: colorSubtitles
                }
            }


            Text {
                id: lblIngresosAbonoAdulto
                text: "Adultos: \t$ " + ingresos_adultos
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }

            Text {
                id: lblIngresosAbonoInfantil
                text: "Niños: \t$ " + ingresos_infantiles
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }

            Text {
                id: lblIngresosTesoreria
                text: "Tesorería: \t$ " + ingresos_tesoreria
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }

            Text {
                id: lblIngresosTienda
                text: "Tienda: \t$ " + ingresos_tienda
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
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
                    text: qsTrId("Egresos desde el inicio de caja")
                    color: colorSubtitles
                }
            }

            Text {
                id: lblEgresosTesoreria
                text: "Tesorería: \t$ " + egresos_tesoreria
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
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
                    text: qsTrId("Valor de caja esperado")
                    color: colorSubtitles
                }
            }

            Text {
                id: lblCajaInicial
                text: "Caja inicial: \t$ " + caja_inicial
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }

            Text {
                id: lblIngresosTotales
                text: "Ingresos: \t\t$ " + ingresos_totales
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }

            Text {
                id: lblEgresosTotales
                text: "Egresos: \t\t$ " + egresos_totales
                font.family: "verdana";
                font.pixelSize: 14
                color: "red"
                x: columnaDatos.separacionIzquierda *3
            }

            LineaSeparadora{
                width: flickDatos.width
            }

            Text {
                id: lblCajaEsperada
                text: "Caja esperada: \t$ " + caja_esperada
                font.family: "verdana";
                font.pixelSize: 14
                x: columnaDatos.separacionIzquierda *3
            }
        }
    }


}
