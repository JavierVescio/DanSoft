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

    property color backColorSubtitles: "#FFCCBC"
    property color colorSubtitles: "black"

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null

    property real precioCarrito : 0
    property var varDeuda : ""
    property var varAfavor : ""
    property var varGeneral: ""
    property var varSaldoConMontoIngresado: ""


    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted:{
        wrapper.managerOferta.vaciarCarritoDeCompras()
        modelListViewItemOferta.clear()
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
        title: "Ofertas"
    }

    ExclusiveGroup {
        id: groupFormasDePago
    }

    PickerDeOfertas {
        id: pickerDeOfertas
        anchors.fill: parent
        z: 10

        //signal ofertaNoSeleccionada()
        //signal ofertaSeleccionada(var recordOfertaSeleccionada)

        onOfertaNoSeleccionada: {

        }

        onOfertaSeleccionada: {
            //console.debug("recordOfertaSeleccionada.id: "+recordOfertaSeleccionada.id)

            var x;
            var agregada = wrapper.managerOferta.agregarAlCarritoDeCompras(
                        recordOfertaSeleccionada.id,
                        recordOfertaSeleccionada.nombre,
                        1,
                        recordOfertaSeleccionada.precio)

            /*for (x=0;x<modelListViewItemOferta.count;x++){
                if (modelListViewItemOferta.get(x).id == recordOfertaSeleccionada.id){
                    ya_agregada = true
                    break;
                }
            }*/
            if (agregada){
                modelListViewItemOferta.append(
                            {
                                "id":recordOfertaSeleccionada.id,
                                "nombre":recordOfertaSeleccionada.nombre,
                                "descripcion":recordOfertaSeleccionada.descripcion,
                                "tipo":recordOfertaSeleccionada.tipo,
                                "precio":recordOfertaSeleccionada.precio,
                                "cantidad":0,
                                "subtotal":0,
                                "stock":recordOfertaSeleccionada.stock,
                                "uno_por_alumno":recordOfertaSeleccionada.uno_por_alumno,
                                "fecha_creacion":recordOfertaSeleccionada.fecha_creacion,
                                "fecha_vigente_desde":recordOfertaSeleccionada.fecha_vigente_desde,
                                "fecha_vigente_hasta":recordOfertaSeleccionada.fecha_vigente_hasta,
                                "estado":recordOfertaSeleccionada.estado
                            }
                            )
            }

            //calcular_precio_carrito()
        }
    }

    function calcular_precio_carrito() {
        precioCarrito = 0
        for (var x=0;x<modelListViewItemOferta.count;x++){
            precioCarrito = precioCarrito + modelListViewItemOferta.get(x).subtotal
        }
    }

    function limpiar_carrito() {
        modelListViewItemOferta.clear()
        wrapper.managerOferta.vaciarCarritoDeCompras()
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
            radioRegistrarPagoAbono.checked = true
            if (recordClienteSeleccionado == null) {
                //limpiarFormulario()
                switchOnOffDatos(false)
            }
            else {
                switchOnOffDatos(true)
                wrapper.gestionBaseDeDatos.beginTransaction()
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                if (cuenta_alumno !== null) {
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id)
                    saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()

                    wrapper.gestionBaseDeDatos.beginTransaction()
                    resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)
                }
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
        anchors.bottom: btnRegistrarCompra.top
        anchors.leftMargin: -1
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        enabled: !pickerDeOfertas.enabled
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
                    text: qsTrId("Carrito de compras")
                    color: colorSubtitles
                }

                Button {
                    anchors.top:parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 180
                    anchors.margins: 3
                    text: qsTrId("Agregar al carrito")
                    width: 120
                    iconSource: "qrc:/media/Media/ico-carrito.png"



                    onClicked: {
                        pickerDeOfertas.enabled = true
                    }
                }
            }

            GridView {
                id: listViewItemOferta
                model: modelListViewItemOferta
                height: principal.height * 0.18
                width: flickDatos.width
                cellWidth: 254; cellHeight: 49

                clip: true
                //spacing: -1
                //verticalLayoutDirection: ListView.BottomToTop

                delegate: ItemOfertaCompra{

                    indice: index
                    recordOferta: modelListViewItemOferta.get(index)

                    onQuitarItem: {
                        //destroy()
                        wrapper.managerOferta.quitarItemCarritoDeCompras(recordOferta.id)
                        modelListViewItemOferta.remove(indice)
                        calcular_precio_carrito()
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
                text: "Precio del carrito:"
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                //visible: !isNaN(parseFloat(precioCarrito))
                x: columnaDatos.separacionIzquierda *3
                text: "$ " + precioCarrito
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
                visible: (cuenta_alumno !== null)  && precioCarrito > 0
                x: columnaDatos.separacionIzquierda *3
                text: "Total a abonar:"
                font.underline: true
            }

            Text {
                font.family: "verdana";
                font.pixelSize: 14
                color: colorSubtitles
                property real credito_actual
                visible: (cuenta_alumno !== null)  && precioCarrito > 0
                x: columnaDatos.separacionIzquierda *3
                text: {
                    if (cuenta_alumno !== null){
                        credito_actual = cuenta_alumno.credito_actual
                        varGeneral = credito_actual - precioCarrito
                        if (credito_actual >= precioCarrito){
                            varAfavor = credito_actual - precioCarrito
                            color = "green"
                            radioDebitarDeCuenta.info = credito_actual === precioCarrito ? "-> quedará al día " : "-> quedarán a favor $ " + varAfavor
                            "Nada! La cuenta del alumno/a cubre el precio del abono."
                        }
                        else{
                            varDeuda = precioCarrito - credito_actual
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
                visible: (cuenta_alumno !== null) && precioCarrito > 0
                //enabled: abonoInfantilDelMes.abono_infantil_compra === null
                property string info: ""
            }

            RadioButton {
                id: radioRegistrarPagoAbono
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                checked: true
                visible: (cuenta_alumno !== null) && precioCarrito > 0
                //enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + precioCarrito + " por el carrito"
            }

            RadioButton {
                id: radioRegistrarPagoDiferencia
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual > 0 && varGeneral < 0
                //enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + varDeuda + " por lo que queda por pagar"
            }

            RadioButton {
                id: radioRegistrarPagoTotal
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual < 0 && precioCarrito > 0
                //enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + varDeuda + " por el carrito y la deuda"
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 15
                visible: (cuenta_alumno !== null) && precioCarrito > 0
                //enabled: abonoInfantilDelMes.abono_infantil_compra === null

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

    ListModel {
        id: modelListViewItemOferta
    }

    Button {
        id: btnRegistrarCompra
        text: qsTrId("Registrar compra")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: cuenta_alumno !== null && precioCarrito > 0

        onClicked: {
            wrapper.gestionBaseDeDatos.beginTransaction()
            var id_venta_realizada = wrapper.managerOferta.realizarCompra(
                        buscador.recordClienteSeleccionado.id,
                        precioCarrito)

            var codigo_oculto_movimiento = "CT"+id_venta_realizada
            var descripcion_compra = wrapper.managerOferta.obtenerBreveResumenDelCarritoDeCompras()

            var id_movimiento

            if (radioDebitarDeCuenta.checked){
                console.debug("radioDebitarDeCuenta")

                id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                            -1,
                            cuenta_alumno.id,
                            precioCarrito*(-1),
                            descripcion_compra,
                            cuenta_alumno,
                            resumen_mes_alumno,
                            codigo_oculto_movimiento)
            }
            else if(radioRegistrarPagoAbono.checked){
                console.debug("radioRegistrarPago")
                id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                            -1,
                            cuenta_alumno.id,
                            precioCarrito,
                            "Carga saldo",
                            cuenta_alumno,
                            resumen_mes_alumno,
                            "CSCT"+id_venta_realizada) //Carga saldo para comprar en tienda
                if (id_movimiento !== -1) {

                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                                -1,
                                cuenta_alumno.id,
                                precioCarrito*(-1),
                                descripcion_compra,
                                cuenta_alumno,
                                resumen_mes_alumno,
                                codigo_oculto_movimiento)
                }
            }
            else if (radioRegistrarPagoDiferencia.checked || radioRegistrarPagoTotal.checked) {
                console.debug("radioRegistrarPagoDiferencia")
                var texto = "Carga diferencia"
                var codigo = "CSCT"+id_venta_realizada
                if (radioRegistrarPagoTotal.checked) {
                    texto = "Carga saldo por compra en tienda y deuda"
                }
                id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                            -1,
                            cuenta_alumno.id,
                            varDeuda,
                            texto,
                            cuenta_alumno,
                            resumen_mes_alumno,
                            codigo) //Comprar Paga Deuda
                if (id_movimiento !== -1) {

                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                                -1,
                                cuenta_alumno.id,
                                precioCarrito*(-1),
                                descripcion_compra,
                                cuenta_alumno,
                                resumen_mes_alumno,
                                codigo_oculto_movimiento)
                }
            }
            else if (radioRegistrarPagoPersonalizado.checked) {
                console.debug("radioRegistrarPagoPersonalizado")
                if (txtMontoIngresado.length > 0) {

                    var montoIngresado = txtMontoIngresado.text

                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                                -1,
                                cuenta_alumno.id,
                                montoIngresado,
                                "Carga saldo",
                                cuenta_alumno,
                                resumen_mes_alumno,
                                "CSCT"+id_venta_realizada)
                    if (id_movimiento !== -1) {

                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(
                                    -1,
                                    cuenta_alumno.id,
                                    precioCarrito*(-1),
                                    descripcion_compra,
                                    cuenta_alumno,
                                    resumen_mes_alumno,
                                    codigo_oculto_movimiento)
                    }

                }
            }

            if (id_movimiento !== -1 && id_venta_realizada !== -1) {
                wrapper.gestionBaseDeDatos.commitTransaction()
                var strDatosDelRegistro = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                messageDialog.text = "Compra en tienda Nº "+id_venta_realizada+" exitosa.\n" + strDatosDelRegistro
                messageDialog.icon = StandardIcon.Information

                limpiar_carrito()
                buscador.focoEnDNI()
                buscador.onClienteSeleccionado()
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
            }
            messageDialog.open()
            //limpiar()
        }
    }

    DetallesDelCliente {
        id: detallesDelCliente
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: -1
        width: 250
        aliasRecordClienteSeleccionado: buscador.recordClienteSeleccionado
    }
}
