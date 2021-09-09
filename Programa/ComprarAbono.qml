import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property color backColorSubtitles: "#BBDEFB"
    property color colorSubtitles: "black"
    property variant p_objPestania
    property bool quieroLaFechaInicial : true
    property string tipo : "Normal"
    property int cantidad_comprada : -1
    property int cantidad_acreditada : -1
    property int duracionDeAbono : 30
    property string fechaInicial: ""; property string fechaFinal: ""
    property string strSinInformacion: qsTrId("\tSin información disponible.")
    property string strNoAbono : qsTrId("\tNo existe ningún abono vigente a la fecha o a futuro del alumno/a.")
    property int cantidadDeClasesEnDeuda : 0

    property string strAlDiaDeuda : qsTrId("\tNinguna")
    property string strDeuda : cantidadDeClasesEnDeuda + " clase/s. Debe comprar un abono de "+cantidadDeClasesEnDeuda+" o más clases, o un abono libre"

    property int idAbonoAdultoSeleccionado: -1
    property var precioAbono : ""
    property var varDeuda : ""
    property var varAfavor : ""
    property var varGeneral: ""
    property var varSaldoConMontoIngresado: ""

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    Behavior on opacity {PropertyAnimation{}}

    Component.onCompleted: {
        wrapper.managerAbono.traerTodosLasOfertasDeAbono()
    }

    WrapperClassManagement {
        id: wrapper
    }

    function switchOnOffDatos(logico) {
        if (logico) {
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
            txtFechaInicial.text = Qt.formatDate(wrapper.classManagementManager.obtenerFecha(),"dd/MM/yyyy")
            txtFechaFinal.text = Qt.formatDate(wrapper.managerAbono.obtenerFechaDeVencimiento(),"dd/MM/yyyy")
        }
        else {
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
        }
    }

    function calcularDuracionDeAbono() {
        var dateInicial = wrapper.classManagementManager.obtenerFecha(fechaInicial)
        var dateFinal = wrapper.classManagementManager.obtenerFecha(fechaFinal)
        duracionDeAbono = wrapper.classManagementManager.obtenerDiferenciaDias(dateInicial,dateFinal)
    }

    Connections {
        target: principal.enabled ? wrapper.managerAbono : null
        ignoreUnknownSignals: true

        onSig_abonosDeAlumno: {
            selectorDeAbono.p_modelAbonos = arg
            selectorDeAbono.visible = true
        }

        onSig_noHayAbonosDelAlumno: {
            selectorDeAbono.p_modelAbonos = 0
            selectorDeAbono.visible = false
            lblAbonosVigentesDisponibles.text = strNoAbono
        }
    }

    Connections {
        target: wrapper.managerAbono

        onSig_listaAbonosAdultosEnOferta: {
            var x;
            for (x=0;x<lista.length;x++){
                if (lista[x].estado === "Habilitado"){
                    if (lista[x].total_clases === 1){
                        radio1.info = lista[x]
                    }
                    else if (lista[x].total_clases === 4){
                        radio4.info = lista[x]
                        radio4.checked = true
                    }
                    else if (lista[x].total_clases === 8){
                        radio8.info = lista[x]
                    }
                    else if (lista[x].total_clases === 12){
                        radio12.info = lista[x]
                    }
                    else if (lista[x].total_clases === 16){
                        radio16.info = lista[x]
                    }
                    else if (lista[x].total_clases === 99){
                        radioLibre.info = lista[x]
                    }
                }
            }
        }
    }

    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        ignoreUnknownSignals: true

        onSig_listaClaseAsistencias: {
            tablaPresentes.model = arg
            tablaPresentes.resizeColumnsToContents()
        }
    }

    function limpiarFormulario() {
        radioRegistrarPagoAbono.checked = true
        selectorDeAbono.visible = false
        lblAbonosVigentesDisponibles.text = strSinInformacion
        txtFechaInicial.text = ""
        txtFechaFinal.text = ""
        switchOnOffDatos(false)
        tablaPresentes.model = 0
        detallesDelCliente.aliasCalendarVisible = false
        saldoMovimientos.tableViewMovimientos.model = 0
        cantidadDeClasesEnDeuda = 0
        buscador.focoEnDNI()
        if (buscador.recordClienteSeleccionado !== null)
            buscador.onClienteSeleccionado()
    }

    /*
    function limpiarFormulario() {
        selectorDeAbono.visible = false
        lblAbonosVigentesDisponibles.text = strSinInformacion
        //cantidad_comprada = -1
        //buscador.modeloAlumnos = 0
        txtFechaInicial.text = ""
        txtFechaFinal.text = ""
        switchOnOffDatos(false)
        //deschequear();
        tablaPresentes.model = 0
        detallesDelCliente.aliasCalendarVisible = false
        saldoMovimientos.tableViewMovimientos.model = 0
        cantidadDeClasesEnDeuda = 0
        buscador.recordClienteSeleccionado = null
        buscador.focoEnDNI()
    }

*/


    function deschequear() {
        radio1.checked = false
        radio4.checked = false
        radio8.checked = false
        radio12.checked = false
        radio16.checked = false
        radioLibre.checked = false
    }

    MessageDialog {
        id: messageDialog
        title: "Adultos"
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

        function onClienteSeleccionado(){
            cuenta_alumno = null
            if (recordClienteSeleccionado !== null) {
                wrapper.gestionBaseDeDatos.beginTransaction()
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                if (cuenta_alumno !== null) {
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id)
                    saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()

                    wrapper.gestionBaseDeDatos.beginTransaction()
                    resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                    if (resumen_mes_alumno !== null) {
                        wrapper.gestionBaseDeDatos.commitTransaction()
                    }
                }

                //(int id_cliente, bool estado, bool incluirAbonosCompradosEnElFuturo = false, bool incluirAbonosConCeroClases = false, QString fecha = QDate::currentDate().toString("yyyy-MM-dd"));
                wrapper.managerAbono.obtenerAbonosPorClienteMasFecha(recordClienteSeleccionado.id,true,true,true)

                cantidadDeClasesEnDeuda = wrapper.managerAsistencias.obtenerClasesSinPagarPorAlumno(recordClienteSeleccionado.id)
                if (cantidadDeClasesEnDeuda > 0){
                    tableColumnDeudaClases.visible = true
                    txtCuentaAlumno.text = strDeuda
                }
                else{
                    tableColumnDeudaClases.visible = false
                    txtCuentaAlumno.text = strAlDiaDeuda
                }
                //cantidad_comprada = -1
                detallesDelCliente.aliasCalendarVisible = false
                //deschequear();
                tablaPresentes.model = 0
                wrapper.managerAsistencias.obtenerPresentesDelAlumno(recordClienteSeleccionado.id, 3)
                switchOnOffDatos(true)
            }
            else {
                limpiarFormulario()
            }
        }

        onRecordClienteSeleccionadoChanged: {
            onClienteSeleccionado()
        }
    }

    function deshacerFecha() {
        txtFechaInicial.text = txtFechaInicial.lastDate
        txtFechaFinal.text = txtFechaFinal.lastDate
    }

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: btnRegistrarPago.top
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.bottomMargin: 10
    }

    Flickable {
        id: flickDatos
        parent: scroll
        anchors.fill: scroll
        contentHeight: columnaDatos.height
        contentWidth: columnaDatos.width
        clip: true

        Rectangle {
            id: recOcultar
            anchors.fill: parent
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

        Column {
            id: columnaDatos
            spacing: 10
            opacity: 0
            enabled: false
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
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Abonos vigentes y/o próximamente vigentes del alumno/a con o sin clases")
                }
            }

            Text {
                id: lblAbonosVigentesDisponibles
                font.family: "verdana"
                font.pixelSize: 12
                text: strSinInformacion
                visible: !selectorDeAbono.visible
            }

            SelectorDeAbono {
                id: selectorDeAbono
                width: flickDatos.width
                height: 148
                visible: false
                mostrarLeyendaDeVigentes: true
                permitirEliminar: true
            }

            TableView {
                id: tablaPresentes
                height: 85
                width: flickDatos.width

                TableViewColumn {
                    role: "id"
                    title: "Nro"
                    width: 45
                }

                TableViewColumn {
                    role: "nombre_actividad"
                    title: "Actividad"
                    width: 100
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
                    width: 100
                    delegate: Item {
                        Text {
                            x: 1
                            text: styleData.value
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    id: tableColumnDeudaClases
                    role: "clase_debitada"
                    title: "Clase tomada con abono"
                    visible: false

                    delegate: Item {
                        Image {
                            x: 1
                            source: {
                                if (styleData.value == "Si")
                                    "qrc:/media/Media/icoyes.png"
                                else if(styleData.value == "No")
                                    "qrc:/media/Media/icono.png"
                                else
                                    ""
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "credencial_firmada"
                    title: "Firma"
                    width: 33

                    delegate: Item {
                        Image {
                            x: 1
                            source: {
                                if (styleData.value == "Si")
                                    "qrc:/media/Media/icoyes.png"
                                else if(styleData.value == "No")
                                    "qrc:/media/Media/icono.png"
                                else
                                    ""
                            }
                        }
                    }
                }

                TableViewColumn {
                    role: "fecha"
                    title: "Fecha últimos 3 presentes"
                    width: 230
                    delegate: Item {
                        Text {
                            x: 1
                            //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                            text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
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
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Confirmar la duración del abono: ") + duracionDeAbono + qsTrId(" días.")
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
                        text: qsTrId("Válido desde")
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
                            calcularDuracionDeAbono()
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
                        text: qsTrId("Fecha de vencimiento")
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
                            calcularDuracionDeAbono()
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

            ExclusiveGroup {
                id: groupNormalizacion
            }

            Rectangle {
                height: 29
                width: flickDatos.width
                color: backColorSubtitles
                visible: cantidadDeClasesEnDeuda > 0              //Desde v5.1 cae practicamente en desuso

                Text {
                    id: lblCuentaAlumno
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Total asistencias a clases del alumno/a sin respaldo de abono")
                    visible: true
                    width: 250
                    anchors.leftMargin: columnaDatos.separacionIzquierda
                }
            }

            Row {
                spacing: 5
                visible: cantidadDeClasesEnDeuda > 0
                x: 3

                Text {
                    id: txtCuentaAlumno
                    font.family: "verdana"
                    font.pixelSize: 12
                    visible: true
                    y: 2
                    text: strSinInformacion
                }

                Image {
                    width: 16
                    height: width
                    visible: cantidadDeClasesEnDeuda > 0  //Desde v5.1 no se usa mas
                    source: {
                        if (txtCuentaAlumno.text === strDeuda) {
                            "qrc:/media/Media/warning_sign.png"
                        }
                        else if (txtCuentaAlumno.text === strAlDiaDeuda){
                            "qrc:/media/Media/icoyes.png"
                        }
                        else {
                            ""
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
                    font.family: "verdana"; color: colorSubtitles;
                    font.pixelSize: 14
                    text: qsTrId("Tipo de abono a comprar")
                }
            }

            ExclusiveGroup {
                id: group
            }

            ExclusiveGroup {
                id: groupFormasDePago
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 10

                RadioButton {
                    id: radio1
                    property string normalText: "1 clase"
                    exclusiveGroup: group
                    text: normalText
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Normal"
                            cantidad_comprada = 1
                            cantidad_acreditada = 1
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
                        }
                    }
                }

                RadioButton {
                    id: radio4
                    property string normalText: "4 clases"
                    exclusiveGroup: group
                    text: normalText
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Normal"
                            cantidad_comprada = 4
                            cantidad_acreditada = 4
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
                        }
                    }
                }

                RadioButton {
                    id: radio8
                    property string normalText: "8 clases"
                    exclusiveGroup: group
                    text: normalText
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Normal"
                            cantidad_comprada = 8
                            cantidad_acreditada = 8
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
                        }
                    }
                }

                RadioButton {
                    id: radio12
                    property string normalText: "12 clases"
                    exclusiveGroup: group
                    text: normalText
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Normal"
                            cantidad_comprada = 12
                            cantidad_acreditada = 12
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
                        }
                    }
                }

                RadioButton {
                    id: radio16
                    property string normalText: "16 clases"
                    exclusiveGroup: group
                    text: normalText
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Normal"
                            cantidad_comprada = 16
                            cantidad_acreditada = 16
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
                        }
                    }
                }

                RadioButton {
                    id: radioLibre
                    text: "Abono libre"
                    exclusiveGroup: group
                    enabled: false
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            tipo = "Libre"
                            cantidad_comprada = 99
                            cantidad_acreditada = 99
                            idAbonoAdultoSeleccionado = info.id
                            precioAbono = info.precio_actual
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
                    text: "Registrar pago del alumno"
                    color: colorSubtitles
                }
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                font.underline: true
                color: colorSubtitles
                x: columnaDatos.separacionIzquierda *3
                text: "Precio del abono:"
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                visible: !isNaN(parseFloat(precioAbono))
                x: columnaDatos.separacionIzquierda *3
                text: "$ " + precioAbono
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                color: colorSubtitles
                x: columnaDatos.separacionIzquierda *3
                font.underline: cuenta_alumno !== null
                text: {
                    if (cuenta_alumno !== null){
                        "Saldo en cuenta del alumno/a:"
                    }
                    else {
                        ""
                    }
                }
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                visible: cuenta_alumno !== null
                x: columnaDatos.separacionIzquierda *3
                property string frase: ""
                text: {
                    if (cuenta_alumno !== null){
                        "$ " + cuenta_alumno.credito_actual + frase
                    }
                    else{
                        ""
                    }
                }
                color:{
                    if (cuenta_alumno !== null) {
                        if (cuenta_alumno.credito_actual > 0){
                            frase = " (dinero a favor)"
                            "green"
                        }else if (cuenta_alumno.credito_actual < 0){
                            frase = " (en deuda)"
                            "red"
                        }
                        else {
                            frase = " (al día)"
                            "black"
                        }
                    }else{
                        "black"
                    }
                }
            }

            LineaSeparadora {
                width: flickDatos.width
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                visible: (cuenta_alumno !== null)  && !isNaN(parseFloat(precioAbono))
                x: columnaDatos.separacionIzquierda *3
                text: "Total a abonar:"
                font.underline: true
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                color: colorSubtitles
                property real credito_actual
                visible: (cuenta_alumno !== null)  && !isNaN(parseFloat(precioAbono))
                x: columnaDatos.separacionIzquierda *3
                text: {
                    if (cuenta_alumno !== null){
                        credito_actual = cuenta_alumno.credito_actual
                        varGeneral = credito_actual - precioAbono
                        if (credito_actual >= precioAbono){
                            varAfavor = credito_actual - precioAbono
                            color = "green"
                            radioDebitarDeCuenta.info = credito_actual === precioAbono ? "-> quedará al día " : "-> quedarán a favor $ " + varAfavor
                            "Nada! La cuenta del alumno/a cubre el precio del abono."
                        }
                        else{
                            varDeuda = precioAbono - credito_actual
                            color = "red"
                            if (credito_actual < 0) {
                                radioDebitarDeCuenta.info = "-> la deuda ascenderá a $ " + varDeuda
                                "$ " + varDeuda
                            }
                            else {
                                radioDebitarDeCuenta.info = "-> generará una deuda por $ " + varDeuda
                                "$ " + varDeuda
                            }
                        }
                    }
                    else {
                        ""
                    }
                }
            }

            RadioButton {
                id: radioDebitarDeCuenta
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                text: "Usar cuenta " + info
                visible: (cuenta_alumno !== null) && precioAbono !== ""
                property string info: ""
            }

            RadioButton {
                id: radioRegistrarPagoAbono
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                checked: true
                visible: (cuenta_alumno !== null) && precioAbono !== ""
                text: "Recibo $ " + precioAbono + " por el abono"
            }

            RadioButton {
                id: radioRegistrarPagoDiferencia
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual > 0 && varGeneral < 0
                text: "Recibo $ " + varDeuda + " por lo que queda por pagar"
            }

            RadioButton {
                id: radioRegistrarPagoTotal
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual < 0 && precioAbono !== ""
                text: "Recibo $ " + varDeuda + " por el abono y la deuda"
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 15
                visible: (cuenta_alumno !== null) && precioAbono !== ""

                RadioButton {
                    id: radioRegistrarPagoPersonalizado
                    x: columnaDatos.separacionIzquierda *3
                    exclusiveGroup: groupFormasDePago
                    text: "Recibo el siguiente monto: $ "
                }

                TextField {
                    id: txtMontoIngresado
                    enabled: radioRegistrarPagoPersonalizado.checked
                    font.family: "verdana";
                    font.pixelSize: 14
                    horizontalAlignment: TextInput.AlignRight
                    width: 100
                    text: "0"
                    maximumLength: 5
                    validator: DoubleValidator {bottom: 0}

                    onTextChanged: {
                        text = text.replace(",","")
                        text = text.replace(".","")
                    }
                }

                Text {
                    verticalAlignment: Text.AlignVCenter
                    font.family: "verdana";
                    font.pixelSize: 12
                    visible: radioRegistrarPagoPersonalizado.checked && radioRegistrarPagoPersonalizado.enabled
                    text: {
                        if (varGeneral !== ""){
                            if (!isNaN(parseFloat(txtMontoIngresado.text))) {
                                varSaldoConMontoIngresado = varGeneral + parseFloat(txtMontoIngresado.text)
                            }
                            else {
                                varSaldoConMontoIngresado = varGeneral
                            }
                            "Saldo resultante: $ " + varSaldoConMontoIngresado
                        }
                        else {
                            ""
                        }
                    }
                    color: colorSubtitles
                }

            }

            SaldoMovimientos {
                id: saldoMovimientos
                height: 120
                width: flickDatos.width
            }

        }
    }

    Button {
        id: btnRegistrarPago
        text: qsTrId("Registrar pago")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: duracionDeAbono > 0 && !detallesDelCliente.aliasCalendarVisible

        onClicked: {
            cantidad_acreditada = cantidad_comprada - cantidadDeClasesEnDeuda

            if (cantidad_acreditada < 0){
                messageDialog.text = "Debe comprar un abono libre o un abono de " + cantidadDeClasesEnDeuda + " o más clases.\nEsto se debe a que, en su momento, el alumno había asistido a clases sin el respaldo de un abono."
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
            }
            else{
                wrapper.gestionBaseDeDatos.beginTransaction()

                if (cantidadDeClasesEnDeuda>0)
                    wrapper.managerAsistencias.normalizarCuentaDeAlumno(buscador.recordClienteSeleccionado.id)

                if (radioLibre.checked)
                    cantidad_acreditada = 99

                //(int id_cliente, int id_abono_adulto, float precio_abono, QString fecha_vigente, QString fecha_vencimiento, QString tipo, int cantidad_comprada, int cantidad_acreditada)

                var id_abono_adulto_compra = wrapper.managerAbono.comprarAbono(buscador.recordClienteSeleccionado.id, group.current.info.id, group.current.info.precio_actual, txtFechaInicial.text, txtFechaFinal.text,tipo,cantidad_comprada, cantidad_acreditada)
                var codigo_oculto_movimiento = "AAA"+id_abono_adulto_compra

                var id_movimiento

                if (radioDebitarDeCuenta.checked){
                    console.debug("radioDebitarDeCuenta")

                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono adulto "+group.current.text,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                }
                else if(radioRegistrarPagoAbono.checked){
                    console.debug("radioRegistrarPagoAbono")
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAA"+id_abono_adulto_compra) //Comprar Abono Adulto
                    if (id_movimiento !== -1) {

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono adulto "+group.current.text,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    }
                }
                else if (radioRegistrarPagoDiferencia.checked || radioRegistrarPagoTotal.checked) {
                    console.debug("radioRegistrarPagoDiferencia")
                    var texto = "Carga diferencia"
                    var codigo = "CSAA"+id_abono_adulto_compra
                    if (radioRegistrarPagoTotal.checked) {
                        texto = "Carga por el abono y la deuda"
                    }
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,varDeuda,texto,cuenta_alumno,resumen_mes_alumno,codigo) //Comprar Abono Adulto Paga Deuda
                    if (id_movimiento !== -1) {

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono adulto "+group.current.text,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    }
                }
                else if (radioRegistrarPagoPersonalizado.checked) {
                    console.debug("radioRegistrarPagoPersonalizado")
                    if (txtMontoIngresado.length > 0) {

                        var montoIngresado = txtMontoIngresado.text

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,montoIngresado,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAA"+id_abono_adulto_compra) //Comprar Abono Adulto
                        if (id_movimiento !== -1) {

                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono adulto "+group.current.text,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                        }
                    }
                }

                if (id_movimiento !== -1 && id_abono_adulto_compra !== -1) {
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                    messageDialog.text = "Compra de abono adulto Nº "+id_abono_adulto_compra+" exitosa.\n" + strDatosDelRegistroDePresente
                    messageDialog.icon = StandardIcon.Information
                }
                else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                    messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                    messageDialog.icon = StandardIcon.Warning
                }
                messageDialog.open()
                limpiarFormulario()
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

        onSig_hoveredFecha: {
            quieroLaFechaInicial ? txtFechaInicial.text = Qt.formatDate(date, "dd/MM/yyyy") : txtFechaFinal.text = Qt.formatDate(date, "dd/MM/yyyy")
        }

        onSig_clickedFecha: {
            if (duracionDeAbono > 0)
                aliasCalendarVisible = false
        }
    }
}
