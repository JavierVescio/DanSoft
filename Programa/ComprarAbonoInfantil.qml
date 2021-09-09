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

    property int idAbonoInfantilSeleccionado: -1
    property var precioAbono : ""
    property var precioMatricula : 0
    property var varDeuda : ""
    property var varAfavor : ""
    property var varGeneral: ""
    property var varSaldoConMontoIngresado: ""

    property string strEstadoMatriculacion: "sin matrícula"
    property string strBonificado: ""
    property bool alumnoMatriculado: false
    property bool alumnoFueMatriculado: false

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null


    WrapperClassManagement {
        id: wrapper
    }

    Component.onCompleted: { //ES NECESARIO LLAMAR ESTA FUNCION DESDE ACA 28/3/18
        wrapper.managerAbonoInfantil.traerTodosLasOfertasDeAbono()
    }

    Connections {
        target: wrapper.managerAbonoInfantil

        //emit sig_listaAbonosEnOferta(listaAbonosEnOferta);
        onSig_listaAbonosEnOferta: {
            //lista
            var x;
            for (x=0;x<lista.length;x++){
                //iflista[x].estado
                if (lista[x].estado === "Habilitado"){
                    if (lista[x].clases_por_semana === 1){
                        radio1clase.enabled = true
                        radio1clase.precio = lista[x].precio_actual
                        radio1clase.idAbono = lista[x].id
                        radio1clase.checked = true
                    }
                    else if (lista[x].clases_por_semana === 2){
                        radio2clase.enabled = true
                        radio2clase.precio = lista[x].precio_actual
                        radio2clase.idAbono = lista[x].id
                    }
                    else if (lista[x].clases_por_semana === 3){
                        radio3clase.enabled = true
                        radio3clase.precio = lista[x].precio_actual
                        radio3clase.idAbono = lista[x].id
                    }
                    else if (lista[x].clases_por_semana === 4){
                        radio4clase.enabled = true
                        radio4clase.precio = lista[x].precio_actual
                        radio4clase.idAbono = lista[x].id
                    }
                    else if (lista[x].clases_por_semana === 5){
                        radio5clase.enabled = true
                        radio5clase.precio = lista[x].precio_actual
                        radio5clase.idAbono = lista[x].id
                    }
                    else if (lista[x].clases_por_semana === 6){
                        radio6clase.enabled = true
                        radio6clase.precio = lista[x].precio_actual
                        radio6clase.idAbono = lista[x].id
                    }
                }
            }
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

        function onClienteSeleccionado(){
            console.debug("1")
            if (recordClienteSeleccionado !== null) {
                switchOnOffDatos(true)
                wrapper.gestionBaseDeDatos.beginTransaction()
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                console.debug("2")
                if (cuenta_alumno !== null) {
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id)
                    saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()

                    wrapper.gestionBaseDeDatos.beginTransaction()
                    resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                    alumnoMatriculado = wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(recordClienteSeleccionado.id)
                    precioMatricula = wrapper.managerAbonoInfantil.traerPrecioMatricula()
                    strBonificado = ""
                    console.debug("3")
                    if (alumnoMatriculado){
                        strEstadoMatriculacion = "alumno matriculado"
                        precioMatricula = 0
                        console.debug("a")
                    }else{
                        strEstadoMatriculacion = "sin matrícula"
                        console.debug("b")
                    }

                    if (resumen_mes_alumno !== null) {
                        console.debug("4")
                        wrapper.gestionBaseDeDatos.commitTransaction()
                        abonoInfantilDelMes.abono_infantil_compra = wrapper.managerAbonoInfantil.traerCompraDeAbonoInfantil(recordClienteSeleccionado.id)
                        abonoInfantilDelMes.alumno_matriculado = alumnoMatriculado
                        abonoInfantilDelMes.strEstadoMatriculacion = strEstadoMatriculacion

                        if (abonoInfantilDelMes.abono_infantil_compra == null) {
                            abonoInfantilDelMes.height = 16
                            tablaPresentes.model = 0
                        }
                        else {
                            abonoInfantilDelMes.height = 48
                            var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
                            tablaPresentes.model = modelo
                        }
                    }
                }
            }
            else {
                switchOnOffDatos(false)
                limpiar()
            }
        }

        onRecordClienteSeleccionadoChanged: {
            onClienteSeleccionado()
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

    function limpiar() {
        radioRegistrarPagoAbono.checked = true
        cuenta_alumno = null
        varDeuda = ""
        varAfavor = ""
        cuenta_alumno = null
        resumen_mes_alumno =null
        tablaPresentes.model = 0
        strBonificado = ""
        varGeneral = ""
        precioMatricula = 0
        varSaldoConMontoIngresado = ""
        //buscador.recordClienteSeleccionado = null
        //buscador.modeloAlumnos = 0
        saldoMovimientos.tableViewMovimientos.model = 0
        abonoInfantilDelMes.abono_infantil_compra = null
        abonoInfantilDelMes.height = 16
        abonoInfantilDelMes.montoDeudaPotencial = -1
        abonoInfantilDelMes.estadoPresentePotencial = -1
        abonoInfantilDelMes.alumno_matriculado = false
        abonoInfantilDelMes.strEstadoMatriculacion = ""
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
                    text: qsTrId("Abono del alumno")// + " (" + strEstadoMatriculacion + ")"
                }
            }

            AbonoInfantilDelMes {
                id: abonoInfantilDelMes
                height: 16
                width: flickDatos.width
                visualizandoseDesdeComprarAbono: true
                permitirEliminar: true
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
                    text: qsTrId("Clases por semana")
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
                enabled: abonoInfantilDelMes.abono_infantil_compra === null

                RadioButton {
                    id: radio1clase
                    exclusiveGroup: group
                    enabled: false
                    text: "1"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
                        }
                    }
                }

                RadioButton {
                    id: radio2clase
                    exclusiveGroup: group
                    enabled: false
                    text: "2"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
                        }
                    }
                }

                RadioButton {
                    id: radio3clase
                    enabled: false
                    exclusiveGroup: group
                    text: "3"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
                        }
                    }
                }

                RadioButton {
                    id: radio4clase
                    enabled: false
                    exclusiveGroup: group
                    text: "4"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
                        }
                    }
                }

                RadioButton {
                    id: radio5clase
                    enabled: false
                    exclusiveGroup: group
                    text: "5"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
                        }
                    }
                }

                RadioButton {
                    id: radio6clase
                    enabled: false
                    exclusiveGroup: group
                    text: "6"
                    property var precio: 0
                    property int idAbono: -1

                    onCheckedChanged:{
                        if (checked){
                            idAbonoInfantilSeleccionado = idAbono
                            precioAbono = precio
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
                id: lblPrecioMatricula
                font.family: "verdana";
                font.pixelSize: 14
                visible: txtPrecioMatricula.visible
                font.underline: true
                color: colorSubtitles
                x: columnaDatos.separacionIzquierda *3
                text: "Precio de matrícula:"
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 10
                Text {
                    id: txtPrecioMatricula
                    font.family: "verdana";
                    font.pixelSize: 14
                    visible: !isNaN(parseFloat(precioMatricula)) && alumnoMatriculado == false
                    text: "$ " + precioMatricula + " " + strBonificado
                }
                Text{
                    color: "blue"
                    y: 2
                    text: "(Bonificar)"
                    visible: txtPrecioMatricula.visible

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: parent.enabled

                        onEntered:
                            parent.font.underline = true
                        onExited:
                            parent.font.underline = false
                        onClicked: {
                            precioMatricula = 0
                            strBonificado = "¡Como excepción, no se le cobrará matrícula por esta vez!"
                        }
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
                        varGeneral = credito_actual - precioMatricula - precioAbono
                        if (credito_actual >= precioAbono + precioMatricula){
                            varAfavor = credito_actual - precioAbono - precioMatricula
                            color = "green"
                            radioDebitarDeCuenta.info = credito_actual === precioAbono ? "-> quedará al día " : "-> quedarán a favor $ " + varAfavor
                            "Nada! La cuenta del alumno/a cubre el precio del abono."
                        }
                        else{
                            varDeuda = precioAbono + precioMatricula - credito_actual
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
                enabled: abonoInfantilDelMes.abono_infantil_compra === null
                property string info: ""
            }

            RadioButton {
                id: radioRegistrarPagoAbono
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                checked: true
                visible: (cuenta_alumno !== null) && precioAbono !== ""
                enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + (precioAbono + precioMatricula) + " por la compra"
            }

            RadioButton {
                id: radioRegistrarPagoDiferencia
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual > 0 && varGeneral < 0
                enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + varDeuda + " por lo que queda por pagar"
            }

            RadioButton {
                id: radioRegistrarPagoTotal
                x: columnaDatos.separacionIzquierda *3
                exclusiveGroup: groupFormasDePago
                visible: (cuenta_alumno !== null) && cuenta_alumno.credito_actual < 0 && precioAbono !== ""
                enabled: abonoInfantilDelMes.abono_infantil_compra === null
                text: "Recibo $ " + varDeuda + " por la compra y la deuda"
            }

            Row {
                x: columnaDatos.separacionIzquierda *3
                spacing: 15
                visible: (cuenta_alumno !== null) && precioAbono !== ""
                enabled: abonoInfantilDelMes.abono_infantil_compra === null

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
        id: btnComprarAbonoInfantil
        text: qsTrId("Registrar compra")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: cuenta_alumno !== null && precioAbono !== "" && abonoInfantilDelMes.abono_infantil_compra === null

        onClicked: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var id_abono_infantil_compra = wrapper.managerAbonoInfantil.comprarAbonoInfantil(buscador.recordClienteSeleccionado.id, idAbonoInfantilSeleccionado, precioAbono);
            var codigo_oculto_movimiento = "AAI"+id_abono_infantil_compra

            alumnoFueMatriculado = false
            if (alumnoMatriculado == false){
                alumnoFueMatriculado = wrapper.managerAbonoInfantil.matricularAlumno(buscador.recordClienteSeleccionado.id)
                codigo_oculto_movimiento = "AMAI"+id_abono_infantil_compra
            }

            var id_movimiento

            if (radioDebitarDeCuenta.checked){
                console.debug("radioDebitarDeCuenta")

                if (alumnoMatriculado)
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                else
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(precioAbono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
            }
            else if(radioRegistrarPagoAbono.checked){
                console.debug("radioRegistrarPagoAbono")
                if (alumnoMatriculado)
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                else
                    id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(precioAbono+precioMatricula),"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSMAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                if (id_movimiento !== -1) {
                    if (alumnoMatriculado)
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    else
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(precioAbono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                }
            }
            else if (radioRegistrarPagoDiferencia.checked || radioRegistrarPagoTotal.checked) {
                console.debug("radioRegistrarPagoDiferencia")
                var texto = "Carga diferencia"
                var codigo
                if (alumnoMatriculado)
                    codigo = "CSAI"+id_abono_infantil_compra
                else
                    codigo = "CSMAI"+id_abono_infantil_compra
                if (radioRegistrarPagoTotal.checked) {
                    if (alumnoMatriculado)
                        texto = "Carga por el abono y la deuda"
                    else
                        texto = "Carga por la matrícula, abono y la deuda"
                }
                id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,varDeuda,texto,cuenta_alumno,resumen_mes_alumno,codigo) //Comprar Abono Infantil Paga Deuda
                if (id_movimiento !== -1) {
                    if (alumnoMatriculado)
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    else
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(precioAbono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                }
            }
            else if (radioRegistrarPagoPersonalizado.checked) {
                console.debug("radioRegistrarPagoPersonalizado")
                if (txtMontoIngresado.length > 0) {

                    var montoIngresado = txtMontoIngresado.text

                    if (alumnoMatriculado)
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,montoIngresado,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                    else
                        id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,montoIngresado,"Carga saldo",cuenta_alumno,resumen_mes_alumno,"CSMAI"+id_abono_infantil_compra) //Comprar Abono Infantil
                    if (id_movimiento !== -1) {
                        if (alumnoMatriculado)
                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,precioAbono*(-1),"Adquisición abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                        else
                            id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(precioAbono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+group.current.text+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)
                    }
                }
            }

            if (!alumnoMatriculado)
                alumnoMatriculado = alumnoFueMatriculado


            if (id_movimiento !== -1 && id_abono_infantil_compra !== -1 && alumnoMatriculado !== false) {
                wrapper.gestionBaseDeDatos.commitTransaction()
                var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                if (alumnoFueMatriculado)
                    messageDialog.text = "Compra de matrícula y abono infantil Nº "+id_abono_infantil_compra+" exitosa.\n" + strDatosDelRegistroDePresente
                else
                    messageDialog.text = "Compra de abono infantil Nº "+id_abono_infantil_compra+" exitosa.\n" + strDatosDelRegistroDePresente
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
