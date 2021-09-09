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
    property variant p_objPestania
    property color backColorSubtitles: "#FFCDD2"
    property color colorSubtitles: "black"

    property string strSinInformacion: qsTrId("\tSin información disponible")
    property string strEstadoMatriculacion: "sin matrícula"
    property bool alumnoMatriculado: false

    Behavior on opacity {PropertyAnimation{}}

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null
    property int idClaseAsistencia : -1
    property var listaPrecioIdAbonoMasCaro: null



    WrapperClassManagement {
        id: wrapper
    }


    function limpiarFormulario() {
        //buscador.modeloAlumnos = 0
        //buscador.recordClienteSeleccionado = null
        tablaPresentes.model = 0
        abonoInfantilDelMes.abono_infantil_compra = null
        abonoInfantilDelMes.height = 16
        abonoInfantilDelMes.montoDeudaPotencial = -1
        abonoInfantilDelMes.estadoPresentePotencial = -1
        saldoMovimientos.tableViewMovimientos.model = 0
        columnaDatos.enabled = false
        cuenta_alumno = null
        listaPrecioIdAbonoMasCaro = null
        buscador.focoEnDNI()
        if (buscador.recordClienteSeleccionado !== null)
            buscador.onClienteSeleccionado()
    }

    //    function limpiarFormulario() {
    //        buscador.modeloAlumnos = 0
    //        buscador.recordClienteSeleccionado = null
    //        tablaPresentes.model = 0
    //        abonoInfantilDelMes.abono_infantil_compra = null
    //        abonoInfantilDelMes.height = 16
    //        abonoInfantilDelMes.montoDeudaPotencial = -1
    //        abonoInfantilDelMes.estadoPresentePotencial = -1
    //        saldoMovimientos.tableViewMovimientos.model = 0
    //        columnaDatos.enabled = false
    //        cuenta_alumno = null
    //        listaPrecioIdAbonoMasCaro = null
    //        buscador.focoEnDNI()
    //    }

    MessageDialog {
        id: messageDialog
        title: "Niños"
    }

    MessageDialog {
        id: messageAnularPresenteYAcreditar
        icon: StandardIcon.Question
        title: "Anular Presente"
        property int nro_presente: -1
        text: "Anularemos el presente Nº "+nro_presente + " y acreditaremos una clase adicional al abono Nº "+(abonoInfantilDelMes.abono_infantil_compra !== null ? abonoInfantilDelMes.abono_infantil_compra.id : -1)+" del alumno, ya que con dicho abono se había registrado el presente.\n\n¿Seguro que desea anular el presente?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (wrapper.managerAbonoInfantil.anularPresente(nro_presente)) {
                var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
                tablaPresentes.model = modelo
                tablaPresentes.currentRow = -1
                buscador.traerInfoDelAbonoDelAlumnoInfantil()
                ///FALTA QUE SE REFRESQUE LA LEYENDA QUE DICE 'ULTIMO PRESENTE CUBIERTO'...
            }else{
                messageError.open()
            }
        }
    }

    MessageDialog {
        id: messageError
        title: "Registrar presente infantil"
        icon: StandardIcon.Critical
        text: qsTrId("Ups! Algo no fue bien.")
    }

    MessageDialog {
        id: messageDialogYesNoTwo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnRegistrarPresente.realizarRegistro()
        }

    }


    MessageDialog {
        id: messageDialogYesNo
        title: "Niños"
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var codigo_oculto = "MAI"+abonoInfantilDelMes.abono_infantil_compra.id
            var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,abonoInfantilDelMes.montoDeudaPotencial*(-1),"Mejora abono a "+wrapper.managerAbonoInfantil.obtenerTotalClasesAbonoSuperior()+" clases/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto)
            if (id_movimiento !== -1) {
                //

                var id_abono_actual = abonoInfantilDelMes.abono_infantil_compra.id
                var id_nuevo_abono = wrapper.managerAbonoInfantil.obtenerIdAbonoSuperior();
                var precio_abono_a_sumar = abonoInfantilDelMes.montoDeudaPotencial

                if (wrapper.managerAbonoInfantil.actualizarAbonoComprado(id_abono_actual,id_nuevo_abono,precio_abono_a_sumar)){
                    wrapper.gestionBaseDeDatos.commitTransaction()
                    btnRegistrarPresente.realizarRegistro()
                }else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                    messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                    messageDialog.icon = StandardIcon.Warning
                    messageDialog.open()
                    limpiarFormulario()
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
                limpiarFormulario()
            }
        }
    }

    MessageDialog {
        id: messageDialogYesNoCompraAbono
        icon: StandardIcon.Question
        title: "Niños - Alumno/a sin abono"
        text: "Si continuás, automáticamente se debitará de la cuenta del alumno/a el precio de un abono.\nEl abono será el mismo que compró la última vez el alumno/a pero si es su primera vez, será entonces el de menor cantidad de clases/sem.\n\n¿Cobrarle el abono y registrar presente?"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnRegistrarPresente.realizarRegistroMasAbono()
        }
    }

    MessageDialog {
        id: messageDialogYesNoCompraAbonoMatricula
        icon: StandardIcon.Question
        title: "Niños - Alumno/a sin matrícula ni abono"
        text: "Si continuás, automáticamente se debitará de la cuenta del alumno/a el precio de la matrícula y el precio de un abono.\nEl abono será el mismo que compró la última vez el alumno/a pero si es su primera vez, será entonces el de menor cantidad de clases/sem.\n\n¿Cobrarle la matrícula + abono y registrar presente?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnRegistrarPresente.realizarRegistroMasAbonoConMatricula()
        }
    }



    SelectorClaseDeDanza {
        id: selectorDeDanza
        z: 10
        visible: false
        filtroCategoria: "Kids"

        onClaseAsistencia: {
            lblAsistiendoClase.text = "\t" + nombreClase
            idClaseAsistencia = idClase
        }

        onClaseNoSeleccionada: {
            lblAsistiendoClase.text = strSinInformacion
            idClaseAsistencia = -1
        }
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
            if (recordClienteSeleccionado !== null) {
                wrapper.gestionBaseDeDatos.beginTransaction()
                cuenta_alumno = wrapper.managerCuentaAlumno.traerCuentaAlumnoPorIdAlumno(recordClienteSeleccionado.id)
                if (cuenta_alumno !== null) {
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    wrapper.gestionBaseDeDatos.beginTransaction()
                    resumen_mes_alumno = wrapper.managerCuentaAlumno.traerResumenMesPorClienteFecha(recordClienteSeleccionado.id,true)

                    if (resumen_mes_alumno !== null) {
                        saldoMovimientos.tableViewMovimientos.model = wrapper.managerCuentaAlumno.traerTodosLosMovimientosPorCuenta(cuenta_alumno.id)
                        saldoMovimientos.tableViewMovimientos.resizeColumnsToContents()
                        columnaDatos.enabled = true
                        wrapper.gestionBaseDeDatos.commitTransaction()

                        alumnoMatriculado = wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaInfantilVigente(recordClienteSeleccionado.id)
                        if (alumnoMatriculado){
                            strEstadoMatriculacion = "alumno matriculado"
                        }else{
                            strEstadoMatriculacion = "sin matrícula"
                        }

                        traerInfoDelAbonoDelAlumnoInfantil()
                    }
                }
                else {
                    wrapper.gestionBaseDeDatos.rollbackTransaction()
                }
            }
            else {
                limpiarFormulario()
            }
        }

        function traerInfoDelAbonoDelAlumnoInfantil() {
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
                tablaPresentes.currentRow = -1

                abonoInfantilDelMes.montoDeudaPotencial = wrapper.managerAbonoInfantil.obtenerPrecioDelAbonoQueOfreceUnaClaseMasPorSem(abonoInfantilDelMes.abono_infantil_compra.clases_por_semana) - abonoInfantilDelMes.abono_infantil_compra.precio_abono
                abonoInfantilDelMes.estadoPresentePotencial = wrapper.managerAbonoInfantil.verificarSiEstaCubiertoElPresente(modelo,abonoInfantilDelMes.abono_infantil_compra.clases_por_semana);
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
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.bottomMargin: 10
        anchors.right: detallesDelCliente.left
        anchors.bottom: btnRegistrarPresente.top
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
                    text: qsTrId("Cuenta del alumno")
                }

                Text {
                    anchors.fill: parent
                    anchors.rightMargin: columnaDatos.separacionIzquierda
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.family: "verdana";
                    font.pixelSize: 14
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
            }

            SaldoMovimientos {
                id: saldoMovimientos
                height: 85
                width: flickDatos.width
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
                    text: qsTrId("Abono del alumno")// + " (" + strEstadoMatriculacion + ")"
                }
            }

            AbonoInfantilDelMes {
                id: abonoInfantilDelMes
                height: 16
                width: flickDatos.width
            }

            //ultimos presentes aca

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
                    text: qsTrId("Asistiendo a clase")
                }
            }

            Row {
                spacing: 5

                Text {
                    id: lblAsistiendoClase
                    font.family: "verdana"
                    font.pixelSize: 12
                    y: 2
                    text: strSinInformacion
                }

                Button {
                    text: qsTrId("Seleccionar clase")
                    y: -2

                    onClicked: {
                        selectorDeDanza.visible = true
                    }
                }
            }

            Button {
                id: btnAnularPresente
                text: "Anular presente seleccionado"
                enabled: tablaPresentes.currentRow !== -1
                x: 3
                width: 175

                onClicked: {
                    if (tablaPresentes.currentRow !== -1) {
                        var id_presente = tablaPresentes.model[tablaPresentes.currentRow].id
                        var recordAbonoInfantil = abonoInfantilDelMes.abono_infantil_compra

                        messageAnularPresenteYAcreditar.nro_presente = id_presente
                        messageAnularPresenteYAcreditar.open()
                    }
                }
            }

            TableView {
                id: tablaPresentes
                height: 170
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
                }

                TableViewColumn {
                    role: "nombre_clase"
                    title: "Clase"
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
        }
    }

    Button {
        id: btnRegistrarPresente
        text: {
            if (buscador.recordClienteSeleccionado === null) {
                "Registrar presente usando abono"
            }
            else {
                if (abonoInfantilDelMes.abono_infantil_compra === null){
                    if (abonoInfantilDelMes.alumno_matriculado)
                        "Registrar presente (se cobrará un abono)"
                    else
                        "Registrar presente (se cobrará matrícula y abono)"
                }
                else {
                    "Registrar presente usando abono Nº " + abonoInfantilDelMes.abono_infantil_compra.id
                }
            }
        }
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -2
        anchors.bottomMargin: -2
        width: 300
        height: 40
        enabled: idClaseAsistencia !== -1 && buscador.recordClienteSeleccionado !== null



        onClicked: {
            if (abonoInfantilDelMes.estadoPresentePotencial === 2) {
                if (abonoInfantilDelMes.montoDeudaPotencial > 0) {
                    messageDialogYesNo.text = "Límite de presentes ya alcanzado. Intentaremos mejorar el abono actual para que admita más clases por semana pero se debitarán $ " + abonoInfantilDelMes.montoDeudaPotencial + " de la cuenta del alumno por la diferencia de precio entre el abono que admite más clases y el que ya había adquirido el alumno.

Actualmente el saldo de la cuenta del alumno es de $ "+cuenta_alumno.credito_actual+" y de ese saldo se debitarán $ "+abonoInfantilDelMes.montoDeudaPotencial+" en concepto de mejora de abono, lo cual resultará en un saldo de cuenta de $ "+(cuenta_alumno.credito_actual-abonoInfantilDelMes.montoDeudaPotencial)+".

¿Seguro que desea continuar con el registro del presente?"

                    messageDialogYesNo.title = "Niños - Registro de presente no cubierto por abono"
                    messageDialogYesNo.icon = StandardIcon.Warning
                    messageDialogYesNo.open()
                }
                else {
                    messageDialogYesNoTwo.text = "Límite de presentes ya alcanzado. Actualmente no se encuentra habilitado un abono superior al que ya cuenta el alumno que le permita tomar más clases.

Para tener en cuenta:
1.- En las ofertas de abonos puede habilitar a alguno que admita más clases.
Si lo hace, es muy importante que cierre la pestaña de registro de presente infantil (luego puede volver a abrirla), de otra forma, los cambios que haga en las ofertas de abono puede que no se vean reflejados.

2.- Si cree que no es posible que el alumno haya podido sobrepasar el límite de clases, verifique los presentes registrados del alumno en busca de algún registro que se haya cargado accidentalmente más de una vez en un mismo día.

Si usted lo desea, puede registrar el presente con este abono de todas formas e ignorar el límite impuesto por dicho abono. No le cobraremos nada al alumno (ya que como no hay disponible un abono superior, se considera que el abono actual cubre el presente) pero si usted deseara cobrarle esta asistencia, puede hacerlo desde el módulo de cuenta del alumno.

¿Seguro que desea registrar el presente de todas formas?"

                    messageDialogYesNoTwo.title = "Niños - Registro de presente no cubierto por abono"
                    messageDialogYesNoTwo.icon = StandardIcon.Warning
                    messageDialogYesNoTwo.open()
                }



            }
            else {
                if (abonoInfantilDelMes.abono_infantil_compra == null) {
                    if (abonoInfantilDelMes.alumno_matriculado == false){
                        //Comprarle abono y matricula
                        messageDialogYesNoCompraAbonoMatricula.open()
                    }else{
                        //Comprarle abono
                        messageDialogYesNoCompraAbono.open()
                    }
                }else
                    realizarRegistro()
            }
        }

        function realizarRegistroMasAbono(){
            wrapper.gestionBaseDeDatos.beginTransaction()

            var salioTodoBien = false
            var id_presente = -1
            var registroCompraAbono = wrapper.managerAbonoInfantil.comprarAbonoAutomaticamente(buscador.recordClienteSeleccionado.id,true)
            if (registroCompraAbono !== null){
                var codigo_oculto_movimiento = "AAI"+registroCompraAbono.id
                var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,registroCompraAbono.precio_abono*(-1),"Adquisición abono infantil "+registroCompraAbono.clases_por_semana+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                if (id_movimiento !== -1) {
                    id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(registroCompraAbono.id, idClaseAsistencia)
                    if (id_presente !== -1)
                        salioTodoBien = true
                }
            }

            if (salioTodoBien){
                wrapper.gestionBaseDeDatos.commitTransaction()
                var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente + "\n\nSe realizó una compra de abono automáticamente."
                messageDialog.icon = StandardIcon.Information

            }else{
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
            }
            messageDialog.open()
            limpiarFormulario()
        }

        function realizarRegistroMasAbonoConMatricula(){
            wrapper.gestionBaseDeDatos.beginTransaction()

            var salioTodoBien = false
            var id_presente = -1
            var precioMatricula = wrapper.managerAbonoInfantil.traerPrecioMatricula()
            var registroCompraAbono = wrapper.managerAbonoInfantil.comprarAbonoAutomaticamente(buscador.recordClienteSeleccionado.id,false)
            if (registroCompraAbono !== null){
                var codigo_oculto_movimiento = "AMAI"+registroCompraAbono.id
                var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(registroCompraAbono.precio_abono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+registroCompraAbono.clases_por_semana+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                if (id_movimiento !== -1) {
                    id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(registroCompraAbono.id, idClaseAsistencia)
                    if (id_presente !== -1)
                        salioTodoBien = true
                }
            }

            if (salioTodoBien){
                wrapper.gestionBaseDeDatos.commitTransaction()
                var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente + "\n\nSe realizó una compra de matrícula y de abono automáticamente."
                messageDialog.icon = StandardIcon.Information

            }else{
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
            }
            messageDialog.open()
            limpiarFormulario()
        }

        function realizarRegistro() {
            var id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(abonoInfantilDelMes.abono_infantil_compra.id, idClaseAsistencia)

            if (id_presente !== -1) {
                var strDatosDelRegistroDePresente = "Alumno/a: " + buscador.recordClienteSeleccionado.apellido + " " + buscador.recordClienteSeleccionado.primerNombre
                messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente
                messageDialog.icon = StandardIcon.Information
            }
            else {
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
            }
            messageDialog.open()
            limpiarFormulario()
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
