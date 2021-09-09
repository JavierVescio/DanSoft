import "qrc:/components"
import com.mednet.CMAlumno 1.0
import com.mednet.WrapperClassManagement 1.0
import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4

Rectangle {
    id: principal
    anchors.fill: parent
    opacity: 0.7
    enabled: false
    property variant p_objPestania
    Behavior on opacity {PropertyAnimation{}}
    color: "#F5F5F5"

    property color backColorSubtitles: "#FFCDD2"
    //property color backColorSubtitles: "#D7CCC8"
    property string strSinInfoDeClase: qsTrId("")

    property int intContentWidth: 700
    property int intContentHeight: 400

    property int idClaseAsistencia : -1
    property variant recordClienteSeleccionado: null

    property var cuenta_alumno: null
    property var resumen_mes_alumno: null
    property var listaPrecioIdAbonoMasCaro: null

    property int nro_anio: (new Date()).getFullYear()


    function recargar() {
        if (idClaseAsistencia !== -1 && comboMes.currentIndex !== -1)
            cargarFormulario()
    }

    function cargarFormulario() {
        limpiar()

        //var superLista = wrapper.managerAbonoInfantil.traerAlumnosQueCompraronAbonoInfantilConDiasDePresentesMasMovimientos(comboMes.currentIndex+1,nro_anio,idClaseAsistencia);

        var superLista = wrapper.managerAbonoInfantil.traerAlumnosInscriptosConDiasDePresentesMasMovimientos(comboMes.currentIndex+1,nro_anio,idClaseAsistencia);

        var total_dias_mes = wrapper.classManagementManager.totalDiasDelMes(comboMes.currentIndex+1,nro_anio);

        tablaAlumnosAsistenciasMovimientos.totalDiasMes = total_dias_mes
        tablaAlumnosAsistenciasMovimientos.model = superLista
        tablaAlumnosAsistenciasMovimientos.selection.select(0)
        tablaAlumnosAsistenciasMovimientos.focus = true



        /*
        var component, recComponenteDia
        var incremento;
        for (incremento=0;incremento<arg.length;incremento++){
            component = Qt.createComponent("../components/ClientesAsistidoresClase.qml");
            recComponenteDia = component.createObject(columnaAlumnos, {"recordCliente": arg[incremento],"id_clase": idClaseAsistencia, "nro_mes":comboMes.currentIndex+1, "nro_anio":2018});
        }

        intContentWidth = 31*63
        intContentHeight = arg.length * 60*/
    }

    function limpiar() {
        /*for(var i = columnaAlumnos.children.length; i > 0 ; i--) {
            columnaAlumnos.children[i-1].destroy()
        }*/
        tablaAlumnosAsistenciasMovimientos.model = 0

        recordClienteSeleccionado = null
        tablaPresentes.model = 0
        abonoInfantilDelMes.abono_infantil_compra = null
        //abonoInfantilDelMes.height = 16
        abonoInfantilDelMes.montoDeudaPotencial = -1
        abonoInfantilDelMes.estadoPresentePotencial = -1
        saldoMovimientos.tableViewMovimientos.model = 0
        cuenta_alumno = null
        listaPrecioIdAbonoMasCaro = null
        wrapper.classManagementManager.clienteSeleccionado = null
    }

    function traerInfoDelAbonoDelAlumnoInfantil() {
        abonoInfantilDelMes.abono_infantil_compra = wrapper.managerAbonoInfantil.traerCompraDeAbonoInfantil(recordClienteSeleccionado.id)
        abonoInfantilDelMes.alumno_matriculado = wrapper.classManagementGestionDeAlumnos.alumnoConMatriculaVigente(recordClienteSeleccionado.fecha_matriculacion_infantil)

        if (abonoInfantilDelMes.alumno_matriculado){
            abonoInfantilDelMes.strEstadoMatriculacion = "alumno matriculado"
        }else{
            abonoInfantilDelMes.strEstadoMatriculacion = "sin matrícula"
        }

        if (abonoInfantilDelMes.abono_infantil_compra == null) {
            tablaPresentes.model = 0
        }
        else {
            var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
            tablaPresentes.model = modelo
            tablaPresentes.currentRow = -1

            abonoInfantilDelMes.montoDeudaPotencial = wrapper.managerAbonoInfantil.obtenerPrecioDelAbonoQueOfreceUnaClaseMasPorSem(abonoInfantilDelMes.abono_infantil_compra.clases_por_semana) - abonoInfantilDelMes.abono_infantil_compra.precio_abono
            abonoInfantilDelMes.estadoPresentePotencial = wrapper.managerAbonoInfantil.verificarSiEstaCubiertoElPresente(modelo,abonoInfantilDelMes.abono_infantil_compra.clases_por_semana);
        }
    }

    onRecordClienteSeleccionadoChanged: {
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
                    wrapper.gestionBaseDeDatos.commitTransaction()

                    traerInfoDelAbonoDelAlumnoInfantil()
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
            }
        }
        else {
            limpiar()
        }
    }


    WrapperClassManagement {
        id: wrapper
    }

    Inscripciones {
        id: inscripciones
        visible: false
        z: 25
    }

    MessageDialog {
        id: messageDialog
        title: "Niños"
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

    MessageDialog {
        id: messageAnularPresenteYAcreditar
        icon: StandardIcon.Question
        title: "Anular Presente"
        property int nro_presente: -1
        text: "Anularemos el presente Nº "+nro_presente + " y acreditaremos una clase adicional al abono Nº "+(abonoInfantilDelMes.abono_infantil_compra !== null ? abonoInfantilDelMes.abono_infantil_compra.id : -1)+" del alumno, ya que con dicho abono se había registrado el presente.\n\n¿Seguro que desea anular el presente?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (wrapper.managerAbonoInfantil.anularPresente(nro_presente)) {
                var idRowSelected = tablaAlumnosAsistenciasMovimientos.currentRow
                var modelo = wrapper.managerAbonoInfantil.traerPresentesPorAbonoInfantilComprado(abonoInfantilDelMes.abono_infantil_compra.id)
                tablaPresentes.model = modelo
                tablaPresentes.currentRow = -1
                traerInfoDelAbonoDelAlumnoInfantil()
                limpiar()
                recargar()
                tablaAlumnosAsistenciasMovimientos.selection.clear()
                tablaAlumnosAsistenciasMovimientos.currentRow = idRowSelected
                tablaAlumnosAsistenciasMovimientos.selection.select(idRowSelected)
                tablaAlumnosAsistenciasMovimientos.focus = true
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
        id: messageDialogYesNo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            wrapper.gestionBaseDeDatos.beginTransaction()

            var codigo_oculto = "MA"+abonoInfantilDelMes.abono_infantil_compra.id
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
                    limpiar()
                }
            }
            else {
                wrapper.gestionBaseDeDatos.rollbackTransaction()
                messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                messageDialog.icon = StandardIcon.Warning
                messageDialog.open()
                limpiar()
            }
        }
    }


    MessageDialog {
        id: messageDialogYesNoTwo
        title: "Niños"

        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            btnRegistrarPresente.realizarRegistro()
        }

    }

    SelectorClaseDeDanza {
        id: selectorDeDanza
        z: 10
        visible: false
        filtroCategoria: "Kids"

        onClaseAsistencia: {
            lblAsistiendoClase.text = nombreClase
            idClaseAsistencia = idClase
            inscripciones.idClase = idClaseAsistencia

            if (idClaseAsistencia !== -1 && comboMes.currentIndex !== -1){
                cargarFormulario()
            }
        }

        onClaseNoSeleccionada: {
            lblAsistiendoClase.text = strSinInfoDeClase
            idClaseAsistencia = -1
            inscripciones.idClase = -1
            limpiar()
        }
    }


    Connections {
        target: principal.enabled ? wrapper.managerAsistencias : null
        //target: wrapper.managerAsistencias
        ignoreUnknownSignals: true

        onSig_intentarRegistrarPresenteTablaInfantil: {
            if (btnRegistrarPresente.enabled)
                btnRegistrarPresente.intentarRegistrarPresente()
        }
    }

    Connections {
        target: wrapper.classManagementManager

        onClienteSeleccionadoChanged: {
            recordClienteSeleccionado = clienteSeleccionado


        }


    }

    Rectangle {
        id: recFecha
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.rightMargin: -1
        anchors.right: parent.right
        height: 35
        //color: backColorSubtitles
        z: 1


        Row {
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.left: parent.left
            spacing: 3
            anchors.leftMargin: 3

            ComboBox {
                id: comboMes
                height: 28
                width: 110
                currentIndex: (new Date()).getMonth()

                model: ListModel {
                    ListElement { text: "1. Enero" }
                    ListElement { text: "2. Febrero" }
                    ListElement { text: "3. Marzo" }
                    ListElement { text: "4. Abril" }
                    ListElement { text: "5. Mayo" }
                    ListElement { text: "6. Junio" }
                    ListElement { text: "7. Julio" }
                    ListElement { text: "8. Agosto" }
                    ListElement { text: "9. Septiembre" }
                    ListElement { text: "10. Octubre" }
                    ListElement { text: "11. Noviembre" }
                    ListElement { text: "12. Diciembre" }
                }

                onCurrentIndexChanged: {
                    if (comboMes.currentIndex !== -1) {
                        wrapper.managerAsistencias.enviarSenialCambioDeMes()

                        if (idClaseAsistencia !== -1)
                            cargarFormulario()
                    }

                }

            }

            Button {
                text: qsTrId("Seleccionar clase")
                width: 100
                height: 30
                y: -1

                onClicked: {
                    selectorDeDanza.visible = true
                }
            }

            Image {
                source: "qrc:/media/Media/actividades.PNG"
                fillMode: Image.PreserveAspectFit
                width: 28
            }

            Button {
                id: btnInscripciones
                text: qsTrId("Inscripciones")
                width: 100
                height: 30
                enabled: idClaseAsistencia !== -1
                y: -1

                onClicked: {
                    //selectorDeDanza.visible = true
                    inscripciones.visible = true
                }
            }

            Text {
                id: lblAsistiendoClase
                font.family: "verdana"
                font.pixelSize: 12
                text: strSinInfoDeClase
                y: 10
            }

            Text {
                id: lblTotalAlumnos
                font.family: "verdana"
                font.pixelSize: 12
                visible: tablaAlumnosAsistenciasMovimientos.model.length > 0
                text: " || Alumnos inscriptos a la clase: " + tablaAlumnosAsistenciasMovimientos.model.length
                y: 10
            }

        }


        Button {
            id: btnAceptar
            anchors.top: parent.top
            anchors.right: parent.right
            visible: false
            anchors.margins: 3
            text: "Aceptar / Recargar"
            enabled: idClaseAsistencia !== -1 && comboMes.currentIndex !== -1

            onClicked:  {
                cargarFormulario()
            }
        }

    }

    SplitView {
        anchors.top: recFecha.bottom
        anchors.left: parent.left
        anchors.leftMargin: -1
        anchors.right: parent.right
        anchors.rightMargin: -1
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical

        Rectangle {
            Layout.fillHeight: false
            //Layout.minimumHeight: 0
            height: 250

            TablaAsistenciasMovimientos {
                id: tablaAlumnosAsistenciasMovimientos
                height: parent.height - 30
                width: parent.width


                onClicked: {
                    if (currentRow != -1) {
                        recordClienteSeleccionado = model[currentRow].alumno
                    }
                }

                onCurrentRowChanged: {
                    if (currentRow != -1) {
                        recordClienteSeleccionado = model[currentRow].alumno
                    }
                }
            }
        }

        Rectangle {
            id: recInformacion
            height: 175
            Layout.minimumHeight: 150

            Button {
                id: btnAnularPresente
                text: "Anular pres."
                iconSource: "qrc:/media/Media/salir.png"
                enabled: tablaPresentes.currentRow !== -1
                anchors.bottom: rowData.top
                anchors.bottomMargin: 3
                height: btnRegistrarPresente.height
                anchors.right: btnRegistrarPresente.left

                onClicked: {
                    if (tablaPresentes.currentRow !== -1) {
                        var id_presente = tablaPresentes.model[tablaPresentes.currentRow].id
                        var recordAbonoInfantil = abonoInfantilDelMes.abono_infantil_compra

                        messageAnularPresenteYAcreditar.nro_presente = id_presente
                        messageAnularPresenteYAcreditar.open()
                    }
                }
            }

            Button {
                id: btnRegistrarPresente
                text: qsTrId("Registrar presente con fecha y hora de hoy")
                anchors.bottom: rowData.top
                anchors.rightMargin: 3
                anchors.bottomMargin: 3
                anchors.right: parent.right
                width: 250
                height: 30
                enabled: idClaseAsistencia !== -1 && recordClienteSeleccionado !== null //&& abonoInfantilDelMes.abono_infantil_compra !== null && abonoInfantilDelMes.abono_infantil_compra.estado === "Habilitado"



                onClicked: {
                    intentarRegistrarPresente()
                }

                function intentarRegistrarPresente() {
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
                    var registroCompraAbono = wrapper.managerAbonoInfantil.comprarAbonoAutomaticamente(recordClienteSeleccionado.id,true)
                    if (registroCompraAbono !== null){
                        var codigo_oculto_movimiento = "AAI"+registroCompraAbono.id
                        var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,registroCompraAbono.precio_abono*(-1),"Adquisición abono infantil "+registroCompraAbono.clases_por_semana+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                        if (id_movimiento !== -1) {
                            id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(registroCompraAbono.id, idClaseAsistencia)
                            if (id_presente !== -1)
                                salioTodoBien = true
                        }
                    }

                    var idRowSelected = tablaAlumnosAsistenciasMovimientos.currentRow
                    if (salioTodoBien){
                        wrapper.gestionBaseDeDatos.commitTransaction()
                        var strDatosDelRegistroDePresente = "Alumno/a: " + recordClienteSeleccionado.apellido + " " + recordClienteSeleccionado.primerNombre
                        messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente + "\n\nSe realizó una compra de abono automáticamente."
                        messageDialog.icon = StandardIcon.Information

                    }else{
                        wrapper.gestionBaseDeDatos.rollbackTransaction()
                        messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                    limpiar()
                    recargar()
                    tablaAlumnosAsistenciasMovimientos.selection.clear()
                    tablaAlumnosAsistenciasMovimientos.currentRow = idRowSelected
                    tablaAlumnosAsistenciasMovimientos.selection.select(idRowSelected)
                    tablaAlumnosAsistenciasMovimientos.focus = true
                }

                function realizarRegistroMasAbonoConMatricula(){
                    wrapper.gestionBaseDeDatos.beginTransaction()

                    var salioTodoBien = false
                    var id_presente = -1
                    var precioMatricula = wrapper.managerAbonoInfantil.traerPrecioMatricula()
                    var registroCompraAbono = wrapper.managerAbonoInfantil.comprarAbonoAutomaticamente(recordClienteSeleccionado.id,false)
                    if (registroCompraAbono !== null){
                        var codigo_oculto_movimiento = "AMAI"+registroCompraAbono.id
                        var id_movimiento = wrapper.managerCuentaAlumno.crearMovimiento(-1,cuenta_alumno.id,(registroCompraAbono.precio_abono*(-1))+(precioMatricula*(-1)),"Adquisición matrícula y abono infantil "+registroCompraAbono.clases_por_semana+" clas/sem",cuenta_alumno,resumen_mes_alumno,codigo_oculto_movimiento)

                        if (id_movimiento !== -1) {
                            id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(registroCompraAbono.id, idClaseAsistencia)
                            if (id_presente !== -1)
                                salioTodoBien = true
                        }
                    }

                    var idRowSelected = tablaAlumnosAsistenciasMovimientos.currentRow
                    if (salioTodoBien){
                        wrapper.gestionBaseDeDatos.commitTransaction()
                        var strDatosDelRegistroDePresente = "Alumno/a: " + recordClienteSeleccionado.apellido + " " + recordClienteSeleccionado.primerNombre
                        messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente + "\n\nSe realizó una compra de matrícula y de abono automáticamente."
                        messageDialog.icon = StandardIcon.Information

                    }else{
                        wrapper.gestionBaseDeDatos.rollbackTransaction()
                        messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                    limpiar()
                    recargar()
                    tablaAlumnosAsistenciasMovimientos.selection.clear()
                    tablaAlumnosAsistenciasMovimientos.currentRow = idRowSelected
                    tablaAlumnosAsistenciasMovimientos.selection.select(idRowSelected)
                    tablaAlumnosAsistenciasMovimientos.focus = true
                }

                function realizarRegistro() {
                    var idRowSelected = tablaAlumnosAsistenciasMovimientos.currentRow
                    var id_presente = wrapper.managerAbonoInfantil.registrarPresenteInfantil(abonoInfantilDelMes.abono_infantil_compra.id, idClaseAsistencia)

                    if (id_presente !== -1) {
                        var strDatosDelRegistroDePresente = "Alumno/a: " + recordClienteSeleccionado.apellido + " " + recordClienteSeleccionado.primerNombre
                        messageDialog.text = "Registro de presente infantil Nº "+id_presente+" exitoso.\n" + strDatosDelRegistroDePresente
                        messageDialog.icon = StandardIcon.Information
                    }
                    else {
                        messageDialog.text = "Algo no salió bien. Intentá otra vez!"
                        messageDialog.icon = StandardIcon.Warning
                    }
                    messageDialog.open()
                    limpiar()
                    recargar()
                    tablaAlumnosAsistenciasMovimientos.selection.clear()
                    tablaAlumnosAsistenciasMovimientos.currentRow = idRowSelected
                    tablaAlumnosAsistenciasMovimientos.selection.select(idRowSelected)
                    tablaAlumnosAsistenciasMovimientos.focus = true
                }
            }

            AbonoInfantilDelMes {
                id: abonoInfantilDelMes
                anchors.top: parent.top
                anchors.left: parent.left
                height: 75
                x:3
            }

            Text {
                anchors.bottom: btnRegistrarPresente.top
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignTop
                font.family: "verdana"
                font.pixelSize: 14
                text: recordClienteSeleccionado !== null ? recordClienteSeleccionado.apellido + ", " + recordClienteSeleccionado.primerNombre : ""
            }




            SplitView {
                id: rowData
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: abonoInfantilDelMes.bottom
                orientation: Qt.Horizontal

                SaldoMovimientos {
                    id: saldoMovimientos
                    width: parent.width / 2
                    Layout.minimumWidth: parent.width / 3
                    Layout.fillWidth: true
                }

                TableView {
                    id: tablaPresentes
                    Layout.minimumWidth: parent.width / 3
                    Layout.fillWidth: true

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
                        title: "Asistencias de este mes (todas las clases)"
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
    }
}

