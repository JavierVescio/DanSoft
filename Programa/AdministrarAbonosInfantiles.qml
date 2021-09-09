import QtQuick.Controls 1.3
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

    property color backColorSubtitles: "#FFCDD2"
    property color colorSubtitles: "black"

    property string strEstadoMatriculacion: "sin matrícula"
    property bool alumnoMatriculado: false

    property int idAbonoInfantilSeleccionado: -1
    property var precioAbono : ""
    property var diferenciaPrecioAbono : ""
    property var varDeuda : ""
    property var varAfavor : ""
    property var varGeneral: ""
    property var varSaldoConMontoIngresado: ""

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null



    WrapperClassManagement {
        id: wrapper
    }

    /*Component.onCompleted: { //ES NECESARIO LLAMAR ESTA FUNCION DESDE ACA 28/3/18
        wrapper.managerAbonoInfantil.traerTodosLasOfertasDeAbono()
    }*/

    Connections {
        target: wrapper.managerAbonoInfantil

        onSig_listaAbonosEnOferta: {
            radio1clase.info = null
            radio2clase.info = null
            radio3clase.info = null
            radio4clase.info = null
            radio5clase.info = null
            radio6clase.info = null

            var cantidad_comprada_abono_actual = abonoInfantilDelMes.abono_infantil_compra.clases_por_semana
            var clases_ya_tomadas = tablaPresentes.rowCount;
            var x;
            for (x=0;x<lista.length;x++){
                if (lista[x].estado === "Habilitado"){
                    if (lista[x].clases_por_semana === 1){
                        if (cantidad_comprada_abono_actual !== 1){
                            if (clases_ya_tomadas <= 5){
                                radio1clase.info = lista[x]
                            }
                        }
                    }
                    else if (lista[x].clases_por_semana === 2){
                        if (cantidad_comprada_abono_actual !== 2){
                            if (clases_ya_tomadas <= 10){
                                radio2clase.info = lista[x]
                            }
                        }
                    }
                    else if (lista[x].clases_por_semana === 3){
                        if (cantidad_comprada_abono_actual !== 3){
                            if (clases_ya_tomadas <= 15){
                                radio3clase.info = lista[x]
                            }
                        }
                    }
                    else if (lista[x].clases_por_semana === 4){
                        if (cantidad_comprada_abono_actual !== 4){
                            if (clases_ya_tomadas <= 19){
                                radio4clase.info = lista[x]
                            }
                        }
                    }
                    else if (lista[x].clases_por_semana === 5){
                        if (cantidad_comprada_abono_actual !== 5){
                            if (clases_ya_tomadas <= 23){
                                radio5clase.info = lista[x]
                            }
                        }
                    }
                    else if (lista[x].clases_por_semana === 6){
                        if (cantidad_comprada_abono_actual !== 6){
                            radio6clase.info = lista[x]
                        }
                    }
                }
            }
            if (radio6clase.info !== null)
                radio6clase.checked = true
            if (radio5clase.info !== null)
                radio5clase.checked = true
            if (radio4clase.info !== null)
                radio4clase.checked = true
            if (radio3clase.info !== null)
                radio3clase.checked = true
            if (radio2clase.info !== null)
                radio2clase.checked = true
            if (radio1clase.info !== null)
                radio1clase.checked = true
        }
    }

    function switchOnOffDatos(logico) {
        if (logico) {
            columnaDatos.opacity = 1
            columnaDatos.enabled = true
        }
        else {
            columnaDatos.opacity = 0.7
            columnaDatos.enabled = false
        }
    }

    MessageDialog {
        id: messageDialog
        title: "Niños"
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
                        abonoInfantilDelMes.abono_infantil_compra = wrapper.managerAbonoInfantil.traerCompraDeAbonoInfantil(recordClienteSeleccionado.id)

                        alumnoMatriculado = wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(recordClienteSeleccionado.id)
                        if (alumnoMatriculado){
                            strEstadoMatriculacion = "alumno matriculado"
                        }else{
                            strEstadoMatriculacion = "sin matrícula"
                        }

                        abonoInfantilDelMes.alumno_matriculado = alumnoMatriculado
                        abonoInfantilDelMes.strEstadoMatriculacion = strEstadoMatriculacion

                        if (abonoInfantilDelMes.abono_infantil_compra == null) {
                            abonoInfantilDelMes.height = 16
                            tablaPresentes.model = 0
                            switchOnOffDatos(false)
                        }
                        else {
                            switchOnOffDatos(true)
                            abonoInfantilDelMes.height = 48
                            var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
                            tablaPresentes.model = modelo
                        }
                        wrapper.managerAbonoInfantil.traerTodosLasOfertasDeAbono()
                    }
                }
            }
            else {
                limpiar()
            }
        }

        onRecordClienteSeleccionadoChanged: {
            onClienteSeleccionado()
        }
    }

    function limpiar() {
        radioRegistrarPagoAbono.checked = true
        cuenta_alumno = null
        varDeuda = ""
        varAfavor = ""
        cuenta_alumno = null
        resumen_mes_alumno =null
        tablaPresentes.model = 0
        varGeneral = ""
        varSaldoConMontoIngresado = ""
        saldoMovimientos.tableViewMovimientos.model = 0
        abonoInfantilDelMes.abono_infantil_compra = null
        abonoInfantilDelMes.height = 16
        abonoInfantilDelMes.montoDeudaPotencial = -1
        abonoInfantilDelMes.estadoPresentePotencial = -1
        buscador.focoEnDNI()
        if (buscador.recordClienteSeleccionado !== null)
            buscador.onClienteSeleccionado()
    }

//    function limpiar() {
//        cuenta_alumno = null
//        //precioAbono = ""
//        varDeuda = ""
//        varAfavor = ""
//        cuenta_alumno = null
//        resumen_mes_alumno =null
//        tablaPresentes.model = 0
//        varGeneral = ""
//        varSaldoConMontoIngresado = ""
//        buscador.recordClienteSeleccionado = null
//        buscador.modeloAlumnos = 0
//        saldoMovimientos.tableViewMovimientos.model = 0
//        abonoInfantilDelMes.abono_infantil_compra = null
//        abonoInfantilDelMes.height = 16
//        abonoInfantilDelMes.montoDeudaPotencial = -1
//        abonoInfantilDelMes.estadoPresentePotencial = -1

//        /*radio1clase.checked = false
//        radio2clase.checked = false
//        radio3clase.checked = false
//        radio4clase.checked = false
//        radio5clase.checked = false
//        radio6clase.checked = false*/
//    }

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

    ScrollView {
        id: scroll
        contentItem: flickDatos
        anchors.top: buscador.bottom
        anchors.left: parent.left
        anchors.right: detallesDelCliente.left
        anchors.bottom: btnComprarAbonoInfantil.top
        anchors.leftMargin: -1
        anchors.rightMargin: 0
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
                    text: qsTrId("Abono del alumno") //+ " (" + strEstadoMatriculacion + ")"
                }
            }

            AbonoInfantilDelMes {
                id: abonoInfantilDelMes
                height: 16
                width: flickDatos.width
                visualizandoseDesdeComprarAbono: true
                permitirEliminar: false
                mostrarInformacionEstadoAbono: false
                x:3
            }

            TableView {
                id: tablaPresentes
                height: 85
                width: flickDatos.width

                TableViewColumn {
                    role: "index"
                    title: ""
                    width: 10

                    delegate: Item {
                        Text {
                            x: 1
                            y: 1
                            text: tablaPresentes.model.length - styleData.row
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    role: "id"
                    title: "Nro"
                    width: 45
                }

                TableViewColumn {
                    role: "nombre_actividad"
                    title: "Actividad"
                    width: 100
                }

                TableViewColumn {
                    role: "nombre_clase"
                    title: "Clase"
                    width: 100
                }

                TableViewColumn {
                    role: "fecha"
                    title: "Asistencias de este mes"
                    width: 215

                    delegate: Item {
                        Text {
                            x: 1
                            y: 1
                            //text: Qt.formatDateTime(styleData.value,"dd/MM/yyyy ddd HH:mm")
                            text: wrapper.classManagementManager.calcularTiempoPasado(styleData.value)
                            color: styleData.selected && tablaPresentes.focus ? "white" : "black"
                        }
                    }
                }

                TableViewColumn {
                    role: "estado"
                    title: "Estado"
                    width: 100
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
                    text: qsTrId("Cambiar a abono de")
                    color: colorSubtitles
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
                enabled: abonoInfantilDelMes.abono_infantil_compra !== null

                RadioButton {
                    id: radio1clase
                    exclusiveGroup: group
                    enabled: false
                    text: "1"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                RadioButton {
                    id: radio2clase
                    exclusiveGroup: group
                    enabled: false
                    text: "2"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                RadioButton {
                    id: radio3clase
                    enabled: false
                    exclusiveGroup: group
                    text: "3"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                RadioButton {
                    id: radio4clase
                    enabled: false
                    exclusiveGroup: group
                    text: "4"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                RadioButton {
                    id: radio5clase
                    enabled: false
                    exclusiveGroup: group
                    text: "5"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                RadioButton {
                    id: radio6clase
                    enabled: false
                    exclusiveGroup: group
                    text: "6"
                    property variant info: null

                    onInfoChanged: {
                        if (info !== null) {
                            enabled = true
                        }
                        else {
                            enabled = false
                        }
                    }

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = info.id
                            precioAbono = info.precio_actual
                            diferenciaPrecioAbono = info.precio_actual - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                        }
                    }
                }

                Text {
                    font.family: "verdana";
                    font.pixelSize: 14
                    color: colorSubtitles
                    text: "(clases por semana)"
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
                text: "Diferencia de precio de abono:"
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
        id: btnComprarAbonoInfantil
        text: qsTrId("Registrar cambios")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: group.current !== null && group.current.enabled

        onClicked: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var id_abono_infantil_compra = abonoInfantilDelMes.abono_infantil_compra.id

            var esMejora = true;
            if (group.current.info.clases_por_semana < abonoInfantilDelMes.abono_infantil_compra.clases_por_semana){
                esMejora = false;
            }


            var resultado_actualizacion = wrapper.managerAbonoInfantil.actualizarAbonoComprado(id_abono_infantil_compra,group.current.info.id,diferenciaPrecioAbono)

            //var codigo_oculto_movimiento = "AAI"+id_abono_infantil_compra
            var codigo_oculto_movimiento = "MAI"+id_abono_infantil_compra
            var descripcion = "Mejora abono a "+group.current.text + " clases/sem"
            if (!esMejora){
                codigo_oculto_movimiento = "DAI"+id_abono_infantil_compra
                descripcion = "Degrada abono a "+group.current.text + " clases/sem"
            }


            var id_movimiento = -1

            if (resultado_actualizacion){

                if (radioDebitarDeCuenta.checked){
                    console.debug("radioDebitarDeCuenta")

                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                }
                else if(radioRegistrarPagoAbono.checked){
                    console.debug("radioRegistrarPagoAbono")
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                    if (id_movimiento !== -1) {

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    }
                }
                else if (radioRegistrarPagoDiferencia.checked || radioRegistrarPagoTotal.checked) {
                    console.debug("radioRegistrarPagoDiferencia")
                    var texto = "Carga diferencia"
                    var codigo = "CSAI"+id_abono_infantil_compra
                    if (radioRegistrarPagoTotal.checked) {
                        texto = "Carga por el abono y la deuda"
                    }
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,varDeuda,texto,cuenta_alumno,resumen_mes_alumno,codigo) //Comprar Abono Infantil Paga Deuda
                    if (id_movimiento !== -1) {

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                        if (id_movimiento !== -1) {
                            wrapper.gestionBaseDeDatos.commitTransaction()
                        }
                    }
                }
                else if (radioRegistrarPagoPersonalizado.checked) {
                    console.debug("radioRegistrarPagoPersonalizado")
                    if (txtMontoIngresado.length > 0) {

                        var montoIngresado = txtMontoIngresado.text

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,montoIngresado,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                        if (id_movimiento !== -1) {

                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,diferenciaPrecioAbono*(-1),descripcion,cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                        }

                    }
                }

            }

            if (id_movimiento !== -1 && resultado_actualizacion === true) {
                wrapper.gestionBaseDeDatos.commitTransaction()
                var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                messageDialog.text = "Abono infantil Nº "+id_abono_infantil_compra+" mejorado exitosamente.\n" + strDatosDelRegistroDePresente
                if (!esMejora)
                    messageDialog.text = "Abono infantil Nº "+id_abono_infantil_compra+" degradado exitosamente.\n" + strDatosDelRegistroDePresente
                messageDialog.icon = StandardIcon.Information
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
            }
            messageDialog.open()
            limpiar()

        }
    }
}
