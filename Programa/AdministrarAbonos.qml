import QtQuick.Controls 1.3
import "qrc:/components"
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2
import com.mednet.ClaseAsistencia 1.0

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property color backColorSubtitles: "#BBDEFB"
    property color colorSubtitles: "black"

    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    property int cantidadDeClasesEnDeuda : 0
    property bool quieroLaFechaInicial : true
    property string fechaInicial: ""; property string fechaFinal: ""
    property int duracionDeAbono : 1
    property string strSinInformacion: qsTrId("\tSin información disponible.")
    property string strNoAbono : qsTrId("\tNo existe ningún abono vigente a la fecha o a futuro del alumno/a.")

    property int idAbonoAdultoSeleccionado: -1
    property var precioAbono : ""
    property var diferenciaPrecioAbono : ""
    property var varDeuda : ""
    property var varAfavor : ""
    property var varGeneral: ""
    property var varSaldoConMontoIngresado: ""

    property int cantidad_comprada : -1
    property int cantidad_acreditada : -1
    property string tipo : "Normal"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    /*Component.onCompleted: {
        wrapper.managerAbono.traerTodosLasOfertasDeAbono()
    }*/

    WrapperClassManagement {
        id: wrapper
    }

    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        ignoreUnknownSignals: true

        onSig_listaClaseAsistencias: {
            tablaPresentes.model = arg
            tablaPresentes.currentRow = -1
            tablaPresentes.resizeColumnsToContents()
        }
    }

    ListModel {
        id: modelPresentes

        Component.onCompleted: {
            modelPresentes.clear()
        }
    }

    Connections {
        target: principal.enabled ? wrapper.managerAbono : null
        ignoreUnknownSignals: true

        onSig_abonosDeAlumno: {
            selectorDeAbono.p_modelAbonos = arg
            selectorDeAbono.visible = true
            rowCambioDeAbono.enabled = true
        }

        onSig_noHayAbonosDelAlumno: {
            inhabilitarSelectorDeAbono()
            switchOnOffDatos(false)
        }

        onSig_abonoBorrado: {
            selectorDeAbono.desseleccionarAbonoSeleccionado()
        }

        onSig_abonoMejorado: {
            switchOnOffDatos(true)
        }
    }

    function inhabilitarSelectorDeAbono() {
        selectorDeAbono.p_modelAbonos = 0
        lblAbonosVigentesDisponibles.text = strNoAbono
        selectorDeAbono.visible = false
        rowCambioDeAbono.enabled = false
    }

    Connections {
        target: wrapper.managerAbono

        onSig_listaAbonosAdultosEnOferta: {
            radio1.info = null
            radio4.info = null
            radio8.info = null
            radio12.info = null
            radio16.info = null
            radioLibre.info = null

            var cantidad_comprada_abono_actual = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_comprada
            var cantidad_clases_restante = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_restante
            var clases_ya_tomadas = cantidad_comprada_abono_actual-cantidad_clases_restante

            var x;
            for (x=0;x<lista.length;x++){
                if (lista[x].estado === "Habilitado"){
                    if (lista[x].total_clases === 1){
                        if (cantidad_comprada_abono_actual !== 1){
                            if (clases_ya_tomadas <= 1)
                                radio1.info = lista[x]
                        }
                    }
                    else if (lista[x].total_clases === 4){
                        if (cantidad_comprada_abono_actual !== 4){
                            if (clases_ya_tomadas <= 4)
                                radio4.info = lista[x]
                        }
                    }
                    else if (lista[x].total_clases === 8){
                        if (cantidad_comprada_abono_actual !== 8){
                            if (clases_ya_tomadas <= 8)
                                radio8.info = lista[x]
                        }
                    }
                    else if (lista[x].total_clases === 12){
                        if (cantidad_comprada_abono_actual !== 12){
                            if (clases_ya_tomadas <= 12)
                                radio12.info = lista[x]
                        }
                    }
                    else if (lista[x].total_clases === 16){
                        if (cantidad_comprada_abono_actual !== 16){
                            if (clases_ya_tomadas <= 16)
                                radio16.info = lista[x]
                        }
                    }
                    else if (lista[x].total_clases === 99){
                        if (cantidad_comprada_abono_actual !== 99){
                            radioLibre.info = lista[x]
                        }
                    }
                }
            }
            if (radioLibre.info !== null)
                radioLibre.checked = true
            if (radio16.info !== null)
                radio16.checked = true
            if (radio12.info !== null)
                radio12.checked = true
            if (radio8.info !== null)
                radio8.checked = true
            if (radio4.info !== null)
                radio4.checked = true
            if (radio1.info !== null)
                radio1.checked = true
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Adultos"
        /*        standardButtons: StandardButton.Yes | StandardButton.No
        property int nro_clases_a_acreditar: 0

        onYes: {
            if (!wrapper.managerAbono.acreditarClasesAlAbono(selectorDeAbono.idAbonoSeleccionado, nro_clases_a_acreditar))
                messageError.open()
        }*/
    }

    MessageDialog {
        id: messageError
        title: "Adultos"
        icon: StandardIcon.Critical
        text: qsTrId("Lamentablemente ha ocurrido un error al intentar mejorar el abono.")
    }

    MessageDialog {
        id: messageDialogDos
        title: "Adultos"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (!wrapper.managerAbono.convertirEnAbonoLibre(selectorDeAbono.idAbonoSeleccionado))
                messageError.open()
        }
    }

    function limpiarFormulario() {
        radioRegistrarPagoAbono.checked = true
        lblAbonosVigentesDisponibles.text = strSinInformacion
        selectorDeAbono.visible = false
        switchOnOffDatos(false)
        tablaPresentes.model = 0
        detallesDelCliente.aliasCalendarVisible = false
        saldoMovimientos.tableViewMovimientos.model = 0
        cantidadDeClasesEnDeuda = 0
        buscador.focoEnDNI()
        if (buscador.recordClienteSeleccionado !== null)
            buscador.onClienteSeleccionado()
    }

//    function limpiarFormulario() {
//        lblAbonosVigentesDisponibles.text = strSinInformacion
//        selectorDeAbono.visible = false
//        buscador.modeloAlumnos = 0
//        switchOnOffDatos(false)
//        tablaPresentes.model = 0
//        detallesDelCliente.aliasCalendarVisible = false
//        saldoMovimientos.tableViewMovimientos.model = 0
//        cantidadDeClasesEnDeuda = 0
//        buscador.recordClienteSeleccionado = null
//        buscador.focoEnDNI()
//    }

    function switchOnOffDatos(logico) {
        if (logico) {
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
            wrapper.managerAbono.obtenerAbonosPorClienteMasFecha(buscador.recordClienteSeleccionado.id,true,true,true)
        }
        else {
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
        }
    }

    ListModel {
        id: modelUltimosPresentes
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

        function onClienteSeleccionado() {
            inhabilitarSelectorDeAbono()
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

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: btnRegistrarPago.top
        anchors.leftMargin: -1
        anchors.rightMargin: -1
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
            opacity: 0.7
            enabled: false

            //visible: false
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
                    text: qsTrId("Abonos vigentes y/o próximamente vigentes del alumno/a")
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
                width: columnaDatos.width
                height: 148
                visible: false
                mostrarLeyendaDeVigentes: true
                permitirEliminar: false

                onIdAbonoSeleccionadoChanged: {
                    if (idAbonoSeleccionado !== -1){
                        console.debug("hooola")
                        wrapper.managerAbono.traerTodosLasOfertasDeAbono()
                    }
                }
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
                    role: "clase_debitada"
                    title: "Pago"
                    width: 33
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
                    width: 225
                    delegate: Item {
                        Text {
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                            x: 1
                            //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                            text: {
                                // if (wrapper.classManagementManager.calcularTiempoPasadoEnSegundos(styleData.value) < 86400)
                                wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                                //else
                                //  tablaPresentes.model = tablaPresentes.modele(styleData.row)
                            }
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
                    text: qsTrId("Cambiar a abono de")
                }
            }

            ExclusiveGroup {
                id: group
            }
            ExclusiveGroup {
                id: groupFormasDePago
            }

            Row {
                id: rowCambioDeAbono
                x: columnaDatos.separacionIzquierda *3
                spacing: 3

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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
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
                            diferenciaPrecioAbono = info.precio_actual - selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].precio_abono
                        }
                    }
                }
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                visible: !isNaN(parseFloat(precioAbono))
                x: columnaDatos.separacionIzquierda *3
                text: "Valor $ " + precioAbono
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
                text: "Diferencia de precio de abono"
            }

            Text {
                id: lblDiferenciaPrecio
                font.family: "verdana";
                font.pixelSize: 14
                visible: !isNaN(parseFloat(precioAbono))
                x: columnaDatos.separacionIzquierda *3
                property string frase: ""

                text: {
                    if (cuenta_alumno !== null){
                        "$ " + diferenciaPrecioAbono + frase
                    }
                    else{
                        ""
                    }
                }
                color:{
                    if (cuenta_alumno !== null) {
                        /*if (diferenciaPrecioAbono > 0){
                            frase = " (costo de mejora de abono)"
                            //"red"
                        }else*/
                        if (diferenciaPrecioAbono < 0){
                            frase = " (a favor del alumno por degradar el abono)"
                            "green"
                        }
                        else {
                            frase = ""
                            "black"
                        }
                    }else{
                        "black"
                    }
                }
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
                        varGeneral = credito_actual - diferenciaPrecioAbono
                        if (credito_actual >= diferenciaPrecioAbono){
                            varAfavor = credito_actual - diferenciaPrecioAbono
                            color = "green"
                            radioDebitarDeCuenta.info = credito_actual === diferenciaPrecioAbono ? "-> quedará al día " : "-> quedarán a favor $ " + varAfavor
                            radioDebitarDeCuenta.checked = true
                            "Nada! Quedarán a favor del alumno $ " + varAfavor
                        }
                        else{
                            varDeuda = diferenciaPrecioAbono - credito_actual
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
                visible: (cuenta_alumno !== null) && diferenciaPrecioAbono !== ""
                property string info: ""
            }

            RadioButton {
                id: radioRegistrarPagoAbono
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                checked: true
                visible: (cuenta_alumno !== null) && diferenciaPrecioAbono > 0
                text: "Recibo $ " + diferenciaPrecioAbono + " por el abono"
            }

            RadioButton {
                id: radioRegistrarPagoDiferencia
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && varGeneral < 0 &&
                         ((cuenta_alumno.credito_actual < 0 && diferenciaPrecioAbono < 0) || (cuenta_alumno.credito_actual > 0 && diferenciaPrecioAbono > 0))
                text: "Recibo $ " + varDeuda + " por lo que queda por pagar"
            }

            RadioButton {
                id: radioRegistrarPagoTotal
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual < 0 && diferenciaPrecioAbono > 0
                text: "Recibo $ " + varDeuda + " por el abono y la deuda"
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 15
                visible: (cuenta_alumno !== null) && diferenciaPrecioAbono !== ""

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
                    validator: DoubleValidator {bottom: 0}

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
        text: qsTrId("Registrar cambios")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: group.current !== null && group.current.enabled

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

                var id_abono_actual = selectorDeAbono.idAbonoSeleccionado
                var id_nuevo_abono = group.current.info.id;
                var precio_abono_a_sumar = diferenciaPrecioAbono

                var clases_compradas_actual = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_comprada
                var clases_restantes = selectorDeAbono.p_modelAbonos[selectorDeAbono.aliasListaDeAbonos.currentIndex].cantidad_restante
                var cantidad_clases_a_sumar = (group.current.info.total_clases - clases_compradas_actual)

                var resultadoActualizacion
                if (group.current.info.total_clases === 99){
                    resultadoActualizacion = wrapper.managerAbono.actualizarHaciaAbonoLibre(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar,99-(clases_compradas_actual-clases_restantes))
                }
                else {
                    resultadoActualizacion = wrapper.managerAbono.actualizarAbonoNormalComprado(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar,cantidad_clases_a_sumar,cantidad_clases_a_sumar)
                }



                var codigo_oculto_movimiento = "MAA"+id_abono_actual
                var descripcion = "Mejora abono a "+group.current.text
                if (cantidad_clases_a_sumar < 0){
                    codigo_oculto_movimiento = "DAA"+id_abono_actual
                    descripcion = "Degrada abono a "+group.current.text
                }

                var id_movimiento = -1

                if (resultadoActualizacion){
                    if (radioDebitarDeCuenta.checked){
                        console.debug("radioDebitarDeCuenta")

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    }
                    else if(radioRegistrarPagoAbono.checked){
                        console.debug("radioRegistrarPagoAbono")
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAA"+id_abono_actual) //Comprar Abono Adulto
                        if (id_movimiento !== -1) {
                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                        }
                    }
                    else if (radioRegistrarPagoDiferencia.checked || radioRegistrarPagoTotal.checked) {
                        console.debug("radioRegistrarPagoDiferencia")
                        var texto = "Carga diferencia"
                        var codigo = "CSAA"+id_abono_actual
                        if (radioRegistrarPagoTotal.checked) {
                            texto = "Carga por el abono y la deuda"
                        }
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,varDeuda,texto,cuenta_alumno,resumen_mes_alumno,codigo) //Comprar Abono Adulto Paga Deuda
                        if (id_movimiento !== -1) {

                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                        }
                    }
                    else if (radioRegistrarPagoPersonalizado.checked) {
                        console.debug("radioRegistrarPagoPersonalizado")
                        if (txtMontoIngresado.length > 0) {

                            var montoIngresado = txtMontoIngresado.text

                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,montoIngresado,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAA"+id_abono_actual) //Comprar Abono Adulto
                            if (id_movimiento !== -1) {

                                id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                            }

                        }
                    }
                }


                if (id_movimiento !== -1 && resultadoActualizacion === true) {
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                    messageDialog.text = "Abono adulto Nº "+id_abono_actual+" mejorado exitosamente.\n" + strDatosDelRegistroDePresente
                    if (cantidad_clases_a_sumar <0 )
                        messageDialog.text = "Abono adulto Nº "+id_abono_actual+" degradado exitosamente.\n" + strDatosDelRegistroDePresente
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
    }
}
